//
//  ViewController.swift
//  WaltDemo
//
//  Created by Apple on 2019/9/16.
//  Copyright © 2019 yiqilai company. All rights reserved.
//

import UIKit
import web3swift
import Foundation

class ViewController: UIViewController {
    
    /// 助记词
    @IBOutlet weak var mnemonicesTextView: UITextView!
    //// 私钥
    @IBOutlet weak var privateTextView: UITextView!
    @IBOutlet weak var publickeyLabel: UILabel!
    /// 地址
    @IBOutlet weak var addressLabel: UILabel!
    /// 余额
    @IBOutlet weak var balanceLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       mnemonicesTextView.text = "list era cruel cream august dad coconut predict catalog school flush one"
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    /// create wallt
    func create() {
        if mnemonicesTextView.text.isEmpty == true{
            return
        }
        guard let mnemonice = try? Mnemonics(mnemonicesTextView.text) else
        {
            return
        }
        
        WalletsManager.shared.createWallt(mnemonics: mnemonice) { [weak self](address, keystore, privateKey) in
            guard let this = self else { return }
            
            this.addressLabel.text = address
            this.privateTextView.text = privateKey?.privateKey.hex
            this.publickeyLabel.text = "htdf公钥:" + (privateKey?.publicKey.hex)!
            this.getBalance()
            
            /// 私钥对象 测试的全局保存 正式环境使用keystore保存信息
            accountPrivateKey = privateKey!
            accountaddress = address!
        }
        
    }
    
    /// 获取余额
    func getBalance() {
        if addressLabel.text?.isEmpty == true {
            return
        }
        WalletsManager.shared.getBalance(address: addressLabel.text!) { [weak self] (result, balance) in
            guard let this = self else { return }
            this.balanceLabel.text = balance! + "HTDF"
            
        }
    }
    
    //MARK: Event
    
    /// 生成助记词
    @IBAction func getMnemoniceClick(_ sender: UIButton) {
        mnemonicesTextView.text = WalletsManager.shared.getMnemoncies()
        create()
    }
    /// 导入助记词
    @IBAction func importMnemonicsClick(_ sender: UIButton) {
        create()
    }
    
    /// 导入私钥
    @IBAction func importPrivateClick(_ sender: Any) {
        
        guard let privateStr = privateTextView.text else
        {
            print("no privateTextView.text")
            return
        }
        
        let privateData = Data(hexStr: privateStr)
        
        /// 私钥导入
        WalletsManager.shared.importPrivateTypes(privateData: privateData, psd: WALT_PSW) { [weak self](result, address) in
            guard let this = self else { return }
            if result == true{

                // 地址
                this.addressLabel.text = address
                // 得出公钥
                let p = PrivateKey(privateData)
                this.publickeyLabel.text = "htdf公钥:" + p.publicKey.hex
                // 余额
                this.getBalance()
                
                accountaddress = address!
            }
        }
        
    }
    
    /// 刷新余额
    @IBAction func refreshBalance(_ sender: UIButton) {
        getBalance()
    }

}

