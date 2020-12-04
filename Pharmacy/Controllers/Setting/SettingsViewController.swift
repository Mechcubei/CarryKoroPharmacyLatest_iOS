//
//  SettingsViewController.swift
//  HealthCare

//  Created by osx on 13/01/20.
//  Copyright © 2020 osx. All rights reserved.

import UIKit
import Foundation
import Alamofire

@available(iOS 13.0, *)
class SettingsViewController: UIViewController {
    
    //MARK:- Properties
    @IBOutlet var logoutView: UIView!
    @IBOutlet var NotificationsImg: UIImageView!

    var lblNameArr = [String]()
    var status:String?

    
    //MARK:- Life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ConnectSocket.shared.addHandler()
        ConnectSocket.shared.connectSocket()
        logoutView.isHidden = true
        lblNameArr = ["Profile","Delivery Addresses","Notification","Help","Logout"]
        // Do any additional setup after loading the view.
        self.setOnloneStatus()
    }
    
    override func viewWillAppear(_ animated: Bool) {
           self.navigationController?.isNavigationBarHidden = false
    }
  
    @IBAction func btnProfile(_ sender: UIButton) {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController {
                    if let navigator = self.navigationController{
                    navigator.pushViewController(viewController, animated: true)
            }
        }
    }
    
    @IBAction func btnPrivacypolicy(_ sender: UIButton) {
        if let link = URL(string: "https://carrykoro.com/privacy-policy") {
          UIApplication.shared.open(link)
        }
    }
    
    
    @IBAction func btnFAQ(_ sender: UIButton) {
        if let link = URL(string: "https://carrykoro.com/faq") {
          UIApplication.shared.open(link)
        }
    }

    @IBAction func LogoutButton(_ sender: UIButton) {
        clearData()
        
    }
    @IBAction func cancelBtn(_ sender: UIButton) {
        logoutView.isHidden = true
    }
    
    @IBAction func btnLogout(_ sender: UIButton) {
        logoutView.isHidden = false
    }
    
    
    func setOnloneStatus(){
        if let status = UserDefaults.standard.value(forKey: "onlineStatus") {
            UserDefaults.standard.setValue(status, forKeyPath:"onlineStatus" )
            self.setNotificationImage(status:status as! String)
        }else {
            UserDefaults.standard.setValue("No", forKey: "onlineStatus")
            self.setNotificationImage(status:"No")
        }
    }
    
    @IBAction func notification(_ sender: UIButton) {
        let onlineStatus = UserDefaults.standard.value(forKey: "onlineStatus") as! String
        if onlineStatus == "Yes"{
            self.updateNotificationStatus(status: "No")
        }else {
            self.updateNotificationStatus(status: "Yes")
        }
    }
        
    
    func LogoutFunction(){
         if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FirstViewController") as? FirstViewController {
                          if let navigator = self.navigationController {
                              navigator.pushViewController(viewController, animated: false)
              }
          }
   }
     
     func clearData(){
        let userId = ""
        UserDefaults.standard.set("\(userId)", forKey: Constants.kUserID)
        UserDefaults.standard.synchronize()
         LogoutFunction()
     }
    
    
    
            
    func updateNotificationStatus(status:String){
        print(status)
        
        let params = [
            "online_status":status,
        ]
                
        print(params)
        showProgress()
        
        NetworkingService.shared.getData_HeaderParameter(PostName: Constants.kupdateNotification, parameters: params ){ (resp) in
            self.hideProgress()

            print(resp)
            
            let dic = resp as! NSDictionary
            let status:Int  = dic["has_data"] as! Int
            
            if status == 1 {
                let data =   dic["data"] as! NSDictionary
                let onlineSatus:String = (data["online_status"] as? String)!
                UserDefaults.standard.setValue(onlineSatus, forKey: "onlineStatus")
                
                self.setNotificationImage(status:onlineSatus)
                
            }else {
                self.alert("Alert", message:dic["message"] as! String)
            }

               self.hideProgress()
        }
    }
        
    func setNotificationImage(status:String){
        self.NotificationsImg.image = status == "Yes" ? UIImage(named: "switchon ") : UIImage(named: "switchoff")
    }
}

@available(iOS 13.0, *)
extension SettingsViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lblNameArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! settingsTable
        cell.lblName.text = lblNameArr[indexPath.row]
      
        
        if indexPath.row == 2 {
            cell.imgView.image = #imageLiteral(resourceName: "switchon ")
        }
        if indexPath.row == 3 {
            cell.imgView.image = #imageLiteral(resourceName: "help ")
        }
        if indexPath.row == 4 {
            cell.imgView.image = #imageLiteral(resourceName: "logout")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
                  
              }
    }
    
    
}

class settingsTable : UITableViewCell {
    @IBOutlet var lblName: UILabel!
    @IBOutlet var imgView: UIImageView!
}
