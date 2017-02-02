//
//  Status.swift
//  Pomodoro
//
//  Created by 蘇健豪1 on 2017/2/2.
//  Copyright © 2017年 Oyster. All rights reserved.
//

import Foundation

class Status {
    
}

var status: String {
    get {
        return UserDefaults.standard.value(forKey: "status") as! String
    }

    set {
        UserDefaults.standard.set(newValue, forKey: "status")
    }
}


enum statusEnum : String {
    case nothing = "nothing"
    case working = "working"
    case rest = "rest"
}
