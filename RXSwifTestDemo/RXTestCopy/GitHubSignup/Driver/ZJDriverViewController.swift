//
//  ZJDriverViewController.swift
//  RXSwifTestDemo
//
//  Created by DFHZ on 2017/9/28.
//  Copyright © 2017年 DFHZ. All rights reserved.
//

import UIKit

class ZJDriverViewController: UIViewController {
    
    @IBOutlet weak var accontField: UITextField!
    
    @IBOutlet weak var accountLabel: UILabel!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var passwordLabel: UILabel!
    
    @IBOutlet weak var repeatField: UITextField!
    
    @IBOutlet weak var repeatLabel: UILabel!
    
    
    @IBOutlet weak var signUpBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        signUpBtn.layer.cornerRadius = 20
    }

}
