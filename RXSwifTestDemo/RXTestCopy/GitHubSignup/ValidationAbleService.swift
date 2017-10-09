//
//  ValidationAbleService.swift
//  RXSwifTestDemo
//
//  Created by DFHZ on 2017/10/9.
//  Copyright © 2017年 DFHZ. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ValidationAbleService{
    //设置初始信息
    let minCharacters = 6
    
    /// 用户名可用与否
    ///
    /// - Parameter username: 用户名
    /// - Returns: 返回的信息值
    func userNameValid(username:String) -> Observable<ValidationResult> {
        if username.characters.count == 0 {
            return .just(.empty)
        }
        
        if username.characters.count < minCharacters{
            return .just(.fail(message:"用户名长度至少为六个字符"))
        }
        
        return .just(.ok(message:"该账号可用"))
    }
    
    func passwordValid(password:String) -> ValidationResult {
        if password.characters.count == 0{
            return .empty
        }
        
        if password.characters.count < minCharacters{
            return .fail(message:"密码长度最少为六个字符")
        }
        
        return .ok(message:"该密码可用")
    }
    
    func confirmValid(password:String,confirm:String) -> ValidationResult {
        
        if confirm.characters.count == 0{
            return .empty
        }
        
        if password != confirm {
            return .fail(message:"两次输入密码不一致")
        }
        return .ok(message:"密码输入正确")
    }
    
    //设置默认的初始化
    init() {}
}
