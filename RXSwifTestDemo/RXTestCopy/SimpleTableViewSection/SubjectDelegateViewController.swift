//
//  SubjectDelegateViewController.swift
//  RXSwifTestDemo
//
//  Created by pg on 2018/3/6.
//  Copyright © 2018年 DFHZ. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class SubjectDelegateViewController: UIViewController {

    var publishDel = PublishSubject<Int>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    
    @IBAction func DelegateAction(_ sender: UIButton) {
        
        publishDel.onNext(1)
    }


}
