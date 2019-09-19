//
//  WalletsManager.swift
//  WaltDemo
//
//  Created by Apple on 2019/9/16.
//  Copyright © 2019 yiqilai company. All rights reserved.
//

import UIKit
import web3swift

/// path
let HDTF_PATH = "m/44'/346'/0'/0"
/// 钱包默认名字
let WALT_NAME = "HTDF"
/// 钱包默认密码
let WALT_PSW = get16Bytes("a12345678")

/// 私钥
var accountPrivateKey:PrivateKey = PrivateKey()
/// 记录当前账号地址
var accountaddress:String = ""

class WalletsManager: NSObject {

    // 所有钱包的keystore存储路径
    private var documentPath: String {
        guard let librayPath = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).last else {
            return ""
        }
        let fielPath = "\(librayPath)/Keystores"
        let fileManager = FileManager.default
        var directoryExists = ObjCBool(true)
        if !fileManager.fileExists(atPath: fielPath, isDirectory: &directoryExists) {
            let _ = try! fileManager.createDirectory(at: URL(fileURLWithPath: fielPath), withIntermediateDirectories: true, attributes: nil)
        }
        return fielPath
    }
    
    
    static let shared = WalletsManager()
    
    var keystoreManager: KeystoreManager?
    
    override init() {
        super.init()

        /// x持续化保存的路径,保存为path/xxxx.txt,方法saveKeyStore
        self.keystoreManager = KeystoreManager.managerForPath(documentPath)
        /// 同时保存keystore,keystore持久化可多选.现在没持续化
//        if let keystoreManager = WalletsManager.shared.keystoreManager {
//            keystoreManager.append(keystore!)
//
//            if let ks = try? keystore?.serializeString()
//            {
//                print(ks)
//            }
//        }
    }
    
    
    
    
    /// 生成助记词
    func getMnemoncies() -> String {
        // 0.0 助记词
        let mnemonics = Mnemonics(entropySize: EntropySize(rawValue: EntropySize.b128.rawValue)! , language: .english)
        return mnemonics.description
    }
    
    /// 根据助记词词创建账号
    func createWallt(mnemonics:Mnemonics,completion: @escaping (String?, EthereumKeystoreV3?,PrivateKey?) -> Void) {
        createHTDFWallet(mnemonics: mnemonics, psd: WALT_PSW, name: WALT_NAME) { (address, keystore, privateKey) in
            
            /// 保存keystore
            if let keystoreV3 = keystore{
                
                // 1.0 两步骤保存
                let fileName = self.getFileName(walletTypeName: "HTDF", address: address!)
                _ = self.saveKeyStore(keystore: keystoreV3, fileName: fileName)
                
                
                /// 2.0 同时保存keystore
                if let keystoreManager = self.keystoreManager {
                    keystoreManager.append(keystoreV3)
                    
                    if let ks = try? keystoreV3.serializeString()
                    {
                        print(ks as Any)
                    }
                }
                
                // 重置keystore
                WalletsManager.shared.keystoreManager = KeystoreManager.managerForPath(self.documentPath)
            }
            
            
            completion(address, keystore, privateKey)
        }
        
    }
    
    /// 获取余额
    func getBalance(address:String,completion: @escaping (Bool, String?) -> Void) {
        HttpManager.shared.getAccountBalance(address: address, complete: completion)
    }
    
    
    
    /// 导入钱包方式 - 私钥导入
    func importPrivateTypes(privateData: Data, psd: String, completion: @escaping (Bool, String?) -> Void)  {

        guard let ethereumKeystoreV3UP = try! EthereumKeystoreV3(privateKey: privateData, password: psd, walletType: .htdf) else {
            completion(false, nil)
            print("私钥不正确")
            return
        }
        let address = addressWithKeystore(keystore: ethereumKeystoreV3UP)
    
        
        /// 保存keystore
        let keystoreV3 = ethereumKeystoreV3UP
            
        // 1.0 两步骤保存
        let fileName = self.getFileName(walletTypeName: "HTDF", address: address)
        _ = self.saveKeyStore(keystore: keystoreV3, fileName: fileName)
        
        
        /// 2.0 同时保存keystore
        if let keystoreManager = self.keystoreManager {
            keystoreManager.append(keystoreV3)
            
            if let ks = try? keystoreV3.serializeString()
            {
                print(ks as Any)
            }
        }
        
        // 重置keystore
        WalletsManager.shared.keystoreManager = KeystoreManager.managerForPath(self.documentPath)
        
        
        completion(true, address)

    }
    
    
    
    
    
    
    /// 创建HTDF钱包账号
    private func createHTDFWallet(mnemonics: Mnemonics,psd: String, name: String,completion: @escaping (String?, EthereumKeystoreV3?,PrivateKey?) -> Void) {

        // keystore
        guard let htdfKeyStore = try? BIP32Keystore.init(mnemonics: mnemonics, password: psd, prefixPath: HDTF_PATH) else{
            print("create account failded htdfKeyStore")
            return
        }
        let htdfAccount = htdfKeyStore.addresses[0]
        
        guard let htdfPrivateKey = try? htdfKeyStore.UNSAFE_getPrivateKeyData(password: psd, account: htdfAccount) else{
            print("create account failded htdfPrivateKey")
            return
        }

        guard let ethereumKeystoreV3HTDF = try! EthereumKeystoreV3(privateKey: htdfPrivateKey, password: psd, walletType: .htdf) else {
            print("create account failded ethereumKeystoreV3HTDF")
            return
        }
        
        let privateKey = PrivateKey(htdfPrivateKey)
        
        let htdfAddress = addressWithKeystore(keystore: ethereumKeystoreV3HTDF)
        

        completion(htdfAddress,ethereumKeystoreV3HTDF,privateKey)
        
    }
    
    
    //MARK: method
    // 根据 keystore获取地址
    func addressWithKeystore(keystore: EthereumKeystoreV3) -> String {
        return "\(keystore.addresses[0])"
    }

    // 根据地址寻找keystoreEthereumKeystoreV3
    func keystore(address: String) -> EthereumKeystoreV3? {
        let addressObj = Address(address, walletType: .htdf)
        return keystoreManager?.walletForAddress(addressObj) as? EthereumKeystoreV3
    }
    
    /// 校验密码是否正确
    func checkPsaawordIsRight(address: String, password: String) -> Bool {
        // 查找keystore,根据address
        guard let keystore = keystore(address: address) else {
            return false
        }
        do {
            let _ = try keystore.UNSAFE_getPrivateKeyData(password: password, account: keystore.addresses[0])
            return true
        } catch {
            return false
        }
    }
    
    // 根据密码, 地址获取私钥
    func getPrivateKeyData(password: String, address: String) -> Data? {
        guard let keystore = keystore(address: address) else {
            return nil
        }
        do {
            return try keystore.UNSAFE_getPrivateKeyData(password: password, account: keystore.addresses[0])
        } catch {
            return nil
        }
    }
    
    private func getFileName(walletTypeName: String, address: String) -> String {
        
        let dformatter = DateFormatter()
        dformatter.dateFormat = "yyyyMMddHH:mm:ss"
        let datestr = dformatter.string(from: Date())
        let fileName = "\(documentPath)/\(datestr)_\(walletTypeName)_\(address).txt"
        return fileName
    }
    
    // 存储钱包的keystore
    private func saveKeyStore(keystore: EthereumKeystoreV3, fileName: String) -> Bool {
        do {
            
            guard let jsn = try keystore.serialize() else {
                return false
            }
            let _ = try jsn.write(to: URL(fileURLWithPath: fileName))
            
            return true
            
        } catch {
            return false
        }
    }
    
}
