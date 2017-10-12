//
//  ZJEditTableViewController.swift
//  RXSwifTestDemo
//
//  Created by DFHZ on 2017/10/11.
//  Copyright © 2017年 DFHZ. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

struct TableViewEditComandsViewModel {
    let favoriteUsers:[Users]
    let users :[Users]
    
    //添加方法
    static func executeCommand(state:TableViewEditComandsViewModel,_ command:TableViewEditingCommand) -> TableViewEditComandsViewModel{
        switch command {
        case let .setUsers(Users):
            return TableViewEditComandsViewModel.init(favoriteUsers: state.favoriteUsers, users: Users)
        case let .setFavoriteUsers(favoriteUsers):
            return TableViewEditComandsViewModel.init(favoriteUsers: favoriteUsers, users: state.users)
        case let .deleteUser(IndexPath):
            var all = [state.favoriteUsers,state.users]
            all[IndexPath.section].remove(at: IndexPath.row)
            return TableViewEditComandsViewModel.init(favoriteUsers: all[0], users: all[1])
        case let .moveUser(from, to):
            var all = [state.favoriteUsers,state.users]
            let user = all[from.section][from.row]
            all[from.section].remove(at: from.row)
            all[to.section].insert(user, at: to.row)
            return TableViewEditComandsViewModel.init(favoriteUsers: all[0], users: all[1])
        }
    }
    
}


//定义tableView的操作
enum TableViewEditingCommand {
    case setUsers(Users:[Users])
    case setFavoriteUsers(favoriteUsers:[Users])
    case deleteUser(IndexPath:IndexPath)
    case moveUser(from:IndexPath,to:IndexPath)
}

class ZJEditTableViewController: UIViewController,UITableViewDelegate {

    @IBOutlet weak var myTableView: UITableView!
    
    let dataSource = ZJEditTableViewController.configurationDataSource()
    let disposeBag = DisposeBag()
    
    //设置数据源
    override func viewDidLoad() {
        super.viewDidLoad()

        let superMan = Users(
            first: "Super",
            last: "Man",
            image: "http://nerdreactor.com/wp-content/uploads/2015/02/Superman1.jpg"
        )
        
        let watchMan = Users(
            first:"Watch",
            last:"Man",
            image:"http://www.iri.upc.edu/files/project/98/main.GIF"
        )
        
        //请求数据
        let loadFavoriteUsers = RandomUserAPI.shareAPI.getRandomUserResult()
            .map(TableViewEditingCommand.setUsers)
            .catchErrorJustReturn(TableViewEditingCommand.setUsers(Users: []))
        
        let initialLoadCommand = Observable.just(TableViewEditingCommand.setFavoriteUsers(favoriteUsers: [superMan,watchMan]))
            .concat(loadFavoriteUsers)
            .observeOn(MainScheduler.instance)
        
        let deleteUsersCommmand = myTableView.rx.itemDeleted.map(TableViewEditingCommand.deleteUser)
        
        let moveUserCommand = myTableView.rx.itemMoved.map(TableViewEditingCommand.moveUser)
        
        let initialState = TableViewEditComandsViewModel.init(favoriteUsers: [], users: [])

        let viewModel = Observable.system(initialState,
                        accumulator: TableViewEditComandsViewModel.executeCommand,
                        scheduler: MainScheduler.instance,
                        feedback: {_ in initialLoadCommand},{_ in deleteUsersCommmand},{ _ in moveUserCommand})
            .shareReplay(1)
        //viewModel绑定到dataSource
        viewModel
            .map{[
               SectionModel(model: "Favorite Users", items: $0.favoriteUsers),
               SectionModel(model: "Normal Users", items: $0.users)
            ]}
            .bind(to: myTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        myTableView.rx.itemSelected
            .map{ [unowned self] indexPath in
                return (indexPath,self.dataSource[indexPath])
            }.subscribe(onNext: { [unowned self](indexPath,user) in
//                print("当前选中==\(indexPath.row) @ \(user)")
                self.showDetailsForUser(user)
            }).disposed(by: disposeBag)
        
        myTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    private func showDetailsForUser(_ user: Users) {
        let storyboard = UIStoryboard(name: "EditTableView", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "userDetailVC") as! ZJUserDetailViewController
        viewController.user = user
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    static func configurationDataSource()-> RxTableViewSectionedReloadDataSource<SectionModel<String,Users>> {
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String,Users>>()
        dataSource.configureCell = { (_,tv,ip,user:Users) in
            let cell = tv.dequeueReusableCell(withIdentifier: "systemCell")!
            cell.textLabel?.text = user.firstName + " " + user.lastName
            return cell
        }
        
        //能否编辑
        dataSource.titleForHeaderInSection = {
            data,section in
            return data[section].model
        }
        
        dataSource.canEditRowAtIndexPath = {(data,indexpath) in
            return true
        }
        
        dataSource.canMoveRowAtIndexPath = { (data,indexpath) in
            return true
        }
        
        return dataSource
    }

}
