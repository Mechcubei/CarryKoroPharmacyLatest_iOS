//
//  DemoViewController.swift
//  Pharmacy
//
//  Created by osx on 23/01/20.
//  Copyright © 2020 osx. All rights reserved.
//

import UIKit

class DemoViewController: UIViewController {

    @IBOutlet var lblCountryCode: UILabel!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var countryCodeView: UIView!
    @IBOutlet var imgValidInvalid: UIImageView!
    var checkTxtAct = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        txtEmail.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func textField(_ textfield: UITextField, shouldChangeCharactersIn  range: NSRange, replacementString string: String) -> Bool {
        if textfield.text!.count == 0 {
        if textfield == self.txtEmail{
                          if string.isNumericValue == true{
                              print("numbric...........................")
                              self.checkTxtAct = "number"
                              let length = (txtEmail.text?.count)! - range.length + string.count
                              print("lenght",length)
                              if length == 1{
                                  let num : String = self.formatNumber(mobileNo: txtEmail.text!)
                                countryCodeView.isHidden = false
                              }
                              else if length == 0{
                                   countryCodeView.isHidden = true
                                   imgValidInvalid.isHidden = true

                              }
                          }else{
                              let length = (txtEmail.text?.count)! - range.length + string.count
                              print("text...........................")
                              if length == 1{
                                  let num : String = self.formatNumber(mobileNo: txtEmail.text!)
                                  txtEmail.text = "+91- " + num
                              }
                              else if length == 0{
//                                  self.sendOTPBtn.isHidden = false
//                                  self.EmailView.isHidden = true
                              }

                          }

                      }
        }
                      return true
                  }
    
    
    
    func formatNumber(mobileNo: String) -> String{
        var str : NSString = mobileNo as NSString
        str = str.replacingOccurrences(of: "+91- ", with: "") as NSString
        return str as String
    }
    }
 

 
 
