//
//  ForgotView.swift
//  Pharmacy
//
//  Created by osx on 29/01/20.
//  Copyright © 2020 osx. All rights reserved.
//

import UIKit

class ForgotView: UIView {
   
    @IBOutlet var contentView: DesignableView!
    @IBOutlet var firstTextField: UITextField!
        @IBOutlet var secondTextView: UITextField!
        @IBOutlet var thirdTextField: UITextField!
        @IBOutlet var forthTextField: UITextField!
        @IBOutlet var fifthTextField: UITextField!
        @IBOutlet var sixthTextField: UITextField!
        @IBOutlet var firstView: UIView!
        @IBOutlet var secondView: UIView!
        @IBOutlet var thirdView: UIView!
        @IBOutlet var forthView: UIView!
        @IBOutlet var fifthView: UIView!
     
        
        var params = [String:Any]()
        var PhoneNumber = ""
        var timer = Timer()
        var totalSecond = 60
        var enteredOtp = ""
        var sessionId = ""
            
        override init(frame: CGRect) {
            super.init(frame: frame)
            handlerSelectors()
        }
    
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
             handlerSelectors()
        }
    
      
        func endTimer() {
            timer.invalidate()
        }
        
  
        
      func handleCornerRadius(){
            firstView.layer.cornerRadius = firstView.frame.size.width/2
            firstView.clipsToBounds = true
            firstView.backgroundColor = .white
            secondView.layer.cornerRadius = secondView.frame.size.width/2
            secondView.clipsToBounds = true
            secondView.backgroundColor = .white
            thirdView.layer.cornerRadius = secondView.frame.size.width/2
            thirdView.clipsToBounds = true
            thirdView.backgroundColor = .white
            forthView.layer.cornerRadius = forthView.frame.size.width/2
            forthView.clipsToBounds = true
            forthView.backgroundColor = .white
        
        }
        
        @IBAction func btnVerify(_ sender: Any) {
          //  self.verifyOTP()
        }
        
        @IBAction func btnResend(_ sender: Any) {
           // OTPSendAPI()
        }
        
        
      private  func handlerSelectors(){
        Bundle.main.loadNibNamed("ForgotView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
            // Do any additional setup after loading the view, typically from a nib.
            firstTextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
            secondTextView.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
            thirdTextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
            forthTextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
            
        }
             
        @objc func textFieldDidChange(textField: UITextField){
            let text = textField.text
            if  text?.count == 1 {
                switch textField{
                case firstTextField:
                    self.firstTextField.tintColor = .clear
                    firstTextField.textAlignment = .center
                    secondTextView.becomeFirstResponder()
                case secondTextView:
                    self.secondTextView.tintColor = .clear
                     secondTextView.textAlignment = .center
                    thirdTextField.becomeFirstResponder()
                case thirdTextField:
                    self.thirdTextField.tintColor = .clear
                    thirdTextField.textAlignment = .center
                    forthTextField.becomeFirstResponder()
                case forthTextField:
                    self.forthTextField.tintColor = .clear
                    forthTextField.textAlignment = .center
                    forthTextField.resignFirstResponder()
                
                default:
                    break
                }
            }
            if  text?.count == 0 {
                switch textField{
                case firstTextField:
                    self.firstTextField.tintColor = .clear
                    firstView.backgroundColor = .white
                    firstTextField.becomeFirstResponder()
                case secondTextView:
                    self.secondTextView.tintColor = .clear
                    secondView.backgroundColor = .white
                    firstTextField.becomeFirstResponder()
                case thirdTextField:
                    self.thirdTextField.tintColor = .clear
                    secondTextView.becomeFirstResponder()
                    thirdView.backgroundColor = .white
                case forthTextField:
                    self.forthTextField.tintColor = .clear
                    forthView.backgroundColor = .white
                    thirdTextField.becomeFirstResponder()
                default:
                    break
                }
            }
            else{
                
            }
        }
        
 


}
