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
    

    var itemSource:Observable<[String]>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let items = Observable.just(
//            (0..<20).map { "\($0)" }
//        )
//        items
//            .bind(to: myTableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { (row, element, cell) in
//                cell.textLabel?.text = "\(element) @ row \(row)"
//            }
//            .disposed(by: disposeBag)
        itemSource = createMyDataSource(data:["zhangsan","lisi","wanger","zhaowu"])
        itemSource.bind(to: myTableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)){
            (row,element,cell) in
            cell.textLabel?.text = element
            }.disposed(by:disposeBag)
        
        myTableView.rx
            .modelSelected(String.self)
            .subscribe(onNext:  { [unowned self]value in
                print("开始选中====\(value)")
                self.itemSource = self.createMyDataSource(data: ["zhang","wang","li","zhao","guo","liu","he"])
                self.myTableView.reloadData()
                
//                self.showAlertView(info: "开始选中====\(value)")
            })
            .disposed(by: disposeBag)
        
        myTableView.rx
            .itemAccessoryButtonTapped
            .subscribe(onNext: { indexPath in
                print("显示详情===\(indexPath.row)")
                self.showAlertView(info: "显示详情===\(indexPath.row)")
            })
            .disposed(by: disposeBag)
    }
    
    func showAlertView(info:String) {
        let alertView = UIAlertController.init(title: "提示", message: info, preferredStyle: .alert)
        let confirm = UIAlertAction.init(title: "确定", style: .default, handler: nil)
        alertView.addAction(confirm)
        present(alertView, animated: true, completion: nil)
    }
    
    func createMyDataSource(data:Array<String>) -> Observable<[String]> {
        return Observable.from(optional: data)
    }
}
