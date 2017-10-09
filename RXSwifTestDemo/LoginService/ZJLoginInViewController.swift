//
//  ZJLoginInViewController.swift
//  RXSwifTestDemo
//
//  Created by DFHZ on 2017/9/4.
//  Copyright © 2017年 DFHZ. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


class ZJLoginInViewController: UIViewController {
    
    @IBOutlet weak var accountField: UITextField!
    @IBOutlet weak var accountInfoLabel: UILabel!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var passwordInfoLabel: UILabel!
    
    @IBOutlet weak var loginBtn: UIButton!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let viewModel = LoginViewModel.init(input: (userName: accountField.rx.text.orEmpty.asDriver(), password: passwordField.rx.text.orEmpty.asDriver(), loginTaps: loginBtn.rx.tap.asDriver()), service: ValidationService.instance)
//
//        viewModel.userNameUsable
//            .drive(accountInfoLabel.rx.validationResult)
//            .addDisposableTo(disposeBag)
//
//        viewModel.loginButtonEnabled
//            .drive(onNext: { [unowned self] valid in
//            self.loginBtn.isEnabled = valid
//            self.loginBtn.alpha = valid ? 1 : 0.5
//            })
//            .addDisposableTo(disposeBag)
//
//        viewModel.loginResult
//            .drive(onNext: { [unowned self] result in
//                switch result{
//                case .empty:
//                    self.showAlert(message: "")
//                case let .ok(message):
//                    print(message)
//                    //开始进行跳转
//                    self.showAlert(message: message)
//                case let .failed(message):
//                    self.showAlert(message: message)
//                }
//        })
//        .addDisposableTo(disposeBag)
        
        loginMyAccount()
    }
    
    
    func loginMyAccount()  {
        
        let accountValid:Observable = accountField.rx.text.orEmpty.map{
            return $0.characters.count >= 6
        }
        
        let passwordValid:Observable = passwordField.rx.text.orEmpty.map{
            return $0.characters.count >= 6
        }
        //绑定显示
        accountValid.bind(to: accountInfoLabel.rx.isHidden).addDisposableTo(disposeBag)
        passwordValid.bind(to: passwordInfoLabel.rx.isHidden).addDisposableTo(disposeBag)

        //登录按钮的可用与否
        let loginObserver = Observable.combineLatest(accountValid,passwordValid){(account,password) in
            account && password
        }
        //绑定按钮
        loginObserver.bind(to: loginBtn.rx.isEnabled).addDisposableTo(disposeBag)
        
        loginBtn.rx.tap
            .asObservable()
            .withLatestFrom(loginObserver)
            .do(onNext: {
                [unowned self]_ in
                self.loginBtn.isEnabled = false
                self.view.endEditing(true)
            })
            .subscribeOn(MainScheduler.instance)//主线程
            .subscribe(onNext: {[unowned self]isLogin in
                self.showAlert(message: "开始点击")
            })
            .addDisposableTo(disposeBag)//开始释放
    }
    
    fileprivate func showAlert(message:String) {
        let action = UIAlertAction.init(title: "确定", style: .default, handler: nil)
        let alertView = UIAlertController.init(title: nil, message: message, preferredStyle: .alert)
        alertView.addAction(action)
        present(alertView, animated: true, completion: nil)
    }
}
