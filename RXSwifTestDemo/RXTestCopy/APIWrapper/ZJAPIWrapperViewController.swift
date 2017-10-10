//
//  ZJAPIWrapperViewController.swift
//  RXSwifTestDemo
//
//  Created by DFHZ on 2017/10/10.
//  Copyright © 2017年 DFHZ. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ZJAPIWrapperViewController: UIViewController {
    
    @IBOutlet weak var rightBarBtn: UIBarButtonItem!
    
    @IBOutlet weak var testButton: UIButton!
    @IBOutlet weak var segmentTest: UISegmentedControl!
    
    @IBOutlet weak var switchTest: UISwitch!
    
    @IBOutlet weak var datePickerTest: UIDatePicker!
    
    @IBOutlet weak var sliderTest: UISlider!
    
    @IBOutlet weak var fieldTest: UITextField!
    
    @IBOutlet weak var showInfoLabel: UILabel!
    @IBOutlet var tapTest: UITapGestureRecognizer!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePickerTest.date = Date(timeIntervalSince1970: 0)
        //绑定事件
        rightBarBtn.rx.tap.subscribe( onNext:{
            [unowned self] x in
            self.showInfoLabel.text = "导航栏按钮点击"
        }).addDisposableTo(disposeBag)
        
        testButton.rx.tap.subscribe(onNext:{
            self.showInfoLabel.text = "按钮点击"
        }).disposed(by: disposeBag)
        
//        let segmentValue = Variable(0)
//        _ = segmentTest.rx.value <-> segmentValue
//        segmentValue.asObservable()
//            .subscribe(onNext:{ (value) in
//                self.showInfoLabel.text = "分段器点击==\(value)"
//            }).disposed(by: disposeBag)
        
        let segmentValue = Variable(0)
        _ = segmentTest.rx.value <-> segmentValue
        segmentTest.rx.value.asObservable()
            .subscribe(onNext:{ [unowned self](value) in
                self.showInfoLabel.text = "分段器点击==\(value)"
            }).disposed(by: disposeBag)
        
        switchTest.rx.value.asObservable()
            .subscribe(onNext:{ [unowned self](value) in
                self.showInfoLabel.text = "切换器点击==\(value)"
            }).disposed(by: disposeBag)
        
        datePickerTest.rx.value.asObservable()
            .subscribe(onNext: { [unowned self](date) in
                self.showInfoLabel.text = "时间选择器==\(date)"
            }).disposed(by: disposeBag)
        
        sliderTest.rx.value.asObservable()
            .subscribe(onNext: { [unowned self](value) in
                self.showInfoLabel.text = "滑动器==\(value)"
            }).disposed(by: disposeBag)
        
        fieldTest.rx.text.asObservable()
            .subscribe(onNext: { [unowned self](value) in
                self.showInfoLabel.text = "输入框选择器=="+value!
            }).disposed(by: disposeBag)
        
        tapTest.rx.event.subscribe({ (tap) in
            self.showInfoLabel.text = "手势点击==😁😁😁"
        }).disposed(by: disposeBag)
    }
}
