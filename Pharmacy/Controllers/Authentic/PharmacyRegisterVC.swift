
//  PharmacyRegisterVC.swift
//  Pharmacy
//  Created by osx on 28/01/20.
//  Copyright © 2020 osx. All rights reserved.

import UIKit
import FlagPhoneNumber
import AVFoundation
import libPhoneNumber_iOS
import CountryPickerView

@available(iOS 13.0, *)
class PharmacyRegisterVC: UIViewController , UIImagePickerControllerDelegate  ,UINavigationControllerDelegate ,URLSessionDataDelegate,URLSessionTaskDelegate,URLSessionDelegate , CountryPickerViewDelegate, CountryPickerViewDataSource  {
    
    //MARK:- Outlets
    @IBOutlet var imgPhone: UIImageView!
    @IBOutlet var imgValidInvalid: UIImageView!
    @IBOutlet var txtLocation: UITextField!
    @IBOutlet var hiddenView: UIView!
    @IBOutlet var AlertBox: DesignableView!
    @IBOutlet var txtname: UITextField!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtPassword: UITextField!
    @IBOutlet var txtConfirmPassword: UITextField!
    @IBOutlet var txtOriginalEmail: UITextField!
    @IBOutlet var txtDescription: UITextField!
    @IBOutlet var txtRegNo: UITextField!
    @IBOutlet var txtNumber: FPNTextField!
    @IBOutlet var btnLogo: DesignableButton!
    @IBOutlet var btnBanner: DesignableButton!
    @IBOutlet var btnTrade: DesignableButton!
    @IBOutlet var btnCertificate: DesignableButton!
    @IBOutlet var countryPicker: CountryPickerView!
    
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
    
    let formatter = NBAsYouTypeFormatter(regionCode: "IN")
    let phoneUtil = NBPhoneNumberUtil()
    var imgBanner =  UIImage()
    var imgLogo = UIImage()
    var imgCertificate =  UIImage()
    var imgTrade =  UIImage()
    var comingFrom = ""
    var Lat = ""
    var Long = ""
    var Address = ""
    var profileVM = ProfileViewModel()
    var Number = ""
    var regionCode = ""
    var imagePicker:UIImagePickerController?=UIImagePickerController()
    var countryCODE = ""
    var countryCode = ""
    var cpv = CountryPickerView()
    var type:String?
    var phoneStatus:String!
    var OTP = ""
    
    
    //MARK:- Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if type == "phone" {
            self.txtNumber.isUserInteractionEnabled = false
            self.txtEmail.isUserInteractionEnabled = true
        } else {
            self.txtEmail.isUserInteractionEnabled = false
            self.txtNumber.isUserInteractionEnabled = true
        }
        
        self.txtNumber.placeholder = "Enter Phone Number"
        let country = cpv.selectedCountry.phoneCode
        regionCode = cpv.selectedCountry.code
        countryCODE = country
        countryPicker.showCountryCodeInView = false
        countryPicker.delegate = self
        countryPicker.dataSource = self
        self.txtNumber.delegate = self
        countryPicker.textColor = .gray
        countryPicker.font = UIFont(name: "Roboto-Bold", size: 14.0)!
        self.hiddenView.isHidden = true
        self.AlertBox.isHidden = true
        self.txtEmail.delegate = self
        
        self.txtname.isUserInteractionEnabled = false
        self.GetProfile()
        self.handlerSelectors()
        // Do any additional setup after loading the view.
    }
    
    //MARK:- Actions
    @IBAction func uploadCertificate(_ sender: UIButton) {
        requestCameraPermission()
        cameraAuthorization()
        comingFrom = "certificate"
    }
    
    @IBAction func uploadLogo(_ sender: UIButton) {
        requestCameraPermission()
        cameraAuthorization()
        comingFrom = "logo"
    }
    override func viewWillAppear(_ animated: Bool) {
        self.txtLocation.text = self.Address
    }
    
    @IBAction func uploadBanner(_ sender: UIButton) {
        requestCameraPermission()
        cameraAuthorization()
        comingFrom = "banner"
    }
    
    @IBAction func btnTradeLicence(_ sender: Any) {
        requestCameraPermission()
        cameraAuthorization()
        comingFrom = "trade"
    }
    
    @IBAction func btnSave(_ sender: UIButton) {
        validations()
    }
    @IBAction func btnLocation(_ sender: UIButton){
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LocationViewController") as? LocationViewController {
            viewController.callback = { message in
                self.Lat = (SingletonVariables.sharedInstance.lat)
                self.Long = (SingletonVariables.sharedInstance.long)
                self.Address = (SingletonVariables.sharedInstance.address)
                self.txtLocation.text = self.Address
                //Do what you want in here!
            }
            if let navigator = self.navigationController{
                //                            viewController.comingFrom = self.comingFrom
                //                            viewController.otp  = otp
                navigator.pushViewController(viewController, animated: true)
            }
        }
        
    }
    
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        print(country.phoneCode)
        countryCODE = country.phoneCode
        regionCode = cpv.selectedCountry.code
    }
    
    func handlerSelectors(){
        // Do any additional setup after loading the view, typically from a nib.
        firstTextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        secondTextView.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        thirdTextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        forthTextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        fifthTextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        
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
    
    
    func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video, completionHandler: {accessGranted in
            guard accessGranted == true else { return }
            //self.presentCamera()
        })
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        imgValidInvalid.isHidden = false
        print(txtNumber.text!.count)
        if txtNumber.text!.count > 9 {
            imgPhone.image = #imageLiteral(resourceName: "cancel")
            return true
            
        }else if  txtNumber.text!.count == 9{
            imgPhone.image = #imageLiteral(resourceName: "verified")
            return true
        }else {
            if  txtNumber.text!.count == 10{
                imgPhone.image = #imageLiteral(resourceName: "verified")
            }
            if  txtNumber.text!.count == 11{
                imgPhone.image = #imageLiteral(resourceName: "verified")
            }
            if  txtNumber.text!.count == 12{
                imgPhone.image = #imageLiteral(resourceName: "verified")
            }
            if  txtNumber.text!.count == 13{
                imgPhone.image = #imageLiteral(resourceName: "verified")
            }
            imgPhone.image = #imageLiteral(resourceName: "cancel")
            
            return true
        }
    }
    //
    //    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    //
    //        if textField.text == txtNumber.text {
    //            if txtNumber.text != "" {
    //                imgValidInvalid.isHidden = true
    //                var updatedString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
    //                print(updatedString)
    //                if updatedString?.count ?? 1 > 4 {
    //                    imgPhone.isHidden = false
    //                    let phoneNumber: NBPhoneNumber = try! phoneUtil.parse(updatedString, defaultRegion: regionCode)
    //                    print(phoneUtil.isValidNumber(forRegion: phoneNumber, regionCode: regionCode))
    //                    if (phoneUtil.isValidNumber(forRegion: phoneNumber, regionCode: regionCode)) == true {
    //                        imgPhone.image =  #imageLiteral(resourceName: "verified")
    //                    }else{
    //                        imgPhone.image = #imageLiteral(resourceName: "cancel")
    //                    }
    //                }else {
    //                    imgPhone.isHidden = true
    //                }
    //            }
    //        }
    //        else {
    //            let length = (txtEmail.text?.count)! - range.length + string.count
    //            if length > 0 {
    //                self.imgValidInvalid.isHidden = false
    //                if isValidEmail(self.txtEmail.text ?? "") {
    //                    imgValidInvalid.image = #imageLiteral(resourceName: "verified")
    //                }else {
    //                    imgValidInvalid.image = #imageLiteral(resourceName: "cancel")
    //                }
    //            }else {
    //                self.imgValidInvalid.isHidden = true
    //            }
    //        }
    //        return true
    //    }
    
    func validations(){
        if self.txtname.text == "" && self.txtEmail.text == "" && self.txtLocation.text == "" && self.txtNumber.text == ""  && self.txtRegNo.text == "" && self.txtDescription.text == "" {
            Utilities.ShowAlertView2(title: "Alert", message: "Please enter all fields", viewController: self)
        }
        else if txtname.text == "" {
            Utilities.ShowAlertView2(title: "Alert", message: "Please enter your pharmacy name", viewController: self)
        }
        //        else if self.txtEmail.text == "" {
        //            Utilities.ShowAlertView2(title: "Alert", message: "Please enter email", viewController: self)
        //        }
        else if txtLocation.text == "" {
            Utilities.ShowAlertView2(title: "Alert", message: "Please enter Location", viewController: self)
        }
        else if txtNumber.text == "" {
            Utilities.ShowAlertView2(title: "Alert", message: "Please enter your Phone Number", viewController: self)
        }
        else if txtRegNo.text == "" {
            Utilities.ShowAlertView2(title: "Alert", message: "Please enter reg No.", viewController: self)
        }else if imgLogo.cgImage == nil {
            Utilities.ShowAlertView2(title: "Alert", message: "Please upload Logo", viewController: self)
        }
        else if imgBanner.cgImage == nil {
            Utilities.ShowAlertView2(title: "Alert", message: "Please upload Banner", viewController: self)
        }
        else if imgCertificate.cgImage == nil {
            Utilities.ShowAlertView2(title: "Alert", message: "Please upload Drug Licence", viewController: self)
            
        } else if imgTrade.cgImage == nil {
            Utilities.ShowAlertView2(title: "Alert", message: "Please upload Trade Licence", viewController: self)
        } else {
            phoneStatus == "0" ?  self.sendPhoneOTPAPI() :    self.AddDetails()
        }
    }
    
    func cameraAuthorization(){
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch cameraAuthorizationStatus {
        case .notDetermined: requestCameraPermission()
        case .authorized: CameraActionSheet()
        case .restricted, .denied: alertCameraAccessNeeded()
        @unknown default: break
        }
    }
    
    func alertCameraAccessNeeded() {
        let settingsAppURL = URL(string: UIApplication.openSettingsURLString)!
        let alert = UIAlertController(
            title: "Need Camera Access",
            message: "Camera access is required to make full use of this app.",
            preferredStyle: UIAlertController.Style.alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Allow Camera", style: .cancel, handler: { (alert) -> Void in
            UIApplication.shared.open(settingsAppURL, options: [:], completionHandler: nil)
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: Action Sheet to open camera and gallery
    func CameraActionSheet(){
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let TakeAction = UIAlertAction(title: "Take Photo", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.opencamera()
        })
        let saveAction = UIAlertAction(title: "Choose Photo ", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.openGallery()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        // Add the actions
        imagePicker?.delegate = (self )
        optionMenu.addAction(TakeAction)
        optionMenu.addAction(saveAction)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    
    //MARK: Function to open Camera
    func opencamera()
    {
        if UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera){
            imagePicker!.delegate = self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
            imagePicker!.sourceType = UIImagePickerController.SourceType.camera
            imagePicker!.allowsEditing = true
            imagePicker!.cameraCaptureMode = UIImagePickerController.CameraCaptureMode.photo;
            self.present(imagePicker!, animated: true, completion: nil)
        }
        else
        {
            print("Sorry cant take picture")
            let alert = UIAlertController(title: "Warning", message:"Camera is not working.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    //MARK: Function to open Gallery
    func openGallery()
    {
        if UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            imagePicker!.delegate = self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
            imagePicker!.sourceType = UIImagePickerController.SourceType.photoLibrary;
            imagePicker!.allowsEditing = true
            self.present(imagePicker!, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print(info as Any);
        if comingFrom == "logo"{
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
                imgLogo = (info[UIImagePickerController.InfoKey.editedImage] as! UIImage)
                btnLogo.backgroundColor = .systemGreen
                btnLogo.setTitle("File Added", for: .normal)
                
            }else{
                print("Something went wrong")
            }
        }
        else if comingFrom == "banner"{
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
                imgBanner = (info[UIImagePickerController.InfoKey.editedImage] as! UIImage)
                btnBanner.backgroundColor = .systemGreen
                btnBanner.setTitle("File Added", for: .normal)
                
            }else{
                print("Something went wrong")
            }
        }
        else if comingFrom == "certificate"{
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
                imgCertificate = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
                btnCertificate.backgroundColor = .systemGreen
                btnCertificate.setTitle("File Added", for: .normal)
            }else{
                print("Something went wrong")
            }
        }
        
        else if comingFrom == "trade" {
            
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
                imgTrade = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
                btnTrade.backgroundColor = .systemGreen
                btnTrade.setTitle("File Added", for: .normal)
            }else{
                print("Something went wrong")
            }
            
        }
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func GetProfile(){
        let params : [String : String] = ["user_type":"pharmacy"]
        profileVM.getProfileData(vc: self, prams: params) { (resp) in
            print(resp)
            let banner = resp.banner
            UserDefaults.standard.set(resp.userId, forKey:Constants.kUserID)
            self.txtname.text = resp.first_name + resp.last_name
            self.txtEmail.text = resp.email
            self.phoneStatus = resp.phoneStatus
            
            self.imgPhone.isHidden = self.phoneStatus == "1" ? false : true
            self.imgPhone.image = self.phoneStatus == "1" ? #imageLiteral(resourceName: "completed")  :  #imageLiteral(resourceName: "cancel")
//            self..isHidden = self.phoneStatus == "1" ? false : true
//            self.imgPhone.image = self.phoneStatus == "1" ? #imageLiteral(resourceName: "completed")  :  #imageLiteral(resourceName: "cancel")
//            
            if resp.Phone != 0 {
                self.txtNumber.text = "\(resp.Phone)"
            }
        }
    }
    
    @IBAction func x(_ sender: UIButton) {
        let first  = firstTextField.text! + secondTextView.text!
        let second = thirdTextField.text! + forthTextField.text!
        let third =   fifthTextField.text!
        OTP = first + second + third
        // aman
        OTP == "" ? alert("Alert", message: "Please Enter OTP") : verifyOTPAPI()
        // self.verifyOTPAPI()
    }
    
    func sendPhoneOTPAPI(){
        let code = countryCODE.replacingOccurrences(of: "+" , with: "", options: .literal, range: nil)
        var params = [String : String]()
        params  = [
            "country_code":code,
            "phone":txtNumber.text!,
        ]
        print(params)
        NetworkingService.shared.getData(PostName: Constants.otp_send_phar_phone, parameters: params ){ (resp) in
            print(resp)
            let dic = resp as! NSDictionary
            print(dic)
            guard dic["statusCode"] as! Int == 200 else {
                Utilities.ShowAlertView2(title: "Alert",message: dic.value(forKey: "message") as! String, viewController: self)
                return
            }
            
            self.hiddenView.isHidden = false
            self.AlertBox.isHidden = false
            self.doAnimationAction()
            self.hideProgress()
        }
    }
    
    func verifyOTPAPI(){
        let code = countryCODE.replacingOccurrences(of: "+" , with: "", options: .literal, range: nil)
        var params = [String : String]()
        params  = [
            "country_code":code,
            "phone":txtNumber.text!,
            "otp":OTP,
            "email":txtEmail.text!
          ]
        
        NetworkingService.shared.getData(PostName: Constants.otpverify_phar_phone, parameters: params){ (resp) in
            print(resp)
            
            let dic = resp as! NSDictionary
            print(dic)
            guard dic["statusCode"] as! Int == 200 else {
                Utilities.ShowAlertView2(title: "Alert",message: dic.value(forKey: "message") as! String, viewController: self)
                return
            }
            
            let data =  dic["data"] as! [String:Any]
            let token =  data["token"] as! String
            
            UserDefaults.standard.set(token, forKey:Constants.kDeviceID)
            self.hiddenView.isHidden = true
            self.AlertBox.isHidden = true
            
            self.AddDetails()
            
            //            self.AlertBox.isHidden = true
            // UserDefaults.standard.set(resp.id, forKey: Constants.kUserID)
            //            self.hiddenView.isHidden = true
            //            self.AlertBox.isHidden = true
            //           self.doAnimationAction()
            //            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PharmacyRegisterVC") as? PharmacyRegisterVC {
            //
            //                viewController.type  = self.comingFrom
            //
            //                if let navigator = self.navigationController{
            //                    navigator.pushViewController(viewController, animated: true)
            //                }
            //            }
            //       // }
            self.hideProgress()
        }
    }
    
    func AddDetails(){
        self.showProgress()
        let parameter : [String:Any] = ["name":txtname.text!,
                                        "reg_no":txtRegNo.text!,
                                        "email":txtEmail.text!,
                                        "phone":txtNumber.text!,
                                        "country_code":"91",
                                        "location":self.txtLocation.text!,
                                        "longitude":Lat,
                                        "latitude":Long,
                                        "description":txtDescription.text!
        ]
        uploadMultiplePartImage(urlString: Constants.kBaseUrl + Constants.addPharmacyDetail, params: parameter
                                ,
                                imageKeyValue1: "logo",
                                image1: imgLogo,
                                imageKeyValue2: "banner",
                                image2: imgBanner,
                                imageKeyValue3: "certificate",
                                image3:imgCertificate,
                                imageKeyValue4: "trade",
                                image4:imgTrade,
                                
                                success: { (response) in
                                    print(response)
                                    self.hideProgress()
                                    let dic = response
                                    
                                    guard dic["statusCode"] as! Int == 200 else {
                                        Utilities.ShowAlertView2(title: "Alert",message: dic.value(forKey: "message") as! String, viewController: self)
                                        return
                                    }
                                    
                                    if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarViewController") as? TabBarViewController {
                                        if let navigator = self.navigationController {
                                            navigator.pushViewController(viewController, animated: true)
                                        }
                                    }
                                }) { (Error) in
            self.hideProgress()
        }
    }
    
    func doAnimationAction() {
        UIView .transition(with: self.AlertBox, duration: 1, options: .transitionCrossDissolve,
                           animations: {
                            self.AlertBox.backgroundColor = UIColor.white
                           }){finished in
            // self.AlertBox.textColor = UIColor.white
        }
    }
    
    
    //MARK:=================================  UPLOAD IMAGE ==========================================
    func uploadMultiplePartImage(urlString:String,params:[String:Any]?,imageKeyValue1:String, image1:UIImage?,imageKeyValue2:String, image2:UIImage?,imageKeyValue3:String, image3:UIImage?,imageKeyValue4:String, image4:UIImage?,success:@escaping ( _ response: NSDictionary)-> Void, failure:@escaping ( _ error: Error) -> Void){
        
        let boundary: String = "------VohpleBoundary4QuqLuM1cE5lMwCy"
        let contentType: String = "multipart/form-data; boundary=\(boundary)"
        let headers = ["content-type": "application/json", "Authorization": "Bearer " + "\(String(describing: UserDefaults.standard.value(forKey: Constants.kDeviceID)!))"]
        var request = URLRequest(url: URL(string: urlString)!)
        for (key, value) in headers{
            request.setValue(value , forHTTPHeaderField: key)
        }
        
        request.httpShouldHandleCookies = false
        request.timeoutInterval = 60
        request.httpMethod = "POST"
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        
        let body = NSMutableData()
        if let parameters = params {
            for (key, value) in parameters {
                body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: String.Encoding.utf8)!)
                body.append("\(value)\r\n".data(using: String.Encoding.utf8)!)
            }
        }
        //which field you have to sent image on server
        
        let fileName1: String = imageKeyValue1
        if image1 != nil {
            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(fileName1)\"; filename=\"image.png\"\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Type:image/png\r\n\r\n".data(using: String.Encoding.utf8)!)
            body.append(image1!.jpegData(compressionQuality: 0.1)!)
            body.append("\r\n".data(using: String.Encoding.utf8)!)
        }
        let fileName2: String = imageKeyValue2
        if image2 != nil {
            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(fileName2)\"; filename=\"image.png\"\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Type:image/png\r\n\r\n".data(using: String.Encoding.utf8)!)
            body.append(image2!.jpegData(compressionQuality: 0.1)!)
            body.append("\r\n".data(using: String.Encoding.utf8)!)
        }
        let fileName3: String = imageKeyValue3
        if image3 != nil {
            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(fileName3)\"; filename=\"image.png\"\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Type:image/png\r\n\r\n".data(using: String.Encoding.utf8)!)
            body.append(image3!.jpegData(compressionQuality: 0.1)!)
            body.append("\r\n".data(using: String.Encoding.utf8)!)
        }
        
        let fileName4: String = imageKeyValue3
        if image3 != nil {
            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(fileName4)\"; filename=\"image.png\"\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Type:image/png\r\n\r\n".data(using: String.Encoding.utf8)!)
            body.append(image4!.jpegData(compressionQuality: 0.1)!)
            body.append("\r\n".data(using: String.Encoding.utf8)!)
        }
        
        body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
        request.httpBody = body as Data
        //  let session = URLSession.shared
        let session = URLSession(configuration:.default, delegate: (self as! URLSessionDelegate), delegateQueue: .main)
        // var session = NSURLSession(configuration: configuration, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            //   print(data as Any)
            DispatchQueue.main.async {
                // self.hideProgress()
                
                if(error != nil){
                    //  print(String(data: data!, encoding: .utf8) ?? "No response from server")
                    failure(error!)
                }
                if let responseData = data{
                    do {
                        let json = try JSONSerialization.jsonObject(with: responseData, options: [])
                        //      print(json)
                        success(json as! NSDictionary)
                        
                    }catch let err{
                        //    print(err)
                        
                        failure(err)
                    }
                }
            }
        }
        task.resume()
    }
    
}



