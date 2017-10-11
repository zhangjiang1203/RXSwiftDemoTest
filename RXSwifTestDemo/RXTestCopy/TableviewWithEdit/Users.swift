//
//  Users.swift
//  RXSwifTestDemo
//
//  Created by DFHZ on 2017/10/11.
//  Copyright © 2017年 DFHZ. All rights reserved.
//

import Foundation

struct Users:Equatable,CustomDebugStringConvertible {
    
    var firstName:String
    var lastName:String
    var imageURL:String
    
    init(first:String,last:String,image:String) {
        firstName = first
        lastName = last
        imageURL = image
    }
}

extension Users{
    var debugDescription:String{
        return firstName + " " + lastName
    }
}

func ==(lhs: Users, rhs: Users) -> Bool {
    return lhs.firstName == rhs.firstName &&
        lhs.lastName == rhs.lastName &&
        lhs.imageURL == rhs.imageURL
}
