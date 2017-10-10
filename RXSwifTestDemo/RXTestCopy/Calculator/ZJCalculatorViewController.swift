//
//  ZJCalculatorViewController.swift
//  RXSwifTestDemo
//
//  Created by DFHZ on 2017/10/10.
//  Copyright © 2017年 DFHZ. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift


class ZJCalculatorViewController: UIViewController {
    
    @IBOutlet weak var operatorsLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var clearBtn: UIButton!
    @IBOutlet weak var changeBtn: UIButton!
    @IBOutlet weak var percentBtn: UIButton!
    //MARK:计算符
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var minusBtn: UIButton!
    @IBOutlet weak var multiplyBtn: UIButton!
    @IBOutlet weak var devideBtn: UIButton!
    @IBOutlet weak var equalBtn: UIButton!
    //MARK:数字运算
    @IBOutlet weak var oneBtn: UIButton!
    @IBOutlet weak var twoBtn: UIButton!
    @IBOutlet weak var threeBtn: UIButton!
    @IBOutlet weak var fourBtn: UIButton!
    @IBOutlet weak var fiveBtn: UIButton!
    @IBOutlet weak var sixBtn: UIButton!
    @IBOutlet weak var sevenBtn: UIButton!
    @IBOutlet weak var eightBtn: UIButton!
    @IBOutlet weak var nineBtn: UIButton!
    @IBOutlet weak var zeroBtn: UIButton!
    @IBOutlet weak var pointBtn: UIButton!
    
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let commands:Observable<CalculatorCommand> =
            Observable.merge([
                clearBtn.rx.tap.map{_ in .clear },
                changeBtn.rx.tap.map{_ in .changeSign},
                percentBtn.rx.tap.map{_ in .percent},
                equalBtn.rx.tap.map{_ in .equal},
                pointBtn.rx.tap.map{_ in .addDot},
                
                addBtn.rx.tap.map{_ in .operation(.addition)},
                minusBtn.rx.tap.map{_ in .operation(.subtraction)},
                multiplyBtn.rx.tap.map{_ in .operation(.multiplication)},
                devideBtn.rx.tap.map{_ in .operation(.divide)},
                
                zeroBtn.rx.tap.map{_ in .addNumber("0")},
                oneBtn.rx.tap.map{_ in .addNumber("1")},
                twoBtn.rx.tap.map{_ in .addNumber("2")},
                threeBtn.rx.tap.map{_ in .addNumber("3")},
                fourBtn.rx.tap.map{_ in .addNumber("4")},
                fiveBtn.rx.tap.map{_ in .addNumber("5")},
                sixBtn.rx.tap.map{_ in .addNumber("6")},
                sevenBtn.rx.tap.map{_ in .addNumber("7")},
                eightBtn.rx.tap.map{_ in .addNumber("8")},
                nineBtn.rx.tap.map{_ in .addNumber("9")},
                
                ])
        
        let system = Observable.system(CalculatorState.initial, accumulator: CalculatorState.reduce, scheduler: MainScheduler.instance) { _ in
            commands
        }
        .debug("calculator state")
        .shareReplayLatestWhileConnected()
        
        system.map{$0.screen}
        .bind(to: resultLabel.rx.text)
        .disposed(by: disposeBag)
        
        system.map{$0.sign}
        .bind(to: operatorsLabel.rx.text)
        .disposed(by: disposeBag)
    }
}
