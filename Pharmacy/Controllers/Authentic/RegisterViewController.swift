//
//  RegisterViewController.swift
//  Pharmacy
//
//  Created by osx on 22/01/20.
//  Copyright © 2020 osx. All rights reserved.
//

import UIKit
import FlagPhoneNumber
import CountryPickerView

@available(iOS 13.0, *)
class RegisterViewController: UIViewController,CountryPickerViewDelegate, CountryPickerViewDataSource {
        
    @IBOutlet var hiddenView: UIView!
    @IBOutlet var AlertBox: DesignableView!
    @IBOutlet var txtname: UITextField!
    @IBOutlet var txtPassword: UITextField!
    @IBOutlet var txtConfirmPassword: UITextField!
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
    @IBOutlet var lblCountryCode: UILabel!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var countryCodeView: CountryPickerView!
    @IBOutlet var imgValidInvalid: UIImageView!
    var registerVal = ""
    var comingFrom = ""
    var checkTxtAct = ""
    var tapGesture = UITapGestureRecognizer()
    var listController: FPNCountryListViewController = FPNCountryListViewController(style: .grouped)
    var countryCODE = ""
    var regVM = RegisterViewModel()
    let validityType: String.validityType = .email
    var Id  = Int()
    var OTP = ""
    var cpv = CountryPickerView()
    
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var btnResend: UIButton!
    var isRepeat = true
    var counter = 60
    var timer = Timer()
    
    //MARK:- Life cycle methods
    override func viewDidLoad(){
        super.viewDidLoad()
        
        self.initialSetup()
        self.countryPickerSetup()
    }
    
    //MARK:- Extra class functions
    //MARK:- Otp resend methods
    func checkOtpStatus(){
        DispatchQueue.main.async {
            self.timer =   Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector( self.updateTime), userInfo: nil, repeats: true)
        }
    }
    
    @objc func updateTime() {
        if counter > 0 {
            counter -= 1
            self.timerLabel.text = "OTP Valid for: 0:\(counter)"
            self.btnResend.isHidden = true
        }else if counter == 0 {
            
            btnResend.isHidden = false
            counter = 60
            timer.invalidate()
            //self.expireOTP()
        }
    }
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
             print(country.phoneCode)
             countryCODE = country.phoneCode
    }
    
    
    //MARK:- Class extra functions
    func countryPickerSetup(){
        
        
        self.countryCodeView.delegate = self
        DispatchQueue.main.async {
            let country = self.cpv.selectedCountry.phoneCode
            print(country)
            self.countryCODE = country
            self.countryCodeView.showCountryCodeInView = false
            self.countryCodeView.textColor = .white
            self.countryCodeView.font = UIFont(name: "Roboto-Bold", size: 14.0)!
        }
    }
    
    func initialSetup(){
        self.viewsHide()
        self.tapGestureSetup()
        self.texfieldPlaceholder()
        self.handlerSelectors()
    }
    
    func viewsHide(){
        self.hiddenView.isHidden = true
        self.AlertBox.isHidden = true
        self.countryCodeView.isHidden = true
        
        lblCountryCode.text = "+91"
        countryCODE = lblCountryCode.text!
        
        txtEmail.delegate = self
    }
    
    func tapGestureSetup(){
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.handleTap(sender:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        hiddenView.addGestureRecognizer(tapGesture)
        hiddenView.isUserInteractionEnabled = true
    }
    
    
    func texfieldPlaceholder(){
        txtname.attributedPlaceholder = NSAttributedString(string:"Enter Your Name", attributes:[NSAttributedString.Key.foregroundColor: UIColor.white])
        txtEmail.attributedPlaceholder = NSAttributedString(string:"Enter Your Email or Phone Number", attributes:[NSAttributedString.Key.foregroundColor: UIColor.white])
        txtPassword.attributedPlaceholder = NSAttributedString(string:"Enter Your Password", attributes:[NSAttributedString.Key.foregroundColor: UIColor.white])
        txtConfirmPassword.attributedPlaceholder = NSAttributedString(string:"Confirm Password", attributes:[NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
    //MARK:- Actions
        
    @IBAction func btnAccountCreate(_ sender: Any) {
        self.validations()
    }
    
    @IBAction func btnSignIn(_ sender: Any) {
           self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func x(_ sender: UIButton) {
        let first  = firstTextField.text! + secondTextView.text!
        let second = thirdTextField.text! + forthTextField.text!
        let third =   fifthTextField.text!
        
        OTP = first + second + third
        
        // aman
        OTP == "" ?   alert("Alert", message: "Please Enter OTP")   : verifyOTPAPI()
                
       // self.verifyOTPAPI()
    }
    
    
    
    @IBAction func btnCountryPicker(_ sender: Any) {
        
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CountryViewController") as? CountryViewController {
 
            viewController.callback = { message in
                self.countryCODE = SingletonVariables.sharedInstance.getCode
                self.lblCountryCode.text = "+" +  SingletonVariables.sharedInstance.getCode
                
            }
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
        
    }
    
    private func getCustomTextFieldInputAccessoryView(with items: [UIBarButtonItem]) -> UIToolbar {
        let toolbar: UIToolbar = UIToolbar()
        toolbar.barStyle = UIBarStyle.default
        toolbar.items = items
        toolbar.sizeToFit()
        return toolbar
    }
    
    @objc func dismissCountries() {
        listController.dismiss(animated: true, completion: nil)
    }
    @objc func handleTap(sender: UITapGestureRecognizer? = nil) {
        hiddenView.isHidden = true
        AlertBox.isHidden = true
    }
        
    func doAnimationAction() {
        UIView .transition(with: self.AlertBox, duration: 1, options: .transitionCrossDissolve,
                           animations: {
                            self.AlertBox.backgroundColor = UIColor.white
        }){finished in
            // self.AlertBox.textColor = UIColor.white
        }
    }
    
    func validations(){
        if self.txtname.text == "" && self.txtEmail.text == "" && self.txtPassword.text == "" && self.txtConfirmPassword.text == ""  {
            Utilities.ShowAlertView2(title: "Alert", message: "Please enter all fields", viewController: self)
        }
        else if txtname.text == "" {
            Utilities.ShowAlertView2(title: "Alert", message: "Please enter your pharmacy name", viewController: self)
        }
        else if self.txtEmail.text! == "" {
            Utilities.ShowAlertView2(title: "Alert", message: "Please enter email or password", viewController: self)
        }
        else if self.txtPassword.text == "" {
            Utilities.ShowAlertView2(title: "Alert", message: "Please enter password", viewController: self)
        }
        else if self.txtPassword.text?.count ?? 1 < 6 {
            Utilities.ShowAlertView2(title: "Alert", message: "The password must be at least 6 characters.", viewController: self)
        }
        else if txtConfirmPassword.text == "" {
            Utilities.ShowAlertView2(title: "Alert", message: "Please enter your confirm password", viewController: self)
        }
        else if txtConfirmPassword.text != self.txtPassword.text {
            Utilities.ShowAlertView2(title: "Alert", message: "Mismatch password", viewController: self)
        } else {
            
            self.registerAPI()
        }
    }
    
    func formatNumber(mobileNo: String) -> String{
        var str : NSString = mobileNo as NSString
        str = str.replacingOccurrences(of: "+91- ", with: "") as NSString
        return str as String
    }

    func validateEmail(enteredEmail:String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
    }
            
    //MARK:-----------------------------------------Register API --------------------------------------------
    func registerAPI(){
        showProgress()
        var params = [String : String]()
        let first = self.txtEmail.text!.replaceCharacters(characters: "- ", toSeparator:"+")
        let code = countryCODE.replacingOccurrences(of: "+" , with: "", options: .literal, range: nil)
        if comingFrom == "phone" {
            params  = ["country_code":code,
                       "phone":first,
                       "pharmacy_name":self.txtname.text!,
                       "password":self.txtPassword.text!,
                       "confirmpassword":self.txtConfirmPassword.text!,
                       "verification_type":"phone"

            ]
        }else if comingFrom == "email"{
            params = ["email": txtEmail.text!,
                      "pharmacy_name":self.txtname.text!,
                      "password":self.txtPassword.text!,
                      "confirmpassword":self.txtConfirmPassword.text!,
                      "verification_type":"email"

            ]
        }
        
        print(params)
        regVM.getRegData(vc: self, prams: params) { (resp) in
            print(resp)
            DispatchQueue.main.async{

                if resp.message == "The confirmpassword and password must match."{
                    self.alert("Alert", message: resp.message)
                }
                if resp.message == "The email must be a valid email address."{
                    self.alert("Alert", message: resp.message)
                }
                if resp.message == "The email has already been taken."{
                    self.alert("Alert", message: resp.message)
                    
                } else{
                    //self.Id = resp.id
                    self.AlertBox.isHidden = false
                    self.hiddenView.isHidden = false
                    self.clearData()
                   
                    self.view.endEditing(true)
                    self.doAnimationAction()
                    self.checkOtpStatus()

                }
                self.hideProgress()
            }
        }
    }
    
    func clearData(){
        firstTextField.text = ""
        secondTextView.text = ""
        thirdTextField.text = ""
        forthTextField.text = ""
        fifthTextField.text = ""
    }
        
    func verifyOTPAPI(){

        let first = self.txtEmail.text!.replaceCharacters(characters: "- ", toSeparator:"+")
        let code = countryCODE.replacingOccurrences(of: "+" , with: "", options: .literal, range: nil)
        
        var params = [String : String]()
        if comingFrom == "phone" {
            params  = [
                        "country_code":code,
                       "phone":first,
                       "pharmacy_name":self.txtname.text!,
                       "password":self.txtPassword.text!,
                       "confirmpassword":self.txtConfirmPassword.text!,
                       "otp":OTP,
                       "verification_type":"phone"
                      ]
        }else if comingFrom == "email"{
            params = ["email": txtEmail.text!,
                      "pharmacy_name":self.txtname.text!,
                      "password":self.txtPassword.text!,
                      "confirmpassword":self.txtConfirmPassword.text!,
                     "otp":OTP,
                     "verification_type":"email"
            ]
        }
        
        NetworkingService.shared.getData(PostName: Constants.KverifyRegisterApi2, parameters: params ){ (resp) in
            print(resp)
            
            let dic = resp as! NSDictionary
            print(dic)
            
            guard dic["statusCode"] as! Int == 200 else {
//                self.hiddenView.isHidden = true
//                self.AlertBox.isHidden = true
                Utilities.ShowAlertView2(title: "Alert",message: dic.value(forKey: "message") as! String, viewController: self)
                return
            }
            
                let data =  dic["data"] as! [String:Any]
                let token =  data["token"] as! String
                UserDefaults.standard.set(token, forKey:Constants.kDeviceID)
               // UserDefaults.standard.set(resp.id, forKey: Constants.kUserID)
                self.hiddenView.isHidden = true
                self.AlertBox.isHidden = true
                self.doAnimationAction()
                if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PharmacyRegisterVC") as? PharmacyRegisterVC {
        
                    viewController.type  = self.comingFrom
                    
                    if let navigator = self.navigationController{
                        navigator.pushViewController(viewController, animated: true)
                    }
                }
           // }
            self.hideProgress()
        }
    }
    func setParams() -> [String:String]{
        let code = countryCODE.replacingOccurrences(of: "+" , with: "", options: .literal, range: nil)

        let phoneparams : [String:String] = ["phone_number": txtEmail.text!, "country_code":code, "user_role":"pharmacy","verification_type":"phone"]
        let emailparams :[String:String] = ["email":txtEmail.text!, "verification_type":"email", "user_role":"pharmacy"]
        return  comingFrom == "email"  ? emailparams  : phoneparams
     }
    
    func expireOTP(){
        let params = setParams()
        print(params)
        NetworkingService.shared.getData(PostName:Constants.expireotp, parameters: params) { (response) in
            print(response)
            let dic = response as! NSDictionary
            print(dic)
            
            let hasdata = dic["has_data"] as? Int ?? 0
            print(hasdata)
            
            if hasdata == 0
            {
                print("Something")
                
                Utilities.ShowAlertView2(title: "Alert",message: dic.value(forKey: "message") as! String, viewController: self)
            }
        }
    }
    
    @IBAction func btnResend(_ sender: Any) {
       // checkOtpStatus()
        registerAPI()
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
}
@available(iOS 13.0, *)
extension RegisterViewController: FPNTextFieldDelegate{
    func fpnDisplayCountryList() {}
    func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {
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
    
    func fpnDidSelectCountry(name: String, dialCode: String, code: String) {
        print(name, dialCode, code)
        countryCODE = dialCode
    }
}


@available(iOS 13.0, *)

//MARK:- Textfield Delegate methods

extension RegisterViewController{
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
    
    
      func textField(_ textfield: UITextField, shouldChangeCharactersIn  range: NSRange, replacementString string: String) -> Bool {
          if textfield.text!.count == 0 {
              countryCodeView.isHidden = true
              imgValidInvalid.isHidden = true
              if textfield == self.txtEmail{
                  self.comingFrom = "phone"
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
                      let length = (txtEmail.text?.count)! - range.length + string.count
                      print("lenght",length)
                      self.comingFrom = "phone"
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
    
}
