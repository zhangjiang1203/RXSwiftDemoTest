//
//  ZJSignUpProtocols.swift
//  RXSwifTestDemo
//
//  Created by DFHZ on 2017/9/28.
//  Copyright © 2017年 DFHZ. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

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

extension ValidationResult{
    var textColor:UIColor{
        switch self {
        case .ok:
            return UIColor.init(red: 138/255.0, green: 221/255.0, blue: 100/255.0, alpha: 1)
        case .empty:
            return UIColor.black
        case .fail:
            return UIColor.red
        default:
            return UIColor.init(red: 138/255.0, green: 221/255.0, blue: 100/255.0, alpha: 1)
        }
    }
}


extension Reactive where Base :UILabel{
    var loginResult :UIBindingObserver<Base,ValidationResult>{
        return UIBindingObserver.init(UIElement: base, binding: { (label, result) in
            label.textColor = result.textColor
            label.text = result.description
        })
    }
}

