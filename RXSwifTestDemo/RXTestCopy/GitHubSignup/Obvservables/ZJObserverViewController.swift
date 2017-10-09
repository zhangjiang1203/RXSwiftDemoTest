//
//  ZJObserverViewController.swift
//  RXSwifTestDemo
//
//  Created by DFHZ on 2017/9/28.
//  Copyright © 2017年 DFHZ. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


class ZJObserverViewController: UIViewController {
    
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
        let viewModel = ObservableLoginModel.init(
            input: (
                userName: accontField.rx.text.orEmpty.asObservable(),
                password: passwordField.rx.text.orEmpty.asObservable(),
                confirm: repeatField.rx.text.orEmpty.asObservable(),
                signAble: signUpBtn.rx.tap.asObservable())
        )
        //开始绑定
        viewModel.userNameValid.bind(to: accountLabel.rx.loginResult).disposed(by:disposeBag)
        viewModel.passwordValid.bind(to: passwordLabel.rx.loginResult).disposed(by: disposeBag)
        viewModel.confirmValid.bind(to: repeatLabel.rx.loginResult).disposed(by: disposeBag)
        
        viewModel.signInAble.bind(to: signUpBtn.rx.isEnabled).disposed(by: disposeBag)
        
        //开始登陆
        signUpBtn.rx.tap
            .asObservable()
            .do(onNext: {[unowned self] _ in
            self.view.endEditing(true)
            })
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { _ in
                print("开始点击===observer")
            }).disposed(by: disposeBag)
    }

}
