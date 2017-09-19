//
//  RegisterViewModel.swift
//  RXSwifTestDemo
//
//  Created by DFHZ on 2017/9/19.
//  Copyright © 2017年 DFHZ. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RegisterViewModel {

    let username = Variable<String>("")
    
    let userNameAble:Observable<Result>//用户名是否可用
    
    let password = Variable<String>("")
    let repeatpassword = Variable<String>("")
    
    let passwordUsable :Observable<Result>//密码是否可用
    let repeatPasswordUsable : Observable<Result>//密码确定是否正确

    
    init() {
        
        let service = ValidationService.instance
        
        userNameAble = username.asObservable()
        .flatMapLatest{ userNmae in
            return service.validataUserName(userNmae)
            .observeOn(MainScheduler.instance)
                .catchErrorJustReturn(.failed(message:"username检测出错"))
            }
        .shareReplay(1)
        
        passwordUsable = password.asObservable().map({ password  in
            return service.validataPassword(password)
        }).shareReplay(1)
        
        repeatPasswordUsable = Observable.combineLatest(password.asObservable(),repeatpassword.asObservable()){
            return service.validateRepeatedPassword(password: $0, repeatPassword: $1)
        }.shareReplay(1)
    }
    
    
}
