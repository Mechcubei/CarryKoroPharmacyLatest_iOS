//
//  ViewController.swift
//  Pharmacy
//
//  Created by osx on 13/01/20.
//  Copyright © 2020 osx. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}
extension UIViewController: NVActivityIndicatorViewable
 {
    
        // show progress hud
        func showProgress() {
         // loader starts
         let size = CGSize(width: 50, height:50)
            self.startAnimating(size, message:"Loading", messageFont: UIFont.systemFont(ofSize: 18.0), type: NVActivityIndicatorType.ballScaleMultiple, color: UIColor.white, padding: 1, displayTimeThreshold: nil, minimumDisplayTime: nil)
     }
    
     // hide progress hud
     func hideProgress() {
         // stop loader
         DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
             self.stopAnimating() }
     }
 }

extension UIViewController : UITextFieldDelegate {
 
    func isValidEmail(_ emailId:String) -> Bool{
        let emailRegEx = "^[A-Za-z0-9._%+\\-]+@[A-Za-z0-9.\\-]+\\.[A-Za-z]{2,4}$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: emailId)
    }
        
    func alert(_ title: String, message:String){
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertView, animated: true, completion: nil)
    }
}
