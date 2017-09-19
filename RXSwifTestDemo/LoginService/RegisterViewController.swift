//
//  RegisterViewController.swift
//  RXSwifTestDemo
//
//  Created by DFHZ on 2017/9/19.
//  Copyright © 2017年 DFHZ. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


class RegisterViewController: UIViewController {
    
    @IBOutlet weak var accoutField: UITextField!
    @IBOutlet weak var accountLabelInfo: UILabel!
    
    @IBOutlet weak var loginBtn: UIButton!
    
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordLabelInfo: UILabel!
    
    @IBOutlet weak var confirmPWSField: UITextField!
    @IBOutlet weak var confirmLabelInfo: UILabel!
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewModel = RegisterViewModel()
        //绑定输入框
        accoutField.rx.text.orEmpty
            .bind(to: viewModel.username)
            .addDisposableTo(disposeBag)
        passwordField.rx.text.orEmpty
            .bind(to: viewModel.password)
            .addDisposableTo(disposeBag)
        confirmPWSField.rx.text.orEmpty
            .bind(to: viewModel.repeatpassword)
            .addDisposableTo(disposeBag)
        //绑定label,根据输入的值反过来绑定label的显示文字和颜色 输入框的可用与否
        viewModel.userNameAble
            .bind(to: accountLabelInfo.rx.validationResult)
            .addDisposableTo(disposeBag)
        
        viewModel.passwordUsable.bind(to: passwordLabelInfo.rx.validationResult).addDisposableTo(disposeBag)
        
        viewModel.passwordUsable.bind(to: confirmPWSField.rx.inputEnable).addDisposableTo(disposeBag)
        
        viewModel.repeatPasswordUsable.bind(to: confirmLabelInfo.rx.validationResult).addDisposableTo(disposeBag)

    }
    
    
    

    

}
