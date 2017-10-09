//
//  ZJAddNumViewController.swift
//  RXSwifTestDemo
//
//  Created by DFHZ on 2017/9/28.
//  Copyright © 2017年 DFHZ. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ZJAddNumViewController: UIViewController {
    
    @IBOutlet weak var num1Field: UITextField!
    
    @IBOutlet weak var num2Field: UITextField!
    
    @IBOutlet weak var num3Field: UITextField!
    
    @IBOutlet weak var resultLabel: UILabel!
    
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
    Observable.combineLatest(num1Field.rx.text.orEmpty,num2Field.rx.text.orEmpty,num3Field.rx.text.orEmpty){num1,num2,num3 -> Int in
            return (Int(num1) ?? 0) + (Int(num2) ?? 0) + (Int(num3) ?? 0)
        }.map{$0.description}
        .bind(to:resultLabel.rx.text)
        .disposed(by: disposeBag)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
