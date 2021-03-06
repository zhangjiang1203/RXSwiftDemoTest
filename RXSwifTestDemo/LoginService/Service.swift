//
//  Service.swift
//  RXSwifTestDemo
//
//  Created by DFHZ on 2017/9/19.
//  Copyright © 2017年 DFHZ. All rights reserved.
//
import UIKit
import RxSwift
import RxCocoa

enum Result {
    case ok(message:String)
    case empty
    case failed(message:String)
}

class ValidationService {
    static let instance = ValidationService()
    let minCharactersCount = 6
    let filePath = "/Documents/users.plist"
    private init(){}
    
    //返回一个Observable对象，这个请求过程要被监听
    func validataUserName(_ userName:String) -> Observable<Result> {
        if userName.characters.count == 0 {
            return .just(.empty)
        }
        
        if userName.characters.count < minCharactersCount {
            return .just(.failed(message:"号码长度至少为6个字符"))
        }
        
        if userNameVaild(userName) {
            return .just(.failed(message:"账户已存在"))
        }
        return .just(.ok(message:"用户名可用"))
    }
    
    func userNameVaild(_ userName:String) -> Bool {
        let filePath = NSHomeDirectory()+self.filePath
        let userDict = NSDictionary.init(contentsOfFile: filePath)
        if userDict != nil{
            let userNameArr = userDict!.allKeys as NSArray
            if userNameArr.contains(userName) {
                return true
            }
        }
        return false
    }
    
    func validataPassword(_ password:String) -> Result {
        if password.characters.count == 0 {
            return .empty
        }
        
        if password.characters.count < 6 {
            return .failed(message: "密码长度至少6个字符")
        }
        return .ok(message: "密码可用")
    }
    
    func validateRepeatedPassword(password:String,repeatPassword:String) -> Result {
        if repeatPassword.characters.count == 0 {
            return .empty
        }
        
        if repeatPassword == password {
            return .ok(message: "密码可用")
        }
        return .failed(message: "两次输入密码不一样")
    }
    
    func registerAccount(userName:String,password:String) -> Observable<Result> {
        let userDict = [userName:password]
        let filePath = NSHomeDirectory()+self.filePath
        if (userDict as NSDictionary).write(toFile: filePath, atomically: true) {
            return .just(.ok(message:"注册成功"))
        }
        return .just(.failed(message:"注册失败"))
    }
    
    //MARK: 登录用户名验证
    func LoginUserNameValid(_ userName:String) -> Observable<Result> {
        if userName.characters.count == 0 {
            return .just(.empty);
        }
        
        if userName.characters.count < minCharactersCount {
            return .just(.failed(message: "用户名至少是6个字符"))
        }
        
        return .just(.ok(message:"用户名可用"))
    }
    
    func LoginPasswordValid(_ password:String) -> Observable<Result> {
        if password.characters.count == 0 {
            return .just(.empty)
        }
        
        if password.characters.count < minCharactersCount {
            return .just(.failed(message:"密码长度至少6个字符"))
        }
        
        return .just(.ok(message:"密码可用"))
    }
    
    //开始登录
    func login(_ userName:String,password:String) -> Observable<Result> {
        let filePath = NSHomeDirectory()+self.filePath
        let userDict = NSDictionary.init(contentsOfFile: filePath)
        if let userPassword = userDict?.object(forKey: userName) as? String {
            if userPassword == password{
                return .just(.ok(message:"登录成功"))
            }
        }
        return .just(.failed(message:"密码错误"))
    }
}
