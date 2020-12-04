//
//  OrderHomeMode.swift
//  Pharmacy
//
//  Created by osx on 28/01/20.
//  Copyright © 2020 osx. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

struct orderHomeModel {
    let requestId: Int
    let userName : String
    let requeststatus: String
    let requesttype : String
    let Instruction: String
    let Address : String
    let ordernumber: String
    let medicinecount : Int
}

struct MedicineModel : Codable{
     var assigned_pharmacy = ""
     var medicine_id = ""
     var medicine_name = ""
     var price = ""
     var quantity = ""
    var showDeleteButton = ""
    var showCheck = ""
    var isSelected = false
    var total = Int()
    var isdded = Bool()
}
