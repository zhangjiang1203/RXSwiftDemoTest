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
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    func rxtest() {
        let a = Variable(1)
        let b = Variable(2)
        
        let c = Observable.combineLatest(a.asObservable(),b.asObservable()){$0 +  $1}
            .filter{ $0 >= 0}
            .map{"\($0) is positive"}
        c.subscribe(onNext:{print($0)}).dispose();
        //a b 的值改变立刻输出
        a.value = 4
        b.value = -8
    }
}
