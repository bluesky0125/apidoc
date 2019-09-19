//
//  Network.swift
//  WaltDemo
//
//  Created by apple on 2019/9/16.
//  Copyright © 2019年 yiqilai company. All rights reserved.
//

import UIKit

class Network: NSObject {

    static let shared = Network()
    
    /// 是否证书环境 false:测试环境  true:正式环境
    var isMain = true
    
    func url() -> String {
        if isMain == true {
            return "http://node01.orientwalt.cn:1317"
        }
        else{
            return "http://118.190.245.246:1317"
        }
    }
    
    
}
