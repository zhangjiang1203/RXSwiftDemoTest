//
//  RandomUserAPI.swift
//  RXSwifTestDemo
//
//  Created by DFHZ on 2017/10/11.
//  Copyright © 2017年 DFHZ. All rights reserved.
//

import Foundation
import RxSwift

import struct Foundation.URL
import class Foundation.URLSession

func exampleError(_ error: String, location: String = "\(#file):\(#line)") -> NSError {
    return NSError(domain: "ExampleError", code: -1, userInfo: [NSLocalizedDescriptionKey: "\(location): \(error)"])
}


class RandomUserAPI {
    static let shareAPI = RandomUserAPI()
    
    init() {}
    
    //获取用户
    func getRandomUserResult() -> Observable<[Users]> {
        let url = URL(string: "http://api.randomuser.me/?results=20")!
        return URLSession.shared.rx.json(url: url).map{
            json in
            guard let json = json as? [String:AnyObject] else{
                throw exampleError("不能转化成字典")
            }
            return try self.dealWithJSON(json: json)
        }
    }
    
    //处理json的数据结果
    func dealWithJSON(json:[String:AnyObject]) throws -> [Users] {
        guard let result = json["results"] as? [[String:AnyObject]] else {
            throw exampleError("找不到结果")
        }
        
        let userParseError = exampleError("结果处理出错")
        let userResult:[Users] = try result.map { user in
            let name = user["name"] as? [String:String]
            let imageurl = user["picture"] as? [String:String]
            
            guard let first = name?["first"] ,let last = name?["last"] ,let imageURL = imageurl?["medium"] else{
                throw userParseError
            }
            
            let returnUser = Users(first: first, last: last, image: imageURL)
            return returnUser
        }
        return userResult
    }
}
