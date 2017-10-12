//
//  ZJUserDetailViewController.swift
//  RXSwifTestDemo
//
//  Created by DFHZ on 2017/10/12.
//  Copyright © 2017年 DFHZ. All rights reserved.
//

import UIKit
import Kingfisher


class ZJUserDetailViewController: UIViewController {
    
    var user:Users!
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        userImageView.layer.cornerRadius = 5
        userImageView.layer.masksToBounds = true
        userNameLabel.text = user.firstName + " " + user.lastName
        let url = URL(string: user.imageURL)
        //使用imageResource封装成Resource
        userImageView.kf.setImage(with: ImageResource.init(downloadURL: url!))
    }
}


