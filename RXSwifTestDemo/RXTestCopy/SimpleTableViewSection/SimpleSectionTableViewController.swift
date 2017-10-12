//
//  SimpleSectionTableViewController.swift
//  RXSwifTestDemo
//
//  Created by DFHZ on 2017/10/11.
//  Copyright © 2017年 DFHZ. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

class SimpleSectionTableViewController: UIViewController,UITableViewDelegate {

    @IBOutlet weak var myTableView: UITableView!
    
    let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String,Double>>()
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let items = Observable.just([
            SectionModel.init(model: "First Section", items: [
                1.0,2.0,3.0]),
            SectionModel.init(model: "Second Section", items: [
                1.0,2.0,3.0]),
            SectionModel.init(model: "Third Section", items: [
                1.0,2.0,3.0])
            ])
        
        dataSource.configureCell = {(_,tableView,indexPath,element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "sectionCell", for: indexPath) as UITableViewCell
            cell.textLabel?.text = "显示的cell \(element) @ \(indexPath.row)"
            return cell
        }
        //添加头
        dataSource.titleForHeaderInSection = { data ,sectionIndex in
            return data[sectionIndex].model
        }
        //绑定数据
        items.bind(to: myTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        //设置代理
        myTableView.rx.setDelegate(self).disposed(by: disposeBag)
        //设置点击事件  包装信息
        myTableView.rx.itemSelected
            .map{ [unowned self] indexPath in
                return (indexPath,self.dataSource[indexPath])
            }.subscribe(onNext: { [unowned self](indexPath,element) in
                print("当前选中==\(indexPath.row) @ \(element)")
                self.showAlertView(info: "当前选中==\(indexPath.row) @ \(element)")
            }).disposed(by: disposeBag)
    }
    
    func showAlertView(info:String) {
        let alertView = UIAlertController.init(title: "提示", message: info, preferredStyle: .alert)
        let confirm = UIAlertAction.init(title: "确定", style: .default, handler: nil)
        alertView.addAction(confirm)
        present(alertView, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}
