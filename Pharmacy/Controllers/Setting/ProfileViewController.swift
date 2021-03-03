
//  ProfileViewController.swift
//  HealthCare
//  Created by osx on 13/01/20.
//  Copyright © 2020 osx. All rights reserved.

import UIKit
import AVFoundation
import FloatRatingView
import GoogleMaps
import GooglePlaces
import CountryPickerView


@available(iOS 13.0, *)
class ProfileViewController: UIViewController , UIPickerViewDelegate ,URLSessionDataDelegate,URLSessionTaskDelegate,URLSessionDelegate , UINavigationControllerDelegate ,UIImagePickerControllerDelegate{
    
    
    enum EmailButtonStatus:String{
        case verify = "Verify?"
        case update = "Update?"
    }
        
    
    @IBOutlet var imgUpload: UIImageView!
    @IBOutlet var txtPharmacyName: UITextField!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtRegNo: UITextField!
    @IBOutlet var txtLocation: UITextField!
    @IBOutlet var txtMobile: UITextField!
    @IBOutlet var hiddenView: UIView!
    @IBOutlet var changePasswordView: DesignableView!
    @IBOutlet var starRatingView: FloatRatingView!
    
    @IBOutlet var noRatingView: UIView!
    @IBOutlet var imgEdit: UIImageView!
    @IBOutlet var textLocation: UITextField!
    @IBOutlet var ratingView: DesignableView!
    @IBOutlet var btnEditOut: UIButton!
    @IBOutlet var lblSubmit: UILabel!
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
    @IBOutlet var btnEditLocOut: UIButton!
    @IBOutlet var editView: UIView!
    @IBOutlet var txtLandline: UITextField!
    @IBOutlet var textLandline: UITextField!
    @IBOutlet var ratingTable: UITableView!
    @IBOutlet var clickedRating: FloatRatingView!
    @IBOutlet var lblRating: UILabel!
    @IBOutlet var bannerProfile: UIImageView!
    @IBOutlet var btnEmailOut: UIButton!
    @IBOutlet var btnPhoneOut: UIButton!
    @IBOutlet var lblChangeEmail: UILabel!
    @IBOutlet var lblChangePhone: UILabel!
    @IBOutlet var txtlandline: UITextField!
    @IBOutlet var bannerUploadChange: UIImageView!
    @IBOutlet var profileImgChange: UIImageView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var imgValidInvalid: UIImageView!
    @IBOutlet var editPhoneImg: UIImageView!
    
    var imagePicker:UIImagePickerController?=UIImagePickerController()
    var tapGesture = UITapGestureRecognizer()
    var profileVM = ProfileViewModel()
    var ratingVM = [RatingModel]()
    var Id = Int()
    var Lat = ""
    var Long = ""
    var Address = ""
    var comingFrom = ""
    var firstName = NSArray()
    var lastName = NSArray()
    var comment = NSArray()
    var star = NSArray()
    var buttonSwitched : Bool = true
    var id = Int()
    var otp = ""
    var phoneOtp:String!
    var cpv = CountryPickerView()
    var countryCODE = ""


    // Resend  otp properties
    var currentEmail:String!
    var currentPhone:String!
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var btnResend: UIButton!
    var isRepeat = true
    var counter = 60
    var timer = Timer()
    
    
    //MARK:- Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
        GetProfile()
        
        // imgValidInvalid.isHidden = true
        scrollView.isScrollEnabled = false
        starRatingView.delegate = self
        starRatingView.isUserInteractionEnabled = false
        clickedRating.isUserInteractionEnabled = false
        self.txtEmail.isUserInteractionEnabled = true
        self.txtMobile.isUserInteractionEnabled = true
        self.txtlandline.isUserInteractionEnabled = false
        comingFrom = "Profile"
        editView.isHidden = true
        ratingView.isHidden = true
        imgEdit.image = #imageLiteral(resourceName: "edit ") 
        self.OTPView.isHidden = true
        imgUpload.layer.cornerRadius = imgUpload.frame.size.width/2
        imgUpload.clipsToBounds = true
        self.hiddenView.isHidden = true
        self.txtEmail.delegate = self
        self.changePasswordView.isHidden = true
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.handleTap(sender:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        hiddenView.addGestureRecognizer(tapGesture)
        hiddenView.isUserInteractionEnabled = true
        GetRatingAPI()
        handlerSelectors()
        setCountryPicker()
        // Do any additional setup after loading the view.
    }
    
    func setCountryPicker(){
        let country = cpv.selectedCountry.phoneCode
        let newString = country.replacingOccurrences(of: "+", with: "", options: .literal, range: nil)
        countryCODE = newString
        print(countryCODE)
    }
        
    override func viewWillAppear(_ animated: Bool) {
        if comingFrom == "location"{
            editView.isHidden = false
        }else{
            editView.isHidden = true
            comingFrom = "Profile"
        }
    }
    
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
           self.expireOTP()
        }
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer? = nil) {
        hiddenView.isHidden = true
        changePasswordView.isHidden = true
        OTPView.isHidden = true
        ratingView.isHidden = true
    }
        
    @IBAction func btnUploadImg(_ sender: UIButton) {
        comingFrom = "image"
        cameraAuthorization()
       // requestCameraPermission()
    }
    
    @IBAction func btnUploadBanner(_ sender: UIButton) {
        comingFrom = "banner"
        cameraAuthorization()
       // requestCameraPermission()
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnEdit(_ sender: Any) {
        if imgEdit.image == #imageLiteral(resourceName: "edit ") {
            editView.isHidden = false
            imgEdit.isHidden = true
            imgEdit.image = nil
            btnEditOut.setTitle("SAVE", for: .normal)
            btnEditOut.isUserInteractionEnabled = true
        } else if btnEditOut.currentTitle == "SAVE"{
            imgEdit.isHidden = false
            imgEdit.image = #imageLiteral(resourceName: "edit ")
            btnEditOut.isUserInteractionEnabled = true
            btnEditOut.setTitle("", for: .normal)
            editProfile()
        }
    }
    
    @IBAction func btnChangeEmail(_ sender: UIButton) {
      
        guard self.lblChangeEmail.text == "Update?" else {
            print("verify")
            self.editEmailAPI()
            return
        }
        
       guard txtEmail.text == currentEmail else {
            txtEmail.text != "" ? self.editEmailAPI() : alert("alert", message: "Please enter email")
            //self.editEmailAPI()
            print("second")
            return
        }
        
        print("bahr")
        txtEmail.isUserInteractionEnabled = true
        txtEmail.becomeFirstResponder()
        
        //if lblChangeEmail.text ==  "Verify?"{
        //            self.editEmailAPI()
        //        }else {
//            if  txtEmail.isUserInteractionEnabled == true {
//                self.editEmailAPI()
//            }else {
//                txtEmail.isUserInteractionEnabled = true
//                txtEmail.becomeFirstResponder()
//
//            }
//        }
        
//        self.buttonSwitched = !self.buttonSwitched
//        if self.buttonSwitched
//        {
//            editEmailAPI()
//        }
//        else
//        {
//            self.txtEmail.isUserInteractionEnabled = true
//            if self.txtEmail.text == "Verify?"{
//                editEmailAPI()
//            }else {
//            }
//        }
    }
    
    @IBAction func btnChangePhone(_ sender: UIButton) {
        guard self.lblChangePhone.text == "Update?" else {
            print("first")
            return
        }
        
        guard txtMobile.text == currentPhone else {
            self.editPhoneAPI()
            print("second")
            return
        }
        
        print("bahr")
        txtMobile.isUserInteractionEnabled = true
        txtMobile.becomeFirstResponder()
//        self.buttonSwitched = !self.buttonSwitched
//        if self.buttonSwitched
//        {
//            editPhoneAPI()
//
//        }
//        else
//        {
//            self.txtMobile.isUserInteractionEnabled = true
//            if self.txtMobile.text == "Verify?"{
//                editPhoneAPI()
//            }else {
//
//            }
//
//        }
        
    }
    
    @IBAction func btnResendOtp(_ sender: Any) {
        //checkOtpStatus()
        self.comingFrom == "email" ? editEmailAPI() : editPhoneAPI()
    }
    
    
    @IBAction func btnFloatRating(_ sender: UIButton) {
        ratingView.isHidden = false
        ratingTable.reloadData()
        hiddenView.isHidden = false
    }
    
    @IBAction func txtPasswordAction(_ sender: UITextField) {
        hiddenView.isHidden = false
        changePasswordView.isHidden = false
        doAnimationAction()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
//        let length = (txtEmail.text?.count)! - range.length + string.count
//
//        if length > 0 {
//            self.imgValidInvalid.isHidden = false
//           // self.lblChangeEmail.isHidden = true
//            if isValidEmail(self.txtEmail.text ?? "") {
//                imgValidInvalid.image = #imageLiteral(resourceName: "verified")
//            }else {
//                imgValidInvalid.image = #imageLiteral(resourceName: "cancel")
//            }
//        }else {
//            self.imgValidInvalid.isHidden = true
//            self.lblChangeEmail.isHidden = false
//        }
        
        return true
    }
    
    
    func editPhoneAPI(){
        let params : [String:Any] = [
            "country_code":countryCODE,
            "phone": txtMobile.text!,
            "verification_type":"phone"
        ]
        
        print(params)
        NetworkingService.shared.getData_HeaderParameter(PostName: Constants.VerifyEmailPhone, parameters: params as! [String : String]) { (resp) in
            print(resp)
            let dic = resp as! NSDictionary
            print(dic)
            
            
            guard (dic.value(forKey: "statusCode") as? Int == 200) else {
                self.alert("Alert", message: "Phone number already registered")
                    return
            }
            
            // if (dic.value(forKey: "has_data") as? String == "0")
            //            {
// Utilities.ShowAlertView2(title: "Alert",message: dic.value(forKey: "message") as! String, viewController: self)
//            }
//            else{
                self.txtMobile.isUserInteractionEnabled = false
                self.otp = dic.value(forKeyPath: "data.otp") as? String ?? ""
                //self.lblSubmit.text = self.otp
                self.hiddenView.isHidden = false
                self.comingFrom = "phone"
                self.OTPView.isHidden = false
                self.checkOtpStatus()
                //self.GetProfile()
                //}
            self.hideProgress()
        }
    }
    
    func editEmailAPI(){
        let params : [String:Any] = [
            "email": txtEmail.text!,
            "verification_type":"Email"
        ]
        NetworkingService.shared.getData_HeaderParameter(PostName: Constants.VerifyEmailPhone, parameters: params as! [String : String]) { (resp) in
            print(resp)
            let dic = resp as! NSDictionary
            print(dic)
            
            guard (dic.value(forKey: "statusCode") as? Int == 200) else {
                self.alert("Alert", message: "The email has already been taken")
                    return
            }
            
//            if (dic.value(forKey: "has_data") as? String == "0")
//            {
//
//                Utilities.ShowAlertView2(title: "Alert",message: dic.value(forKey: "message") as! String, viewController: self)
//            }
//            else{
//                if dic.value(forKey: "message") as! String == "The email has already been taken."{
//                    self.alert("Alert", message: "The email has already been taken")
//                }
            
                self.id = dic.value(forKeyPath: "data.id") as? Int ?? 1
                self.otp = dic.value(forKeyPath: "data.otp") as? String ?? ""
               // self.lblSubmit.text = self.otp
                self.hiddenView.isHidden = false
                self.OTPView.isHidden = false
                self.doAnimationAction()
                // self.txtVerification.text = "Code has been sent to your email"
                self.comingFrom = "email"
                self.txtEmail.isUserInteractionEnabled = false
                self.checkOtpStatus()
                
               // self.GetProfile()
           // }
            self.hideProgress()
        }
    }
    
    func verifyOTPAPI(){
        var params = [String:Any]()
        if comingFrom == "email"{
            params = ["id": id,
                      "otp":otp,
                      "email":txtEmail.text!,
                      "verification_type":"Email"
            ]
        }else {
            params  = ["id": id,
                       "otp":otp,
                       "country_code":countryCODE,
                       "phone": txtMobile.text!,
                       "verification_type":"phone"
            ]
        }
        print(params)
        NetworkingService.shared.getData_HeaderParameter(PostName: Constants.kVerifyOtp, parameters: params ) { [self] (resp) in
            print(resp)
            let dic = resp as! NSDictionary
            print(dic)
            if (dic.value(forKey: "has_data") as? String == "0")
            {
                
                Utilities.ShowAlertView2(title: "Alert",message: dic.value(forKey: "message") as! String, viewController: self)
            }
            else{
                if "\((dic.value(forKey: "message") as? String) ?? "")" == "Otp is Expired"{
                    self.alert("Alert", message: "Wrong OTP")
                }else {
                    self.hiddenView.isHidden = true
                    self.OTPView.isHidden = true
                    self.doAnimationAction()
                    //   self.txtVerification.text = "Code has been sent to your email"
                    self.comingFrom = "email"
                    self.txtEmail.isUserInteractionEnabled = false
                    
                    timer.invalidate()

                    self.GetProfile()
                }
            }
            self.hideProgress()
        }
    }
    
    func setParams() -> [String:String]{
        let phoneparams : [String:String] = ["phone_number": txtMobile.text!, "country_code":"91", "user_role":"pharmacy","verification_type":"phone"]
        let emailparams :[String:String] = ["email":currentEmail, "verification_type":"email", "user_role":"pharmacy"]
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
        
        // when user   try to enter 2 digits in same texfield
        if  text?.count == 2 {
            switch textField{
            case firstTextField: self.modifyOtpValue(texfield:firstTextField,text:text!)
            case secondTextView: self.modifyOtpValue(texfield:secondTextView,text:text!)
            case thirdTextField: self.modifyOtpValue(texfield:thirdTextField,text:text!)
            case forthTextField: self.modifyOtpValue(texfield:forthTextField,text:text!)
            case fifthTextField: self.modifyOtpValue(texfield:fifthTextField,text:text!)
            default:
                break
            }
        }
        else{
            
        }
    }
        
    func modifyOtpValue(texfield:UITextField,text:String){
        let value = text.dropFirst()
        texfield.text =  String(value)
        texfield.resignFirstResponder()
    }
    func openLocationController(){
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    @IBAction func btnEditLocation(_ sender: Any) {
            openLocationController()
        
        
//        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LocationViewController") as? LocationViewController {
//            viewController.comingFrom = comingFrom
//            viewController.callback = { message in
//                self.Lat = (SingletonVariables.sharedInstance.lat)
//                self.Long = (SingletonVariables.sharedInstance.long)
//                self.Address = (SingletonVariables.sharedInstance.address)
//                self.txtLocation.text = self.Address
//                self.comingFrom = viewController.comingFrom
//                if self.comingFrom == "location"{
//                    self.editView.isHidden = false
//                }
//                //Do what you want in here!
//            }
//            if let navigator = self.navigationController{
//                //                            viewController.comingFrom = self.comingFrom
//                //                            viewController.otp  = otp
//                navigator.pushViewController(viewController, animated: true)
//            }
//        }
    
    }
    @IBAction func btnSubmitVerificationCode(_ sender: UIButton) {
        if comingFrom == "email"{
            
            let first  = firstTextField.text! + secondTextView.text!
            let second = thirdTextField.text! + forthTextField.text!
            let third =   fifthTextField.text!
            otp = first + second + third
            if otp.count != 5 {
                alert("Alert", message: "Please fill the otp")
            }else{
                verifyOTPAPI()
            }
        }
        else if comingFrom == "phone"{
            let first  = firstTextField.text! + secondTextView.text!
            let second = thirdTextField.text! + forthTextField.text!
            let third =   fifthTextField.text!
            otp = first + second + third
            if otp.count != 5 {
                alert("Alert", message: "Please fill the otp")
            }else{
                verifyOTPAPI()
            }
        }
    }
    
    func editProfile(){
        let params : [String:Any] = ["longitude": Long,
                                     "latitude":Lat,
                                     "location":textLocation.text!,
                                     "landline":txtLandline.text!
        ]
        NetworkingService.shared.getData_HeaderParameter(PostName: Constants.EditProfile, parameters: params ){ (resp) in
            print(resp)
            let dic = resp as! NSDictionary
            print(dic)
            if (dic.value(forKey: "has_data") as? String == "0")
            {
                self.hiddenView.isHidden = true
                self.OTPView.isHidden = true
                Utilities.ShowAlertView2(title: "Alert",message: dic.value(forKey: "message") as! String, viewController: self)
            }
            else{
                self.editView.isHidden = true
                self.GetProfile()
            }
            self.hideProgress()
        }
    }
    
    func GetRatingAPI(){
        showProgress()
        let params : [String : String] = ["":""]
        NetworkingService.shared.getData_HeaderParameter(PostName: Constants.kGetRating, parameters: params ){ (resp) in
            let res = resp as! NSDictionary
            let rating = res.value(forKeyPath: "data.user_rating") as? NSArray ?? []
            if rating.count != nil {
                for i in 0..<rating.count{
                    self.ratingVM.append(RatingModel(pharmacyRating: "\((rating[i] as AnyObject).value(forKey: "") ?? "")",
                                                     first_name: "\((rating[i] as AnyObject).value(forKey: "first_name") ?? "")",
                                                     id: (rating[i] as AnyObject).value(forKey: "id") as! Int,
                                                     last_name:  "\((rating[i] as AnyObject).value(forKey: "last_name") ?? "")",
                                                     rating_comment: "\((rating[i] as AnyObject).value(forKey: "rating_comment") ?? "")",
                                                     rating_star: "\((rating[i] as AnyObject).value(forKey: "rating_star") ?? "")",
                                                     imgURl: "\((rating[i] as AnyObject).value(forKey: "image") ?? "")"))
                    self.ratingTable.reloadData()
                }
            }
            self.hideProgress()
        }
    }
    
    func doAnimationAction() {
        UIView .transition(with: self.changePasswordView, duration: 1, options: .transitionCrossDissolve,
                           animations: {
                            self.changePasswordView.backgroundColor = UIColor.white
                           }){finished in
            // self.AlertBox.textColor = UIColor.white
        }
    }
    
    func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video, completionHandler: {accessGranted in
            guard accessGranted == true else { return }
            //self.presentCamera()
        })
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
        imagePicker?.delegate = self
        optionMenu.addAction(TakeAction)
        optionMenu.addAction(saveAction)
        optionMenu.addAction(cancelAction)
        if let popoverController = optionMenu.popoverPresentationController {
            popoverController.sourceView = self.view
              popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
              popoverController.permittedArrowDirections = []
            }

          // popoverController.barButtonItem = sender
         
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    
    //MARK: Function to open Camera
    func opencamera()
    {
        if UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            imagePicker!.delegate = self
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
            imagePicker!.delegate = self
            imagePicker!.sourceType = UIImagePickerController.SourceType.photoLibrary;
            imagePicker!.allowsEditing = true
            self.present(imagePicker!, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print(info as Any);
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            if comingFrom == "image"{
                imgUpload.image = (info[UIImagePickerController.InfoKey.editedImage] as! UIImage)
                editImage()
            }else if comingFrom == "banner"{
                bannerProfile.image = (info[UIImagePickerController.InfoKey.editedImage] as! UIImage)
                editBanner()
            }
        }else{
            print("Something went wrong")
        }
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func setButtonTitle(emailStatus:Int){
        self.imgValidInvalid.image =   emailStatus == 1  ?  #imageLiteral(resourceName: "verified")  : #imageLiteral(resourceName: "cancel")
        self.btnEmailOut.setTitle(emailStatus == 1 ?   "Update?"  : "Verify?" , for: .normal)
    }
    
    //MARK:-----------------------------------------Register API --------------------------------------------
    func GetProfile(){
        showProgress()
        let params : [String : String] = ["user_type":"Pharmacy"]
        profileVM.getProfileData(vc: self, prams: params) { (resp) in
            print(resp)
            self.txtPharmacyName.text = resp.first_name
            self.txtPharmacyName.isUserInteractionEnabled = false
            self.txtRegNo.isUserInteractionEnabled = false
            self.txtRegNo.text = resp.last_name
            self.txtEmail.text = resp.email
            self.txtMobile.text = "\(resp.Phone)"
            self.textLocation.text = resp.address
            self.phoneOtp = "\(resp.otp)"
            self.currentEmail = resp.email
            self.currentPhone = "\( resp.Phone)"
            
            if resp.rating != "" {
                self.starRatingView.rating = Double(resp.rating)!
                self.clickedRating.rating = Double(resp.rating)!
                self.lblRating.text = resp.rating
                self.ratingView.isHidden = true
            }else {
                self.ratingView.isHidden = false
            }
            self.txtlandline.text = resp.landline
            self.textLocation.isUserInteractionEnabled = false
          
            
            // for email
            self.lblChangeEmail.text = resp.emailStatus == "1" ? "Update?" : "Verify?"
            self.imgValidInvalid.image = resp.emailStatus == "1" ? #imageLiteral(resourceName: "verified") : #imageLiteral(resourceName: "cancel")
            
            //for phone
            self.lblChangePhone.text =  "Update?"
            self.editPhoneImg.image =  resp.phoneStatus == "1" ? #imageLiteral(resourceName: "verified") : #imageLiteral(resourceName: "cancel")
            
            if resp.image != "" {
                let URLARR = resp.image
                self.imgUpload.sd_setImage(with: URL(string:URLARR), completed: nil)
                self.imgUpload.layer.cornerRadius = self.imgUpload.frame.size.width/2
                self.imgUpload.clipsToBounds = true
            }
            if resp.banner != "" {
                let URLARR = resp.banner
                self.bannerProfile.sd_setImage(with: URL(string:URLARR), completed: nil)
            }
            DispatchQueue.main.async{
                
            }
            self.hideProgress()
        }
    }
    
    func editImage(){
        let parameter : [String:Any] = ["":""]
        uploadMultiplePartImage(urlString: Constants.kBaseUrl + Constants.editPicture, params: parameter
                                , imageKeyValue: "image",image: imgUpload.image!,success: { (response) in
                                    print(response)
        let dic = response as! NSDictionary
            print(dic)
        if (dic.value(forKey: "has_data") as? String == "0")
        {
          Utilities.ShowAlertView2(title: "Alert",message: dic.value(forKey: "message") as! String, viewController: self)
        }else{
                                        
            self.GetProfile()
            //self.uploadImg.isHidden = true
        }
            }) { (Error) in
            self.hideProgress()
        }
    }
    
    func editBanner(){
        let parameter : [String:Any] = ["":""]
        uploadMultiplePartImage(urlString: Constants.kBaseUrl + Constants.editBanner, params: parameter
                                , imageKeyValue: "image",image: bannerProfile.image!,success: { (response) in
                                    print(response)
                                    let dic = response as! NSDictionary
                                    print(dic)
                                    if (dic.value(forKey: "has_data") as? String == "0")
                                    {
                                        Utilities.ShowAlertView2(title: "Alert",message: dic.value(forKey: "message") as! String, viewController: self)
                                    }
                                    else{
                                        self.GetProfile()
                                        //self.uploadImg.isHidden = true
                                    }
                                }) { (Error) in
            self.hideProgress()
        }
    }
    
    //MARK:=================================  UPLOAD IMAGE ==========================================
    func uploadMultiplePartImage(urlString:String,params:[String:Any]?,imageKeyValue:String, image:UIImage?,success:@escaping ( _ response: NSDictionary)-> Void, failure:@escaping ( _ error: Error) -> Void){
        
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
        //In which field you have to sent image on server
        let fileName1: String = imageKeyValue
        if image != nil {
            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(fileName1)\"; filename=\"image.png\"\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Type:image/png\r\n\r\n".data(using: String.Encoding.utf8)!)
            body.append(image!.jpegData(compressionQuality: 0.1)!)
            body.append("\r\n".data(using: String.Encoding.utf8)!)
        }
        body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
        request.httpBody = body as Data
        let session = URLSession(configuration:.default, delegate: (self as! URLSessionDelegate), delegateQueue: .main)
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            DispatchQueue.main.async {
                if(error != nil){
                    failure(error!)
                }
                if let responseData = data{
                    do {
                        let json = try JSONSerialization.jsonObject(with: responseData, options: [])
                        success(json as! NSDictionary)
                        
                    }catch let err{
                        failure(err)
                        
                    }
                }
            }
        }
        task.resume()
    }
}

class ratingCell : UITableViewCell ,FloatRatingViewDelegate {
    @IBOutlet var imgProfile: UIImageView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblDescription: UILabel!
    @IBOutlet var floatRatingView: FloatRatingView!
    
    // MARK: FloatRatingViewDelegate
    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating: Double) {
        let val = String(format: "%.2f",  floatRatingView.rating)
        print(val)
    }
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Double) {
        let val2 = String(format: "%.2f",  floatRatingView.rating)
        print(val2)
    }
    
    
}
@available(iOS 13.0, *)
extension ProfileViewController : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return ratingVM.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = ratingTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ratingCell
        cell.lblName.text = ratingVM[indexPath.row].first_name
        cell.lblDescription.text = ratingVM[indexPath.row].rating_comment
        let imgURL = ratingVM[indexPath.row].imgURl
        cell.imgProfile.sd_setImage(with: URL(string:imgURL), completed: nil)
        cell.floatRatingView.isUserInteractionEnabled = false
        
        cell.floatRatingView.rating = Double(ratingVM[indexPath.row].rating_star)!
        return cell
    }
    
    
}

@available(iOS 13.0, *)
extension ProfileViewController : FloatRatingViewDelegate {
    // MARK: FloatRatingViewDelegate
    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating: Double) {
        let val = String(format: "%.2f",  starRatingView.rating)
        print(val)
    }
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Double) {
        let val2 = String(format: "%.2f",  starRatingView.rating)
        print(val2)
    }
}

@available(iOS 13.0, *)
extension ProfileViewController:GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
     
        dismiss(animated: true, completion: nil)

        self.editView.isHidden = false

        print( place.formattedAddress)
        print(place.coordinate.latitude)
        print(place.coordinate.longitude)
        self.Lat = "\(place.coordinate.latitude)"  // (SingletonVariables.sharedInstance.lat)
        self.Long = "\(place.coordinate.longitude)" // (SingletonVariables.sharedInstance.long)
        self.Address =  place.formattedAddress!  //  "\(place.coordinate.latitude)" (SingletonVariables.sharedInstance.address)
        self.textLocation.text = self.Address

     
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
}
