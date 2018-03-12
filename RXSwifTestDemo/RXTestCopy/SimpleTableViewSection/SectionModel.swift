//
//  SectionModel.swift
//  RXSwifTestDemo
//
//  Created by Sljr on 2018/3/7.
//  Copyright © 2018年 DFHZ. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

class SectionModel: NSObject {

    func getUsers(data:[Double]) -> Observable<[SectionModel<String, Double>]> {
        return Observable.create { (observer) -> Disposable in
            let users = data
            let section = [SectionModel(model: "", items: users)]
            observer.onNext(section)
            observer.onCompleted()
            return Disposables.create()
        }
    }
}
