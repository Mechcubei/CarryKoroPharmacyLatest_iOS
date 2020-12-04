//
//  SingletonVariables.swift
//  Tugforce
//
//  Created by osx on 07/06/19.
//  Copyright © 2019 osx. All rights reserved.
//

import UIKit
import Foundation


class SingletonVariables: NSObject {
    
    //Mark: Singleton Object Creation
    
    static let sharedInstance : SingletonVariables  = {
        let singletonObject = SingletonVariables()
        return singletonObject
    }()
    
    var userID = String()
    var getCodeArr = NSArray()
    var getFlagArr = NSArray()
     var countryCodeName = NSArray()
    var getCode = ""
    var userToken = ""
    var getCancelReasonId = ""
    var flagImgArr = NSArray()
    var flagImg = ""
    var lat = ""
    var long = ""
    var address  = ""
    var newData = ["id":0,"quantity":0,"medicine_name":"","price":0,"assigned_pharmacy":0] as! [String:Any]

}
