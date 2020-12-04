//
//  RegViewModel.swift
//  Pharmacy
//
//  Created by osx on 23/01/20.
//  Copyright © 2020 osx. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

@available(iOS 13.0, *)

extension NSObject {
    public var topMostVC:UIViewController?{
           return UIApplication.getTopViewController()
    }
    
    class func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)
            
        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)
            
        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
    
    
}


@available(iOS 13.0, *)
class RegisterViewModel: UIViewController {
    
    func getRegData(vc:UIViewController,prams:[String:String],success:@escaping (_ response: RegisterModel) -> Void){
        Service.shareInstance.webservicesPostRequest2(baseString: Constants.kBaseUrl + Constants.kRegister, parameters: prams , success: { (res) in
            self.hideProgress()

            print(res)
           
            if let status =  res.value(forKey: "has_data") as? Int{
                if status == 0{
                // stop loader
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
                Utilities.show(alert: "Alert", message: res.value(forKey: "message") as! String, buttonText: "Ok", buttonOk:{()in
                self.dismiss(animated: true, completion: nil)})
                    
                }
            }else {
                    
                if let dic = res.value(forKey: "data") as? NSDictionary{
                    
                        success(RegisterModel(id: (dic.value(forKey: "id") as! Int), otp: "\(dic.value(forKey: "otp") ?? "")", status: "\(dic.value(forKey: "status") ?? "")", token: "\(dic.value(forKey: "token") ?? "")", message: ""))
                    }
                }
            }
            
        }) { (err) in
            
            print(err)
            self.hideProgress()
            //SingletonClass.shared.stopLoading()
            
        }
    }
   
}
