//
//  OrderHomeViewModel.swift
//  Pharmacy
//
//  Created by osx on 28/01/20.
//  Copyright © 2020 osx. All rights reserved.
//

import Foundation
import UIKit

class OrderHomeViewModel : NSObject {
    
    func getOrderHistory(vc:UIViewController,prams:[String:String],success:@escaping (_ response: orderHomeModel) -> Void){
      Service.shareInstance.webservicesPostRequest3(baseString: Constants.kBaseUrl + Constants.KOrderSearch, parameters: prams , success: { (res) in
            if let dic = res.value(forKey: "data") as? NSDictionary{
                success(orderHomeModel(requestId: (dic.value(forKey: "id") as! Int), userName: "\(dic.value(forKey: "username") ?? "")", requeststatus: "\(dic.value(forKey: "request_status") ?? "")", requesttype: "\(dic.value(forKey: "request_type") ?? "")", Instruction: "\(dic.value(forKey: "instruction") ?? "")", Address: "\(dic.value(forKey: "address") ?? "")", ordernumber: "\(dic.value(forKey: "order_number") ?? "")", medicinecount: (dic.value(forKey: "medicine_count") as! Int) ))
            }
        }){ (err) in
            print(err)
            //            SingletonClass.shared.stopLoading()
        }
 
   
     }
    
 
}
