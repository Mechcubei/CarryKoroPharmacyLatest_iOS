//
//  ProfileViewModel.swift
//  Pharmacy
//
//  Created by osx on 31/01/20.
//  Copyright © 2020 osx. All rights reserved.
//

import Foundation
import UIKit
class ProfileViewModel : NSObject {
    
    func getProfileData(vc:UIViewController,prams:[String:String],success:@escaping (_ response: ProfileModel) -> Void){
        NetworkingService.shared.getData_HeaderParameter(PostName: Constants.GetProfile, parameters: prams, completion: { (resp) in
             print(resp)
             let res = resp as! NSDictionary
                       if let dic = res.value(forKey: "data") as? NSDictionary{
                        success(ProfileModel(image: "\(dic.value(forKey: "logo") ?? "")",
                                             userId:  Int((dic.value(forKey: "user_id") as! String))!,
                                             first_name: "\(dic.value(forKey: "username") ?? "")",
                                             last_name: "\(dic.value(forKey: "reg_no") ?? "")",
                                             email: "\(dic.value(forKey: "email") ?? "")",
                                             Phone:Int((dic.value(forKey: "phone") as! String))!,
                                             address: "\(dic.value(forKey: "address") ?? "")",
                                             emailStatus: "\(dic.value(forKey: "email_status") ?? "")",
                                             phoneStatus: "\(dic.value(forKey: "phone_status") ?? "")",
                                             banner: "\(dic.value(forKey: "banner") ?? "")",
                                             landline: "\(dic.value(forKey: "landline") ?? "")",
                                             rating: "\(dic.value(forKey: "rating") ?? "")"))
                       }
        })
    }
}
