//
//  HttpManager.swift
//  WaltDemo
//
//  Created by apple on 2019/9/16.
//  Copyright © 2019年 yiqilai company. All rights reserved.
//

//import UIKit
//import Foundation
//import Alamofire
//import GTMBase64
//import web3swift
//import CryptoSwift

import UIKit
import Alamofire
import GTMBase64
import web3swift
import BigInt


/// 网络请求成功返回block
typealias successBlock = ([String : AnyObject]) ->()
/// 网络请求失败返回block
typealias failureBlock = (NSError) ->()


class HttpManager: NSObject {

    static let shared = HttpManager()
    
    var managerAccount: SessionManager!
    
    //MARK: - 网络请求方法
    
    func POST(url:String, parameters: Parameters,success:@escaping successBlock,falied:@escaping failureBlock) -> Void {
        
        print("POST请求URL:\(url),参数:\(parameters)")
        
        //POST这里使用JSONEncoding.default
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response) in
            
            print("POST请求结果:\(response)")
            
            switch response.result {
            case .success(let value):
                success(value as! [String : AnyObject])
            case .failure(let error):
                falied(error as NSError)
            }
        }
    }
    func GET(url:String, parameters: Parameters,success:@escaping successBlock,falied:@escaping failureBlock) -> Void {
        
        print("GET请求URL:\(url),参数:\(parameters)")
        
        //POST这里使用JSONEncoding.default
        Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default).responseJSON { (response) in
            
            print("GET请求结果:\(response)")
            //printLog(message: "GET请求结果response.request:\(response.request)")
            
            switch response.result {
            case .success(let value):
                success(value as! [String : AnyObject])
            case .failure(let error):
                falied(error as NSError)
            }
        }
    }
    
    
    //MARK: 根据地址获取账户余额
    func getAccountBalance(address: String, complete: @escaping (Bool, String) -> Void) {

        //请求的URL HOST
        let host = Network.shared.url()
        
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 2.0
        managerAccount = Alamofire.SessionManager(configuration: config)
        
        //XY: 地址链接
        let urlString = "\(host)/bank/balances/\(address)"
 
        
        let request = try? URLRequest(url: URL.init(string: urlString)!, method: .get, headers: nil)
        
        managerAccount.request(request!).responseJSON { response in
            
            print("请求的URL:\(urlString),请求返回结果:\(response)")

            if response.result.isSuccess == true{
                
                guard let value = response.result.value else{
                    complete(false,"0.00")
                    return
                }
                
                let array = value as! NSArray
                
                if let models = [WaltModel].deserialize(from: array)
                {
                    if models.count > 0, let htdf = models.first {
                        
                        complete(true,htdf!.amount)
                    }
                    
                }
                else{
                    complete(false,"0.00")
                }
                
                
            }
            else{
                complete(false,"0.00")
            }
            
            return
        }
    }

    
    /// 21.0 请求获取转账的账号信息
    ///
    /// - Parameters:
    ///   - transacteModel: 交易封装的模型 包含地址密码等信息
    func getAccountTransacte(transacteModel:TransacteAmountMedel,completion: @escaping (Bool, String) -> Void) {
        
        let host = Network.shared.url()
        
        transacteModel.host = host
        
        //转账URL
        let urlString = "\(host)/auth/accounts/\(transacteModel.from)"
        
        GET(url: urlString, parameters: [:], success: { (response) in
            
            print(response)
            
            let dict = response as Dictionary<String, Any>
            if let value = dict["value"] as? [String:Any]
            {
                if let validatedModel = XYAccountTransacteModel.deserialize(from: value){
                    //创建交易信息
                    self.createRawTransaction(transacteModel:transacteModel,validatedModel:validatedModel,completion:completion)
                }
            }
            else
            {
                completion(false,"请求失败")
            }
        }) { (error) in
            completion(false,"请求失败")
        }
    }
    
    
    /// 21.1 创建交易信息
    func createRawTransaction(transacteModel:TransacteAmountMedel,validatedModel:XYAccountTransacteModel,completion: @escaping (Bool, String) -> Void) {
        
        /// 金额乘以8个0
        let moneyValueResult = transacteModel.getCompleteMoneyString()
        
        guard let signResult = signDicTest(transacteModel:transacteModel,validatedModel:validatedModel) else {
            completion(false,"签名交易信息失败")
            return
        }
        
        // het: hetservice, htdf:htdfservice
        let service = "htdfservice"
        let remask = transacteModel.remask
        let toString = transacteModel.to
        let fromoString = transacteModel.from
        
        //
        let transcateJsonStr = "{\"type\":\"auth\\/StdTx\",\"value\":{\"fee\":{\"gas\":\"200000\",\"amount\":[{\"denom\":\"satoshi\",\"amount\":\"20\"}]},\"signatures\":[{\"signature\":\"\(signResult.1)\",\"pub_key\":{\"value\":\"\(signResult.0)\",\"type\":\"tendermint\\/PubKeySecp256k1\"}}],\"memo\":\"\(remask)\",\"msg\":[{\"type\":\"\(service)\\/send\",\"value\":{\"To\":\"\(toString)\",\"Amount\":[{\"amount\":\"\(moneyValueResult)\",\"denom\":\"satoshi\"}],\"From\":\"\(fromoString)\"}}]}}"
        print("transcateJsonStr=" + transcateJsonStr)
        guard let data = transcateJsonStr.data(using: String.Encoding.utf8, allowLossyConversion: true) else {
            completion(false,"签名交易信息失败")
            return
        }
        
        //广播交易信息
        broadcastRawTransaciton(host: transacteModel.host, fromAddress: fromoString, txt: data.toHexString(),completion:completion)
    }
    
    
    /// 21.2 广播交易信息
    func broadcastRawTransaciton(host: String, fromAddress: String, txt: String, completion: @escaping (Bool, String) -> Void) {
        
        let urlString = "\(host)/hs/broadcast"
        
        let p = ["tx":txt]
        
        print("广播交易信息URL:\(urlString)")
        
        POST(url: urlString, parameters: p, success: { (response) in
            
            print("广播交易信息结果:\(response)")
            
            let dict = response as Dictionary<String, Any>
            if (dict["raw_log"] as? String) != nil
            {
                completion(false,"签名认证失败")
                return
            }
            
            // 交易成功  返回交易txhash
            if let txhash = dict["txhash"] as? String
            {
                completion(true,txhash)
            }
            
        }) { (error) in
            completion(false,"请求失败")
        }
    }
    
    /// 21.3 签名交易信息 改动bytes -> bytesWeb,两处
    func signDicTest(transacteModel:TransacteAmountMedel,validatedModel:XYAccountTransacteModel) -> (String, String)? {
   
        let (privatekey, publicKey) = try! Secp256k1.keyPair(privateBytes: transacteModel.privateKey.bytesWeb)
        let compressKey = try! Secp256k1.compressPublicKey(publicKey)
        
        // XY:修改,sequence只取后台返回的,不要自己计算加1
        let nowUsedSequence = validatedModel.sequence
        
        // 取出模型参数
        let remask = transacteModel.remask
        let toString = transacteModel.to
        let fromoString = transacteModel.from
        let account_number = validatedModel.account_number
        let moneyValue = transacteModel.getCompleteMoneyString()
        let chainType = Network.shared.isMain ? "mainchain" : "testchain"
        
        
        let josnString: NSString = "{\"account_number\":\"\(account_number)\",\"chain_id\":\"\(chainType)\",\"fee\":{\"amount\":[{\"amount\":\"20\",\"denom\":\"satoshi\"}],\"gas\":\"200000\"},\"memo\":\"\(remask)\",\"msgs\":[{\"Amount\":[{\"amount\":\"\(moneyValue)\",\"denom\":\"satoshi\"}],\"From\":\"\(fromoString)\",\"To\":\"\(toString)\"}],\"sequence\":\"\(nowUsedSequence)\"}" as NSString
        print("广播交易JSON:\(josnString)")
        guard let data = josnString.data(using: String.Encoding.utf8.rawValue, allowLossyConversion: true) else {
            return nil
        }
        print("交易签名信息sequence: \(nowUsedSequence)")
        // 交易签名
        guard let signDataBytes =  try? Secp256k1.signCompact(msg: data.sha256().bytesWeb, with: privatekey, nonceFunction: .rfc6979) else {
            return nil
        }
        
        guard let compressBase64 = GTMBase64.string(byEncoding: Data(bytes: compressKey, count: compressKey.count)) else {
            return nil
        }
        guard let privateBase64 = GTMBase64.string(byEncoding: Data(bytes: signDataBytes.sig, count: signDataBytes.sig.count)) else {
            return nil
        }
        
        return (compressBase64, privateBase64)
    }
}
