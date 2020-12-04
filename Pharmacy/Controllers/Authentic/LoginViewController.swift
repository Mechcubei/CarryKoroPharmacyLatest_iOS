//
//  ViewController.swift
//  HealthCare
//
//  Created by osx on 03/01/20.
//  Copyright © 2020 osx. All rights reserved.
//

import UIKit
import FlagPhoneNumber
@available(iOS 13.0, *)
class LoginViewController: UIViewController {
    
    //MARK:- Outlets
    // forgot passoword view properties
    @IBOutlet var forgotView: ForgotView!
    @IBOutlet var txtEnterEmailOrNumber2: UITextField!
        
    // forgot otp view properties
    @IBOutlet var OTPView: DesignableView!
    @IBOutlet var firstTextField: UITextField!
    @IBOutlet var secondTextView: UITextField!
    @IBOutlet var thirdTextField: UITextField!
    @IBOutlet var forthTextField: UITextField!
    @IBOutlet var fifthTextField: UITextField!
        
    @IBOutlet var firstView: UIView!
    @IBOutlet var secondView: UIView!
    @IBOutlet var thirdView: UIView!
    @IBOutlet var forthView: UIView!
    @IBOutlet var fifthView: UIView!
    
    // change password view properties
    @IBOutlet var passwordView: DesignableView!
    @IBOutlet var txtNewPassword: UITextField!
    @IBOutlet var txtCOnfirmPassword: UITextField!
        
    // forgot success view properties
    
    @IBOutlet var passwordSuccessView: DesignableView!
    @IBOutlet var hiddenView: UIView!
    
    @IBOutlet var scrollView: UIScrollView!
        
    @IBOutlet var btnVerifyCode: UIButton!
    @IBOutlet var ContentView: UIView!
    @IBOutlet var lblSubmit: UILabel!
    
    
    // login properties
    
    
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtEnterPassword: UITextField!
    
    @IBOutlet var lblCountryCode: UILabel!
    
    @IBOutlet var countryCodeView: UIView!
    @IBOutlet var imgValidInvalid: UIImageView!
      

    // proeprties
    var countryCODE = ""
    var checkTxtAct = ""
    var comingFrom = ""
    var tapGesture = UITapGestureRecognizer()
    var loginVM = LoginViewModel()
    var Id = Int()
    var forgotID = ""
    var timer = Timer()
    
    //MARK:- Life cycle methods
    
    override func viewDidLoad(){
        super.viewDidLoad()
                
        self.navigationController?.isNavigationBarHidden = false
        lblCountryCode.text = "+91"
        countryCODE = "+91"
        self.intitalSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    //MARK:- Class extra functions
        
    func intitalSetup(){
        
        self.hideView()
        
        self.gestureSetup()
        
        self.handlerSelectors()
    }
            
    func hideView(){
        countryCodeView.isHidden = true
        forgotView.isHidden = true
        OTPView.isHidden = true
        passwordView.isHidden = true
        passwordSuccessView.isHidden = true
        hiddenView.isHidden = true
    }
    
    func gestureSetup(){
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.handleTap(sender:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        hiddenView.addGestureRecognizer(tapGesture)
        hiddenView.isUserInteractionEnabled = true
        txtEnterPassword.attributedPlaceholder = NSAttributedString(string: "Enter Password",
                                                                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        txtEmail.delegate = self
        txtEmail.attributedPlaceholder = NSAttributedString(string: "Enter Email/Mobile Here",
                                                            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
        
    @objc func handleTap(sender: UITapGestureRecognizer? = nil) {
        hiddenView.isHidden = true
        forgotView.isHidden = true
        passwordView.isHidden = true
        OTPView.isHidden = true
        passwordSuccessView.isHidden = true
    }
    
    //MARK:-Actions
    
    @IBAction func btnLogin(_ sender: UIButton) {
        
        if txtEmail.text! == "" && self.txtEnterPassword.text == "" {
            
              alert("Alert", message: "Please enter all the fields")
          }
          else if txtEmail.text! == ""   {
              alert("Alert", message: "Please enter the phone number or email")
          }
          else if self.txtEnterPassword.text == "" {
              alert("Alert", message: "Please enter the password")
          }else{
              LoginAPI()
          }
      }
    
    @IBAction func btnForgotPassword(_ sender: UIButton){
        hiddenView.isHidden = false
        forgotView.isHidden = false
        doAnimationAction()
    }
    
    @IBAction func btnForgot(_ sender: UIButton){
          self.ForgotAPI()
      }
        
    @IBAction func passwordChanged(_ sender: UIButton) {
        self.passwordChangedAPI()
    }
    
    
    @IBAction func btnCountryPicker(_ sender: Any) {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CountryViewController") as? CountryViewController {
            
            viewController.callback = { message in
                self.countryCODE = SingletonVariables.sharedInstance.getCode
                self.lblCountryCode.text = "+" + SingletonVariables.sharedInstance.getCode
            }
            
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }
    
    
    
    func formatNumber(mobileNo: String) -> String{
        var str : NSString = mobileNo as NSString
        str = str.replacingOccurrences(of: "+91- ", with: "") as NSString
        return str as String
    }
    
    @IBAction func btnSignUp(_ sender: UIButton) {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FirstViewController") as? FirstViewController {
            if let navigator = self.navigationController {
                navigator.popViewController(animated: true)
            }
        }
    }
    
    
    func doAnimationAction() {
        UIView .transition(with: self.forgotView, duration: 1, options: .transitionCrossDissolve,
                           animations: {
                            self.forgotView.backgroundColor = UIColor.white
        }){finished in
            // self.AlertBox.textColor = UIColor.white
        }
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
        fifthView.layer.cornerRadius = fifthView.frame.size.width/2
        fifthView.clipsToBounds = true
        fifthView.backgroundColor = .white
        
    }
    func handlerSelectors(){
        // Do any additional setup after loading the view, typically from a nib.
        firstTextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        secondTextView.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        thirdTextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        forthTextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        fifthTextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
    }
    

    @IBAction func btnSubmitVerificationCode(_ sender: UIButton) {
        self.verifyOTPAPI()
    }
    
    
    
    //MARK:-----------------------------------------Login API --------------------------------------------
    func LoginAPI(){
        showProgress()
        var params = [String : String]()
        let first = self.txtEmail.text!.replaceCharacters(characters: "- ", toSeparator:"+")
        let code = countryCODE.replacingOccurrences(of: "+" , with: "", options: .literal, range: nil)
        
        if comingFrom == "phone" {
            let trimmedString = String(self.txtEmail.text!.filter { !" ".contains($0)})
            let countryCodeTrim = String(countryCODE.filter { !"+".contains($0) })
            params  = [
                "country_code":countryCodeTrim,
                "phone":  first,
                "password":self.txtEnterPassword.text!,
                "device_type":"ios"
            ]
            
        }else if comingFrom == "email"{
            params = [
                "email": txtEmail.text!,
                "password":self.txtEnterPassword.text!,
                "device_type":"ios"
            ]
        }
        
        loginVM.getLoginData(vc: self, prams: params) { (resp) in
            print(resp.first_name)
            print(resp.last_name)
            UserDefaults.standard.set(resp.token, forKey:Constants.kDeviceID)
            
            DispatchQueue.main.async{
                if resp.message == "Check Your credentials"{
                    self.alert("Alert", message: resp.message)
                }else {
                    self.Id = resp.id
                    UserDefaults.standard.set(resp.id, forKey:Constants.kUserID)
                    self.forgotView.isHidden = false
                    self.hiddenView.isHidden = false
                    
                    self.doAnimationAction()
                    self.notification()
                                        
                    if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarViewController") as? TabBarViewController {
                    if let navigator = self.navigationController {
                        navigator.pushViewController(viewController, animated: true)
                    }
                }
            }
        }
            self.hideProgress()
    }
}

    //MARK:- Api
       func notification(){
           let object = UserDefaults.standard.value(forKey:"fcmToken")
           let parms = [
                    "device_token":object
                ]
           NetworkingService.shared.getData_HeaderParameter(PostName: "add-fcm-token", parameters: parms as [String : Any]) { (response) in
                   print(response)
               }
        }
    
    
    func ForgotAPI(){
        print("Form",comingFrom)
        //let first = self.txtEnterEmailOrNumber2.text!.replaceCharacters(characters: "- ", toSeparator:"+")
        
        let first = self.txtEnterEmailOrNumber2.text!
        let code = countryCODE.replacingOccurrences(of: "+" , with: "", options: .literal, range: nil)
        var params = [String:Any]()
        
        if comingFrom == "phone"
        {
            params  = ["verification_type": comingFrom,
                       "phone": first , "country_code" : code ]
        } else if comingFrom == "email"{
            
            params  = ["verification_type": comingFrom,
                       "email":self.txtEnterEmailOrNumber2.text!]
            
        }
        
        showProgress()
        NetworkingService.shared.getData(PostName: Constants.kForgotPassword, parameters: params ){ (resp) in
            print(resp)
            
            self.hideProgress()
            
            let dic = resp as! NSDictionary
            print(dic)
            if (dic.value(forKey: "has_data") as? Int == 0)
            {
                
                Utilities.ShowAlertView2(title: "Alert",message: dic.value(forKey: "message") as! String, viewController: self)
            }
            else{
                if dic.value(forKey: "message") as! String == "Email is Not Register" {
                    
                    
                    Utilities.ShowAlertView2(title: "Alert",message:"Email is Not Registered", viewController: self)
                    
                    
                }else {
                    
                   // self.lblSubmit.text = (dic.value(forKeyPath: "data.otp") as! String)
                    
                    self.Id = dic.value(forKeyPath: "data.id") as! Int
                    self.hiddenView.isHidden = true
                    self.forgotView.isHidden = true
                    self.OTPView.isHidden = false
                    Utilities.ShowAlertView2(title: "Alert",message:"Code Sent Successfully", viewController: self)
                }
            }
            self.hideProgress()
        }
    }
    
    func verifyOTPAPI(){
        let first  = firstTextField.text! + secondTextView.text!
        let second = thirdTextField.text! + forthTextField.text!
        let third =   fifthTextField.text!
        let OTP = first + second + third
        
        let params : [String:Any] = ["verification_type": comingFrom,
                                     "otp":OTP,"id":Id]
        
            showProgress()
        
        NetworkingService.shared.getData(PostName: Constants.kforgotVerifyOTP, parameters: params ){ (resp) in
            print(resp)
            self.hideProgress()
            let dic = resp as! NSDictionary
            print(dic)
            if (dic.value(forKey: "has_data") as? String == "0")
            {
                self.hiddenView.isHidden = true
                self.OTPView.isHidden = true
                Utilities.ShowAlertView2(title: "Alert",message: dic.value(forKey: "message") as! String, viewController: self)
            }
            else{
                self.forgotID = dic.value(forKeyPath: "data.id") as! String
                self.hiddenView.isHidden = true
                self.OTPView.isHidden = true
                self.passwordView.isHidden = false
                self.doAnimationAction()
            }
            self.hideProgress()
        }
    }
    
    
    func passwordChangedAPI(){
        let params : [String:Any] = ["id": forgotID ,"password": txtNewPassword.text!,
                                     "confirmpassword":txtCOnfirmPassword.text!]
        
        showProgress()
        NetworkingService.shared.getData(PostName: Constants.forgotChangePassword, parameters: params ){ (resp) in
            print(resp)
            self.hideProgress()
            let dic = resp as! NSDictionary
            print(dic)
            if (dic.value(forKey: "statusCode") as? Int ==  401)
            {
                self.hiddenView.isHidden = true
                self.OTPView.isHidden = true
                
                Utilities.ShowAlertView2(title: "Alert",message: dic.value(forKey: "message") as! String, viewController: self)
            } else{
                self.hiddenView.isHidden = true
                self.OTPView.isHidden = true
                self.passwordView.isHidden = true
                self.passwordSuccessView.isHidden = false
                self.hiddenView.isHidden = false
                
                self.hideSuccessViewTimer()
            }
            self.hideProgress()
        }
    }
    
    func hideSuccessViewTimer(){
        self.timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector:#selector(self.hideSuccessView) , userInfo: nil, repeats: false)
    }
    
    @objc func hideSuccessView(){
        self.passwordSuccessView.isHidden = true
        self.hiddenView.isHidden = true
    }
    //MARK:-Texfield methods

    
      func textField(_ textfield: UITextField, shouldChangeCharactersIn  range: NSRange, replacementString string: String) -> Bool {
          if textfield.text!.count == 0 {
              countryCodeView.isHidden = true
              imgValidInvalid.isHidden = true
              self.comingFrom = "phone"
              if textfield == self.txtEmail{
                  if string.isNumericValue == true{
                      print("numbric...........................")
                      self.checkTxtAct = "number"
                      let length = (txtEmail.text?.count)! - range.length + string.count
                      print("lenght",length)
                      if length == 1{
                          let num : String = self.formatNumber(mobileNo: txtEmail.text!)
                          countryCodeView.isHidden = false
                          imgValidInvalid.isHidden = true
                      }
                          
                      else if length == 0{
                          countryCodeView.isHidden = true
                          imgValidInvalid.isHidden = true
                          
                      }
                      else if length == 10 {
                          imgValidInvalid.isHidden = false
                          imgValidInvalid.image = #imageLiteral(resourceName: "verified")
                      }
                      else if length > 10 {
                          imgValidInvalid.isHidden = false
                          imgValidInvalid.image = #imageLiteral(resourceName: "cancel")
                      }
                      else if length < 10 {
                          imgValidInvalid.isHidden = false
                          imgValidInvalid.image = #imageLiteral(resourceName: "cancel")
                      }
                      
                  }else{
                      let length = (txtEmail.text?.count)! - range.length + string.count
                      print("text...........................")
                      print(length)
                      self.comingFrom = "email"
                      if length == 4 {
                          if isValidEmail(self.txtEmail.text ?? "") {
                              imgValidInvalid.image = #imageLiteral(resourceName: "verified")
                          }else {
                              imgValidInvalid.image = #imageLiteral(resourceName: "cancel")
                          }
                      }
                          
                      else if length == 0{
                          countryCodeView.isHidden = true
                          imgValidInvalid.isHidden = true
                      }
                      
                      
                      
                      
                  }
                  
              }
          }
          else {
              if textfield == self.txtEmail{
                  if string.isNumericValue == true{
                      print("numbric...........................")
                      self.checkTxtAct = "number"
                      self.comingFrom = "phone"
                      let length = (txtEmail.text?.count)! - range.length + string.count
                      print("lenght",length)
                      if length == 1{
                          let num : String = self.formatNumber(mobileNo: txtEmail.text!)
                          countryCodeView.isHidden = false
                          imgValidInvalid.isHidden = true
                      }
                      else if length == 0{
                          countryCodeView.isHidden = true
                          imgValidInvalid.isHidden = true
                          
                      }
                      else if length == 10 {
                          imgValidInvalid.isHidden = false
                          imgValidInvalid.image = #imageLiteral(resourceName: "verified")
                      }
                      else if length > 10 {
                          imgValidInvalid.isHidden = false
                          imgValidInvalid.image = #imageLiteral(resourceName: "cancel")
                      }
                      else if length < 10 {
                          imgValidInvalid.isHidden = false
                          imgValidInvalid.image = #imageLiteral(resourceName: "cancel")
                      }
                  }else{
                      imgValidInvalid.isHidden = false
                      self.comingFrom = "email"
                      let length = (txtEmail.text?.count)! - range.length + string.count
                      print("text...........................")
                      print(length)
                      if isValidEmail(self.txtEmail.text ?? "") {
                          imgValidInvalid.image = #imageLiteral(resourceName: "verified")
                      }else {
                          imgValidInvalid.image = #imageLiteral(resourceName: "cancel")
                      }
                      if length == 0{
                          countryCodeView.isHidden = true
                          imgValidInvalid.isHidden = true
                          
                      }
                      
                  }
                  
              }
          }
        
          return true
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
                fifthTextField.becomeFirstResponder()
            case fifthTextField:
                self.fifthTextField.tintColor = .clear
                fifthTextField.textAlignment = .center
                fifthTextField.resignFirstResponder()
            default:
                break
            }
        }
        if  text?.count == 0{
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
            case fifthTextField:
                self.fifthTextField.tintColor = .clear
                fifthView.backgroundColor = .white
                forthTextField.becomeFirstResponder()
            default:
                break
            }
        }
        else{
            
        }
    }
}

@available(iOS 13.0, *)
extension LoginViewController: FPNTextFieldDelegate{
    func fpnDisplayCountryList() {}
    func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool){
        textField.rightViewMode = .always
        textField.rightView = UIImageView(image: isValid ? #imageLiteral(resourceName: "success") : #imageLiteral(resourceName: "error"))
        textField.keyboardType = .namePhonePad
        print(
            isValid,
            textField.getFormattedPhoneNumber(format: .E164) ?? "E164: nil",
            textField.getFormattedPhoneNumber(format: .International) ?? "International: nil",
            textField.getFormattedPhoneNumber(format: .National) ?? "National: nil",
            textField.getFormattedPhoneNumber(format: .RFC3966) ?? "RFC3966: nil",
            textField.getRawPhoneNumber() ?? "Raw: nil"
        )
    }
    
    func fpnDidSelectCountry(name: String, dialCode: String, code: String){
        print(name, dialCode, code)
        countryCODE = dialCode
    }
}
