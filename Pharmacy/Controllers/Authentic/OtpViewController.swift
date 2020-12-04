//
//  OtpViewController.swift
//  HealthCare
//
//  Created by osx on 03/01/20.
//  Copyright © 2020 osx. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class OtpViewController: UIViewController {

   
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
    @IBOutlet var sixthView: UIView!
    @IBOutlet var lineFirst: UIView!
    @IBOutlet var lineSecond: UIView!
    @IBOutlet var lineThird: UIView!
    @IBOutlet var lineForth: UIView!
    @IBOutlet var lineFifth: UIView!
    @IBOutlet var lineSixth: UIView!
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var arrowView: DesignableView!
    @IBOutlet var btnResend: UIButton!
    @IBOutlet var imgResend: UIImageView!
    @IBOutlet var lblInvalid: UILabel!
    
    var params = [String:Any]()
    var PhoneNumber = ""
    var timer = Timer()
    var totalSecond = 60
    var enteredOtp = ""
    var sessionId = ""
    var comingFrom = ""
    var otp = ""
        
        override func viewDidLoad() {
            super.viewDidLoad()
           // imgResend.isHidden = true
           // btnResend.isHidden = true
           // OTPSendAPI()
           // handleCornerRadius()
           // timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
           handlerSelectors()
        }
    
    @objc func updateTime() {
        print(timeFormatted(totalSecond))
        if totalSecond != 0{
            totalSecond -= 1
            timerLabel.text = "Auto Verify Time(00:" + "\(totalSecond)" + ")"
        } else {
            endTimer()
        }
    }
    
    func endTimer() {
        timer.invalidate()
    }
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        timerLabel.text = "Auto Verify Time(00:" + "\(seconds)" + ")"
        if seconds == 0 {
        imgResend.isHidden = false
        btnResend.isHidden = false
        lineFirst.backgroundColor = .green
        lineSecond.backgroundColor = .green
        lineThird.backgroundColor = .green
        lineForth.backgroundColor = .green
       // lineFifth.backgroundColor = .green
       // lineSixth.backgroundColor = .green
        //arrowView.backgroundColor = .green
        }
        return String(format: "0:%02d", seconds)
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
    
    
    func handlerSelectors(){
        // Do any additional setup after loading the view, typically from a nib.
        firstTextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        secondTextView.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        thirdTextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        forthTextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        
    }
        
    override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
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
    
 
    @IBAction func submitOTP(_ sender: Any) {
        verifyOTPAPI()
        
    }
    func verifyOTPAPI(){
        let first  = firstTextField.text! + secondTextView.text!
        let second = thirdTextField.text! + forthTextField.text!
        let third =   fifthTextField.text!
        
        let OTP = first + second + third
        
        let params : [String:Any] =
        [
            "verification_type": comingFrom,
            "otp":OTP
        ]
        
        NetworkingService.shared.getData_HeaderParameter(PostName: Constants.kVerifyOtp, parameters: params as! [String : Any]){ (resp) in
            print(resp)
            let dic = resp as! NSDictionary
            print(dic)
            if (dic.value(forKey: "has_data") as? String == "0")
            {
                Utilities.ShowAlertView2(title: "Alert",message: dic.value(forKey: "message") as! String, viewController: self)
            }else{
            
                if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarViewController") as? TabBarViewController {
                    if let navigator = self.navigationController{
                        navigator.pushViewController(viewController, animated: true)
                    }
                }
            }
            self.hideProgress()
        }
    }
    
//    func OTPSendAPI(){
//        showProgress()
//        params = ["":""]
//        NetworkingService.shared.getDataSMS(PostName:  "+" + PhoneNumber + "/AUTOGEN", parameters: params as! [String : String], completion: { (resp) in
//            print(resp)
//            let dic = resp as! NSDictionary
//            print(dic)
//            if (dic.value(forKey: "has_data") as? String == "0")
//            {
//                self.hideProgress()
//                Utilities.ShowAlertView2(title: "Alert",message: dic.value(forKey: "message") as! String, viewController: self)
//            }
//            else{
//                self.hideProgress()
//                self.sessionId = dic.value(forKey: "Details") as! String
//            }
//        })
//        }
//
//    func verifyOTP(){
//        let otp = firstTextField.text! + secondTextView.text! + thirdTextField.text!
//        let otp2 = forthTextField.text! + fifthTextField.text! + sixthTextField.text!
//        enteredOtp = otp + otp2
//        showProgress()
//        params = ["":""]
//        NetworkingService.shared.getDataSMS(PostName: "VERIFY/" + self.sessionId + "/" + enteredOtp, parameters: params as! [String : String], completion: { (resp) in
//            print(resp)
//            let dic = resp as! NSDictionary
//            print(dic)
//            if (dic.value(forKey: "has_data") as? String == "0")
//            {
//                self.hideProgress()
//                self.lblInvalid.text = "Invalid Otp,Please Verify!"
//            }
//            else{
//                self.hideProgress()
//                self.lblInvalid.text = ""
//                self.segue()
//            }
//        })
//    }
//
//    func segueHome(){
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
    
    }


