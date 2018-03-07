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
    
    //定义的BehaviorSubject初始化的时候添加的模型数据类型和定义的dataSource中的数据类型要一致
    //定义的SectionModel中显示的类可以定义为任何你想定义的类型
    var anyListInfo:BehaviorSubject = BehaviorSubject.init(value: [SectionModel<String,Any>]())
    var myInfoList:BehaviorSubject = BehaviorSubject.init(value: [SectionModel<String, Double>]())
    
    let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String,Double>>()
    var itemSource:Observable<[SectionModel<String,Double>]>!
    var result:    Observable<[SectionModel<String,Double>]>?
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        rightBarButton()
        
        dataSource.configureCell = {(_,tableView,indexPath,element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "sectionCell", for: indexPath) as UITableViewCell
            cell.textLabel?.text = "显示的cell \(element) @ \(indexPath.row)"
            return cell
        }
        //添加头
        dataSource.titleForHeaderInSection = { data ,sectionIndex in
            return data[sectionIndex].model
        }
        //数据关联
        myInfoList.asObserver()
            .bind(to: myTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        myInfoList.onNext([SectionModel.init(model: "", items: [23,89,24,100,34])])
        //设置代理
        myTableView.rx.setDelegate(self).disposed(by: disposeBag)
        //设置点击事件  包装信息
        myTableView.rx.itemSelected
            .map{ [unowned self] indexPath in
                return (indexPath,self.dataSource[indexPath])
            }.subscribe(onNext: { [unowned self](indexPath,element) in
                print("当前选中==\(indexPath.row) @ \(element)")
                let delegateVC =  SubjectDelegateViewController.init(nibName: "SubjectDelegateViewController", bundle: nil);
                delegateVC.publishDel.subscribe(onNext: { (index) in
                    print("代理开始传值："+"\(index)")
                }).disposed(by: self.disposeBag)
                self.navigationController?.pushViewController(delegateVC, animated: true)
            }).disposed(by: disposeBag)
    }
    
    
    func rightBarButton()  {
        let button = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 30))
        button.setTitle("修改", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.rx.tap.subscribe(onNext: { (sender) in
            self.createMyDataSource(data: [12,90,23,89,45])
        }).disposed(by: disposeBag)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: button)
        
    }
    
    func createMyDataSource(data:Array<Double>) {
        myInfoList.onNext([SectionModel.init(model: "hahha", items: data)])
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
