//
//  WaltModel.swift
//  WaltDemo
//
//  Created by apple on 2019/9/16.
//  Copyright © 2019年 yiqilai company. All rights reserved.
//

import UIKit
import HandyJSON
class WaltModel: HandyJSON {

    var amount = ""
    var denom = ""
    
    required init() {
        
    }
}


/// 转账数据封装的模型
class TransacteAmountMedel: NSObject {
    var from = ""
    var to = ""
    var amount = ""         // 经过加0后的数据
    var amountSource = ""   //源数据
    var privateKey = Data()
    var remask = ""
    var time = ""
    var amountNumber = "" //交易号
    var block = ""
    var password = ""
    var host = ""
    
    
    
    /// 金额乘以8个0
    ///
    /// - Returns: 没有小数点的金额
    func getCompleteMoneyString() -> String {
        /// 金额乘以8个0
        let a = self.amountSource.decimalValue
        let b = "100000000".decimalValue
        return (a * b).description
    }
}


//MARK: - 转账返回信息model
/// 获取HTDF交易账号的信息
class XYAccountTransacteModel: HandyJSON {
    
    var sequence = ""
    var public_key:XYpublic_key?
    var coins:[XYCoins]?
    var account_number = ""
    var address = ""
    
    required init() {
    }
}
class XYpublic_key: HandyJSON {
    
    var type = ""
    var value = ""
    
    required init() {
    }
}
class XYCoins: HandyJSON {
    
    var denom = ""
    var amount = ""
    
    required init() {
    }
}
