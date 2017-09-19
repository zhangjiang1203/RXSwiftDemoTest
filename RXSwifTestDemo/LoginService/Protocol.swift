//
//  Protocol.swift
//  RXSwifTestDemo
//
//  Created by DFHZ on 2017/9/19.
//  Copyright © 2017年 DFHZ. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


extension Result{
    var isValid :Bool{
        switch self {
        case .ok:
            return true
        default:
            return false
        }
    }
    
}

extension Result{
    var description:String{
        switch self {
        case let .ok(message):
            return message
        case .empty:
            return ""
        case let .failed(message):
            return message
        }
    }
    
}

extension Result{
    var textColor:UIColor{
        switch self {
        case .ok:
            return UIColor.init(red: 138/255.0, green: 221/255.0, blue: 100/255.0, alpha: 1)
        case .empty:
            return UIColor.black
        case .failed:
            return UIColor.red
        }
    }
    
}

extension Reactive where Base :UILabel{
    var validationResult :UIBindingObserver<Base,Result>{
        return UIBindingObserver.init(UIElement: base, binding: { (label, result) in
            label.textColor = result.textColor
            label.text = result.description
        })
    }
}

extension Reactive where Base :UITextField{
    var inputEnable :UIBindingObserver<Base,Result>{
        return UIBindingObserver.init(UIElement: base, binding: { (textField, result) in
            textField.isEnabled = result.isValid
        })
    }
    
}

