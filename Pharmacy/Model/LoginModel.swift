//
//  LoginModel.swift
//  Pharmacy
//
//  Created by osx on 29/01/20.
//  Copyright © 2020 osx. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

struct LoginModel{
    let id: Int
    let username : String
    let first_name: String
    let last_name: String
    let email: String
    let image: String
    let phone : String
    let role : String
    let status : String
    let address : String
    let longitude:String
    let latitiude : String
    let gender: String
    let dob : String
    let city : String
    let age : String
    let token : String
    let phoneStatus : String
    let otp : String
    let message : String
}
 
 
struct CountryModel {
    var flagImg :String
    var name :String
    var Code :String
    var CodeName : String
}

 
