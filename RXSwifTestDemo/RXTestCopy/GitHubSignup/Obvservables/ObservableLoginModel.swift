//
//  ObservableLoginModel.swift
//  RXSwifTestDemo
//
//  Created by DFHZ on 2017/10/9.
//  Copyright © 2017年 DFHZ. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ObservableLoginModel{
    //用户名
    let userNameValid:Observable<ValidationResult>
    //密码
    let passwordValid:Observable<ValidationResult>
    //确认密码
    let confirmValid:Observable<ValidationResult>
    //登录按钮可用与否
    let signInAble : Observable<Bool>
    
    init(input:(
        userName:Observable<String>,
        password:Observable<String>,
        confirm:Observable<String>,
        signAble:Observable<Void>)) {
        
        let validationService = ValidationAbleService()
        userNameValid = input.userName.flatMapLatest{userName in
            return validationService.userNameValid(username: userName)
                .observeOn(MainScheduler.instance)
                .catchErrorJustReturn(.fail(message:"用户名检测出错"))
        }.shareReplay(1)
        //两种不同的写法
        passwordValid = input.password.map{
            return validationService.passwordValid(password: $0)
        }.shareReplay(1)
        
        confirmValid = Observable.combineLatest(input.password,input.confirm){
            (password,confirm) in
            return validationService.confirmValid(password: password, confirm: confirm)
        }.shareReplay(1)
        
        //按钮可用与否
        signInAble = Observable.combineLatest(userNameValid,passwordValid,confirmValid){
            (userName,password,confirm) in
            return (userName.isValid) && (password.isValid) && (confirm.isValid)
            }.distinctUntilChanged()
             .shareReplay(1)
    }
}
