//
//  TransferViewController.swift
//  WaltDemo
//
//  Created by Apple on 2019/9/16.
//  Copyright © 2019 yiqilai company. All rights reserved.
//

import UIKit
import web3swift


class TransferViewController: UIViewController {

    /// 转入地址
    @IBOutlet weak var addressTextField: UITextField!
    
    /// 转账数量
    @IBOutlet weak var amountTextfield: UITextField!
    
    /// 转出地址
    @IBOutlet weak var fromAddress: UILabel!
    
    /// r日志输出
    @IBOutlet weak var logLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //测试地址
        addressTextField.text = "htdf1m3hm3xvvsf9p7jcu0e0fjzn0zz43sly0jv9mrj"
        amountTextfield.text = "0.1"
        
        
        fromAddress.text = accountaddress

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func transferButtonClick(_ sender: Any) {
        
        guard let address = addressTextField.text,address.isEmpty == false else {
            return
        }
        guard let amount = amountTextfield.text,amount.isEmpty == false else {
            return
        }
        if accountaddress.isEmpty == true  {
            print("无账号")
            return
        }
        
        /// 校验密码方法
        //WalletsManager.shared.checkPsaawordIsRight
        
        /// 封装交易信息模型
        let transacteModel = TransacteAmountMedel()
        transacteModel.from = accountaddress
        transacteModel.to = address
        transacteModel.amountSource = amount
        transacteModel.password = WALT_PSW
        
        /// privateKey的Data可通过getPrivateData方法获取,这两者都可以
        //transacteModel.privateKey = accountPrivateKey.privateKey
        if let privateData = getPrivateData()
        {
            transacteModel.privateKey = privateData
        }
        else{
            print("密码验证失败")
            return
        }
        
        // 请求交易等信息
        HttpManager.shared.getAccountTransacte(transacteModel: transacteModel) { (result, msg) in
            
            if result == true
            {                                
                print("交易成功,\(msg)")
                self.logLabel.text = "交易成功,\(msg)"
            }
            else
            {
                print("交易失败,\(msg)")
                self.logLabel.text = "交易失败,\(msg)"
            }
        }
    }
    
    // 根据地址获取keystore
    func getPrivateData() -> Data? {
        if let privateValue = WalletsManager.shared.getPrivateKeyData(password: WALT_PSW, address: accountaddress)
        
        {
            print(privateValue)
            return privateValue
        }
        
        print("密码验证失败")
        
        
        return nil
    }
}
