//
//  DriverLoginModel.swift
//  RXSwifTestDemo
//
//  Created by DFHZ on 2017/10/9.
//  Copyright © 2017年 DFHZ. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift


class DriverLoginMode {
    
    let userNameValid :Driver<ValidationResult>
    let passwordValid :Driver<ValidationResult>
    let confirmValid :Driver<ValidationResult>
    
    let signUpAble:Driver<Bool>
    
    init(input:(
        userName:Driver<String>,
        password:Driver<String>,
        confirm:Driver<String>,
        signAble:Driver<Void>
        )) {
        
        let validation = ValidationAbleService()
        
        userNameValid = input.userName.flatMapLatest{ (userName) in
            return validation.userNameValid(username: userName).asDriver(onErrorJustReturn: .fail(message: "用户名输入不正确"))
        }
        
        passwordValid = input.password.map({ password in
            return validation.passwordValid(password: password)
        })
        
        confirmValid = Driver.combineLatest(input.password,input.confirm){
            (password,confirm) in
            return validation.confirmValid(password: password, confirm: confirm)
        }
        
        signUpAble = Driver.combineLatest(userNameValid,passwordValid,confirmValid){
            return $0.isValid && $1.isValid && $2.isValid
        }
        
    }
    
}
