//
//  LoginViewModel.swift
//  RXSwifTestDemo
//
//  Created by DFHZ on 2017/9/20.
//  Copyright © 2017年 DFHZ. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewModel {
    //输出
    let userNameUsable:Driver<Result>
    let loginButtonEnabled :Driver<Bool>
    let loginResult:Driver<Result>
    
    init(input:(userName:Driver<String>,password:Driver<String>,loginTaps:Driver<Void>),service:ValidationService) {
        userNameUsable = input.userName
                              .flatMapLatest{ username  in
                                  return service.LoginUserNameValid(username)
                                                .asDriver(onErrorJustReturn: .failed(message: "连接服务失败"))
        }
        
        let userNameAndPassword = Driver.combineLatest(input.userName,input.password){($0,$1)}
        loginResult = input.loginTaps
            .withLatestFrom(userNameAndPassword)
            .flatMapLatest{ (arg) -> SharedSequence<DriverSharingStrategy, Result> in
                let (userName, password) = arg
                return service.login(userName, password: password).asDriver(onErrorJustReturn: .failed(message:"连接服务失败"))
        }
        loginButtonEnabled = input.password
                                  .map{$0.characters.count > 0}
                                  .asDriver()
    }
}
