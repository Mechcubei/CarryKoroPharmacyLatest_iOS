//
//  Constant.swift
//  Tugforce
//
//  Created by osx on 06/06/19.
//  Copyright © 2019 osx. All rights reserved.
//

import Foundation
import UIKit


let refreshControl = UIRefreshControl()


struct Constants{
    
    static var isOpenFromSignUp :Bool = false
    
    //UserDefaultKeys
    static let kUserID = "userId"
    static let kDeviceID = "deviceToken"
    
    //ALERT MESSAGES
    static let kAlertTitle = "Alert"
    
    static var cancelArr = NSArray()
    static let kSuccessAlert = "Success"
    static let kErrorAlert = "Error"
    static let kMessage = "Un-known error occured please try again later"
        
    //APP THEME COLORS
    static let THEME_COLOR = UIColor(red: 255/255.0, green: 114/255.0, blue: 118/255.0, alpha: 1.0)
    
    static let THEME_COLORGRAY = UIColor(red: 235/255.0, green: 235/255.0, blue: 241/255.0, alpha: 1.0)
    
    static let THEME_COLORORANGE = UIColor(red: 252/255.0, green: 56/255.0, blue: 63/255.0, alpha: 1.0)
    static let DARK_Green = UIColor(red: 56/255.0, green: 142/255.0, blue: 60/255.0, alpha: 1.0)
    //Loacl Data Storage Keys
    static let kCategoriesLocal = "categories"
        
    //Base URL'S
    //    static let kBaseUrl = "https://carrykoro.com/public/api/"
    //    static let baseUrl = "https://carrykoro.com/public/api/"
    //    static let kSocketUrl = "http://134.209.157.211:3000/"
    //    //Socket Live and dev url
    //    static let kSocketUrlLive = "http://199.192.16.62:3001"
    //    static let kSocketUrlDev = "http://134.209.157.211:3001"
    //
    //    enum server:String{
    //          case live = "https://carrykoro.com/public/api/"
    //          case dev = "http://134.209.157.211/Carrykoro/public/api/"
    //    }
    
    //    // development url's
    //    static let kBaseUrl = server.live
    
    //Base URL'S
    static let kBaseUrl = "https://carrykoro.com/public/api/"
    static let baseUrl = "https://carrykoro.com/public/api/"
//    static let kBaseUrl = "http://134.209.157.211/Carrykoro/public/api/"
//    static let baseUrl = "http://134.209.157.211/Carrykoro/public/api/"
    static let kSocketUrl = "http://134.209.157.211:3001"
        
    // API METHODS
    static let kLogin = "login"
    static let kRegister = "pharmacy-register"
    static let kResendOTP = "resend_code"
    static let kCountryDetail = "get-Country"
    static let kGetDriver = "getdriver"
    static let kGetProfile = "details"
    static let kEditProfile = "updateprofile"
    static let kgetcoordinates = "getcoordinates"
    static let kCancelReason = "cancel-reasons"
    static let kCompleteProfile = "updateprofile"
    static let kgetVehicleType = "get-vehicle-types"
    static let kUserTypes  = "user-types"
    static let kAddVehicle = "add-vehicle"
    static let kgetCountry = "get-Country"
    static let kgetState = "get-state"
    static let kgetCity = "get-city"
    static let kAddDriver = "add-driver"
    static let getEarningHistory = "get-driver-earning"
    static let getHistory = "get-rides"
    static let getCountryCode = "countryCOde"
    static let kVerifyOtp = "verified-otp"
    static let kforgotVerifyOTP = "forgotverifcation-otp"
    static let KOrderSearch = "ordersearch"
    static let kForgotPassword = "forgot-password"
    static let kchangePassword = "changepassword"
    static let forgotChangePassword = "forgot"
    static let kGetOrderDetail = "orderrequest"
    static let kcancelReason = "cancellations"
    static let KAccpetOrder = "accept-order"
    static let kCancelOrder = "cancel-request"
    static let GetProfile = "getprofile"
    static let editPicture = "edit-imageupload"
    static let addPharmacyDetail = "add-pharmacyedetails"
    static let kverificationotp = "verification-otp"
    static let kEditOrder = "editorder-request"
    static let EditProfile = "pharmacy-editprofile"
    static let kGetRating = "get-userrating"
    static let editBanner = "banner-upload"
    static let VerifyEmailPhone = "verification-otp"
    static let korderTracking = "order-tracking"
    static let kupdateNotification =  "update-online-status"
    static let KNotificationCount = "get-noti-count"
     static let KReadNotification = "notification-read"
     static let KgetNotification = "get_notification"

}
 
extension String {
    var isNumericValue: Bool {
        return !isEmpty && range(of: "[^0-9]", options: .regularExpression) == nil
    }
    var isAlphabetValue: Bool {
        return !isEmpty && range(of: "[^a-zA-Z]", options: .regularExpression) == nil
    }
    
        func isValidEmail() -> Bool {
            // here, `try!` will always succeed because the pattern is valid
            let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
        }
    func replaceCharacters(characters: String, toSeparator: String) -> String {
        let characterSet = NSCharacterSet(charactersIn: characters)
        let components = self.components(separatedBy: characterSet as CharacterSet)
           let result = components.joined(separator: "") 
           return result
       }

       func wipeCharacters(characters: String) -> String {
        return self.replaceCharacters(characters: characters, toSeparator: "")
       }
    
    enum validityType {
        case email
        case age
         
    }
    enum Regex : String{
        case email = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        case age = ""
    }
            
    func isValid(_ validityType: validityType) -> Bool{
         var format = "SELF MATCHES %@"
         var regex = ""
        switch validityType{
           case .email:
            regex = Regex.email.rawValue
           case .age:
            regex = Regex.age.rawValue
        }
           print(validityType)
        return NSPredicate(format: format, regex).evaluate(with: "")
     
    }
   
}
extension UINavigationController {

   func backToViewController(vc: Any) {
      // iterate to find the type of vc
      for element in viewControllers as Array {
        if "\(type(of: element)).Type" == "\(type(of: vc))" {
            self.popToViewController(element, animated: true)
            break
         }
      }
   }
}

extension UIApplication{
        
    func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
