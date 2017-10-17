//
//  ZJDriverViewController.swift
//  RXSwifTestDemo
//
//  Created by DFHZ on 2017/9/28.
//  Copyright © 2017年 DFHZ. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ZJDriverViewController: UIViewController {
    
    @IBOutlet weak var accontField: UITextField!
    
    @IBOutlet weak var accountLabel: UILabel!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var passwordLabel: UILabel!
    
    @IBOutlet weak var repeatField: UITextField!
    
    @IBOutlet weak var repeatLabel: UILabel!
    
    @IBOutlet weak var signUpBtn: UIButton!

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpBtn.layer.cornerRadius = 20
        //开始绑定
        let driver = DriverLoginMode.init(input: (
            userName:accontField.rx.text.orEmpty.asDriver(),
            password: passwordField.rx.text.orEmpty.asDriver(),
            confirm: repeatField.rx.text.orEmpty.asDriver(),
            signAble: signUpBtn.rx.tap.asDriver()
        ))
        
        driver.userNameValid.drive(accountLabel.rx.loginResult).disposed(by:disposeBag)
        driver.passwordValid.drive(passwordLabel.rx.loginResult).disposed(by: disposeBag)
        driver.confirmValid.drive(repeatLabel.rx.loginResult).disposed(by: disposeBag)
        
        driver.signUpAble.drive(onNext: {[unowned self] able in
            self.signUpBtn.isEnabled = able
            self.signUpBtn.alpha = able ? 1.0 : 0.5
        }).disposed(by: disposeBag)
        
        signUpBtn.rx.tap.asDriver().drive { (able) in
            print("开始点击===driver")
        }
    }
}
