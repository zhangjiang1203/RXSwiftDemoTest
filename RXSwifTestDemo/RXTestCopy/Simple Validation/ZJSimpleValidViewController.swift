//
//  ZJSimpleValidViewController.swift
//  RXSwifTestDemo
//
//  Created by DFHZ on 2017/9/28.
//  Copyright © 2017年 DFHZ. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ZJSimpleValidViewController: UIViewController {

    @IBOutlet weak var accountField: UITextField!
    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    
    @IBOutlet weak var loginBtn: UIButton!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loginBtn.layer.cornerRadius = 20;
        
        //开始设置
        let accountValid = accountField.rx.text.orEmpty.map {
            return $0.characters.count >= 6
        }.shareReplay(1)
        
        accountValid.bind(to: accountLabel.rx.isHidden).addDisposableTo(disposeBag)
        //当输入了账号之后才能输入密码
        accountValid.bind(to: passwordField.rx.isEnabled).addDisposableTo(disposeBag)
        //密码是否符合
        let passwordValid = passwordField.rx.text.orEmpty.map {
            return $0.characters.count >= 6
        }.shareReplay(1)
        passwordValid.bind(to: passwordLabel.rx.isHidden).addDisposableTo(disposeBag)
        
        let loginValid = Observable.combineLatest(accountValid,passwordValid){account,password in
            return account && password
        }.shareReplay(1)
        
        loginValid.bind(to: loginBtn.rx.isEnabled).addDisposableTo(disposeBag)
        loginValid.subscribe(onNext: { valid in
            self.loginBtn.backgroundColor = valid ? RGBCOLOR_HEX(h: 0x00c866) : RGBCOLOR_HEX(h: 0x62C495)
        }).addDisposableTo(disposeBag)
        
        //添加添加事件
        loginBtn.rx.tap.subscribe(onNext:{[unowned self] _ in
            //开始登录
            self.view.endEditing(true)
            self.showAlert()
        }).addDisposableTo(disposeBag)
    }
    
    func showAlert() {
        let alertView = UIAlertController.init(title: "提示", message: "登录成功", preferredStyle: .alert)
        let cancelBtn = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        let confirmBtn = UIAlertAction.init(title: "确定", style: .default, handler: nil)
        alertView.addAction(cancelBtn)
        alertView.addAction(confirmBtn)
        present(alertView, animated: true, completion: nil)
    }
}
