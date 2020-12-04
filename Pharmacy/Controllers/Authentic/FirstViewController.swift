//
//  FirstViewController.swift
//  HealthCare
//
//  Created by osx on 03/01/20.
//  Copyright © 2020 osx. All rights reserved.


import UIKit

@available(iOS 13.0, *)
class FirstViewController: UIViewController {
    
    let profileVM = ProfileViewModel()
    
    //MARK:- Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.value(forKey: Constants.kUserID) != nil {
            
            if  "\(UserDefaults.standard.value(forKey: Constants.kUserID)!)" != ""{
                
                self.GetProfile()
                
            }else{
                
                self.moveToSecondViewController()
            }
            
        }else {
            
            self.moveToSecondViewController()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    //MARK:- Extra functions
    func moveToSecondViewController(){
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SecondViewController") as? SecondViewController
        self.navigationController!.pushViewController(viewController!, animated: false)
    }
    
    //MARK:-Action
    @IBAction func btnSignIn(_ sender: UIButton) {
        
    }
    
    @IBAction func btnCreateAccount(_ sender: UIButton) {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RegisterViewController") as? RegisterViewController
        self.navigationController!.pushViewController(viewController!, animated: true)
    }
    
    //MARK:- Api
    func GetProfile(){
        
        let params : [String : String] = ["user_type":"pharmacy"]
        
        profileVM.getProfileData(vc: self, prams: params) { (resp) in
            print(resp)
            
            let banner = resp.banner
            
            UserDefaults.standard.set(resp.userId, forKey:Constants.kUserID)
            
            if banner == ""{
                
                let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PharmacyRegisterVC") as? PharmacyRegisterVC
                self.navigationController!.pushViewController(viewController!, animated: true)
                
//                let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarViewController") as? TabBarViewController
//                self.navigationController!.pushViewController(viewController!, animated: true)
                
            }else {
                
                let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarViewController") as? TabBarViewController
                self.navigationController!.pushViewController(viewController!, animated: true)
                
                
            }
            self.hideProgress()
        }
    }
}
