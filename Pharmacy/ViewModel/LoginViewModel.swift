//
//  LoginViewModel.swift
//  Pharmacy
//  Created by osx on 29/01/20.
//  Copyright © 2020 osx. All rights reserved.


import Foundation
import UIKit
import Alamofire

class LoginViewModel: NSObject {
    
    func getLoginData(vc:UIViewController,prams:[String:String],success:@escaping (_ response: LoginModel) -> Void){
        Service.shareInstance.webservicesPostRequest2(baseString: Constants.kBaseUrl + Constants.kLogin, parameters: prams , success: { (res) in
            print(res)
            if let dic = res.value(forKey: "data") as? NSDictionary{
                success(LoginModel(
                            id: (dic.value(forKey: "id") ?? "") as! Int,
                            username: "\(dic.value(forKey: "username") ?? "last_name")",
                            first_name: "\(dic.value(forKey: "first_name") ?? "")",
                            last_name: "\(dic.value(forKey: "last_name") ?? "")",
                            email: "\(dic.value(forKey: "email") ?? "")",
                            image: "\(dic.value(forKey: "image") ?? "")",
                            phone: (dic.value(forKey: "phone") ?? "") as! String ,
                            role: "\(dic.value(forKey: "role") ?? "")",
                            status: (dic.value(forKey: "status")  ?? "") as! String,
                            address: "\(dic.value(forKey: "address") ?? "")",
                            longitude: "\(dic.value(forKey: "longitude") ?? "")",
                            latitiude: "\(dic.value(forKey: "latitiude") ?? "")",
                            gender: "\(dic.value(forKey: "gender") ?? "")",
                            dob: "\(dic.value(forKey: "dob") ?? "")",
                            city: "\(dic.value(forKey: "city") ?? "")",
                            age: (dic.value(forKey: "age") ?? "") as! String,
                            token: "\(dic.value(forKey: "token") ?? "")",
                            phoneStatus: (dic.value(forKey: "phone_status") as! String),
                            otp: (dic.value(forKey: "otp") as! String),
                            message: ""))
            }
            if let message =  res.value(forKey: "message") as? String{
                if message == "Check Your credentials"{
                        success(LoginModel(id: 0,
                                           username: "",
                                           first_name: "",
                                           last_name: "",
                                           email: "",
                                           image: "",
                                           phone: "",
                                           role: "",
                                           status: "",
                                           address: "", longitude: "",
                                           latitiude: "", gender: "",
                                           dob: "", city: "",
                                           age: "",
                                           token: "",
                                           phoneStatus: "",
                                           otp: "",
                                           message: message))
                }
            }
            
        }) { (err) in
            print(err)
            //            SingletonClass.shared.stopLoading()
        }
    }
   
}
