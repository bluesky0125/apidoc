//
//  Tool.swift
//  WaltDemo
//
//  Created by Apple on 2019/9/16.
//  Copyright © 2019 yiqilai company. All rights reserved.
//

import UIKit

class Tool: NSObject {

    
}

//MARK: - doubleValue string
extension String {
    var doubleValue: Double {
        return Double(priceValue) ?? 0.00
    }
    
    var floatValue: Float {
        return Float(self.doubleValue)
    }
    
    /// 不能含有小数点或逗号
    var intValue: Int {
        return Int(priceValue) ?? 0
    }
    
    var priceValue: String {
        return self.pregReplace(pattern: ",", with: "")
    }
    
    var decimalValue: Decimal {
        return Decimal(string: self) ?? Decimal(0)
    }
    
    //使用正则表达式替换
    //    常用的一些正则表达式：
    //    非中文：[^\\u4E00-\\u9FA5]
    //    非英文：[^A-Za-z]
    //    非数字：[^0-9]
    //    非中文或英文：[^A-Za-z\\u4E00-\\u9FA5]
    //    非英文或数字：[^A-Za-z0-9]
    //    非英文或数字或下划线：[^A-Za-z0-9_]
    func pregReplace(pattern: String, with: String,
                     options: NSRegularExpression.Options = []) -> String {
        let regex = try! NSRegularExpression(pattern: pattern, options: options)
        return regex.stringByReplacingMatches(in: self, options: [],
                                              range: NSMakeRange(0, self.count),
                                              withTemplate: with)
    }
}


/// 密码改为16位
///
/// - Parameter psd: 123456
/// - Returns: 123456111111111
func get16Bytes(_ psd: String) -> String {
    
    //    return psd //不要16位
    
    var tempValue = psd
    for _ in (16 - psd.count) {
        tempValue.append("1")
    }
    return tempValue
}

