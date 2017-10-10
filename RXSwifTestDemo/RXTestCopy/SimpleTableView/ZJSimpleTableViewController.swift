//
//  ZJSimpleTableViewController.swift
//  RXSwifTestDemo
//
//  Created by DFHZ on 2017/10/10.
//  Copyright © 2017年 DFHZ. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


class ZJSimpleTableViewController: UIViewController ,UITableViewDelegate{

    @IBOutlet weak var myTableView: UITableView!
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        let items = Observable.just(
            (0..<20).map { "\($0)" }
        )
        //开始设置tableview
        items
            .bind(to: myTableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { (row, element, cell) in
                cell.textLabel?.text = "\(element) @ row \(row)"
            }
            .disposed(by: disposeBag)
        //tableViewcell的点击
        items.bind(to: myTableView.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)){ (row,element,cell) in
            
            
        }
    }
}
