//
//  listModel.swift
//  rxswiftTODO
//
//  Created by cedcoss on 11/08/21.
//

import Foundation

enum priority:Int {
    case high
    case medium
    case low
}
struct listing{
    let title:String
    let priority:priority
}
