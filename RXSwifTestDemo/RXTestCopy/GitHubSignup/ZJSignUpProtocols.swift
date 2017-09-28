//
//  ZJSignUpProtocols.swift
//  RXSwifTestDemo
//
//  Created by DFHZ on 2017/9/28.
//  Copyright © 2017年 DFHZ. All rights reserved.
//

import UIKit



/// 定义一个枚举
enum ValidationResult {
    case ok(message:String)
    case fail(message:String)
    case empty
    case validating
}


/// MARK: - 是否可用
extension ValidationResult{
    var isValid:Bool{
        switch self {
        case .ok:
            return true
        default:
            return false
        }
    }
}

extension ValidationResult{
    var description:String{
        switch self {
        case let .ok(message):
            return message
        case .empty:
            return ""
        case let .fail(message):
            return message
        case .validating:
            return "验证中……"
        }
    }
    
}

class ZJSignUpProtocols {

}
