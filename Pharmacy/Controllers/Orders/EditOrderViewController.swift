//
//  EditOrderViewController.swift
//  Pharmacy
//
//  Created by osx on 07/02/20.
//  Copyright © 2020 osx. All rights reserved.


import UIKit
import SDWebImage
@available(iOS 13.0, *)
class EditOrderViewController: UIViewController {
    
    @IBOutlet weak var hiddenView: UIView!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet var orderDetailTable: UITableView!
    @IBOutlet var orderDetailCollection: UICollectionView!
    @IBOutlet var txtOrderInstructions: UITextField!
    @IBOutlet var txtAddress: UITextField!
    @IBOutlet var orderREceivedDate: UILabel!
    @IBOutlet var status: UILabel!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var superViewHeight: NSLayoutConstraint!
    @IBOutlet var collectionHeight: NSLayoutConstraint!
    @IBOutlet var tableHeight: NSLayoutConstraint!
    @IBOutlet var imgStatus: UIImageView!
    @IBOutlet var addMoreView: DesignableView!
    @IBOutlet var tableSuperView: DesignableView!
    @IBOutlet var lblOrderNumber: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet var medicineNameTableView: UITableView!
    @IBOutlet var medicinesNameView: UIView!

    
    // add description values
    @IBOutlet var descriptionView: DesignableView!
    @IBOutlet var btnAdddescription: UIButton!
    @IBOutlet var buttonSave: DesignableButton!
    @IBOutlet var txtUploadPrescription: UITextView!
    
    @IBOutlet var btnCall: UIButton!
    @IBOutlet var btnMessage: UIButton!
  
    
    var selectedArray = [Bool]()
    var medIndex = [[String:Any]]()
    var totalArray = [Int]()
    var medicalList = [[String: Any]]()
    var mediceneNameArray = NSArray()

    
    var medicalDict = Dictionary<String, AnyObject>()
    var username = ""
    
    var imgArr = [String]()
    var nameArr = NSArray()
    var addNewArr = [String]()
    var qtyArr = NSArray()
    var priceArr = NSArray()
    var cancelArr = NSArray()
    var tapGesture = UITapGestureRecognizer()
    var requestId = Int()
    var medicineStruct = [MedicineModel]()
    var index = Int()
    var comingFrom = ""
    var secondValue = ""
    var data = ""
    var inputStr1 = [String]()
    var inputStr2 = [Int]()
    var inputStr3 = [Int]()
    var inputStr4 = [Int]()
    var inputStr5 = [Int]()
    var ordernumber = ""
    var total = 0
    var selectedTexfield:Int!

    
    //MARK:- Life cycle method
    override func viewDidLoad() {
        super.viewDidLoad()
        comingFrom = "didload"
        self.title = "Edit Order Details"
        self.medicinesNameView.isHidden = true

        //      self.orderDetailTable.delegate = self
        //      self.orderDetailTable.dataSource = self
        
        self.intialView()
    }
    
   
    override func viewWillAppear(_ animated: Bool) {
        self.setUpNav()
    }
    
    func setUpNav() {
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "left"), style: .plain, target: self, action: #selector(back))
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @objc func back() {
        if let viewControllers = self.navigationController?.viewControllers {
            for vc in viewControllers {
                if vc.isKind(of: TabBarViewController.classForCoder()) {
                    self.navigationController?.popToViewController(vc, animated: true)
                }
            }
        }
    }
    
    //MARK:- Class extra functions
    func intialView(){
        self.getApiData()
        self.setData()
        self.tableViewSetups()
        self.gesture()
    }
    
    func getApiData(){
        
        self.getOrderDetailAPI()
        
        ConnectSocket.shared.addHandler()
        ConnectSocket.shared.connectSocket()
    }
    
    func setData(){
        self.lblOrderNumber.text = ordernumber
        totalPrice.text = "\u{20B9}"+"\(0.0)"
        userName.text = username
        
    }
    
    func tableViewSetups(){
        tableSuperView.layer.shadowColor = UIColor.black.cgColor
        tableSuperView.layer.shadowOpacity = 0.5
        tableSuperView.layer.shadowOffset = .zero
        tableSuperView.layer.shadowRadius = 2
        
        orderDetailCollection.delegate = self
        orderDetailCollection.dataSource = self
    }
    
    func gesture(){
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(EditOrderViewController.handleTap(sender:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        hiddenView.addGestureRecognizer(tapGesture)
        hiddenView.isUserInteractionEnabled = true
        
        // hide views
        hiddenView.isHidden = true
        imgView.isHidden = true
        
        // description properties
        descriptionView.isHidden = true
        txtUploadPrescription.text = "Enter Description"
        txtUploadPrescription.textColor = UIColor.lightGray
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer? = nil){
        hiddenView.isHidden = true
        imgView.isHidden = true
    }
    
    
    //MARK:- Actions
    
    
    
    @IBAction func callButton(_ sender: Any) {
//        if let url = URL(string: "tel://\(phone!)"),
//                              UIApplication.shared.canOpenURL(url) {
//                              UIApplication.shared.open(url, options: [:], completionHandler: nil)
//        }
    }
    @IBAction func message(_ sender: Any) {
//        let sms: String = "sms:\(phone!)&body="
//            let strURL: String = sms.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
//            UIApplication.shared.open(URL.init(string: strURL)!, options: [:], completionHandler: nil)
    }
      
    @IBAction func buttonDownload(_ sender: UIButton) {
        
        hiddenView.isHidden = false
        
        for i in 0..<imgArr.count{
            self.showProgress()
            
            //Create URL to the source file you want to download
            let fileURL = URL(string: imgArr[i])
            
            let sessionConfig = URLSessionConfiguration.default
            let session = URLSession(configuration: sessionConfig)
            
            let request = URLRequest(url:fileURL!)
            
            let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
                if let tempLocalUrl = tempLocalUrl, error == nil {
                    // Success
                    if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                        print("Successfully downloaded. Status code: \(statusCode)")
                        DispatchQueue.main.async {
                            if let url = URL(string: self.imgArr[i]),
                                let data = try? Data(contentsOf: url),
                                let image = UIImage(data: data) {
                                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                                self.alert("Alert", message: "Image has been downloaded")
                                self.hideProgress()
                            }
                        }
                    }
                    self.hideProgress()
                    
                } else {
                    print("Error took place while downloading a file. Error description: %@", error?.localizedDescription);
                    self.hideProgress()
                }
            }
            task.resume()
        }
    }
    
    @IBAction func buttonCheckMark(_ sender: UIButton) {
        medicineStruct[sender.tag].isSelected =  medicineStruct[sender.tag].isSelected ==   true  ? false  : true
        self.orderDetailTable.reloadData()
    }
    
    @IBAction func accept(_ sender: UIButton) {
        guard validate() else { return }
        self.editOrderApi()
    }
    
    func validate() -> Bool{
        // pharmacy must at least one selection before submit
        guard self.checkSelectedValue() else {
            alert("Warning!", message: "Please enter at least one medicine ")
            return false
        }
        // gather selected data
        self.medicalList.removeAll()
        
        for i in  0..<medicineStruct.count{
            if medicineStruct[i].isSelected == true || medicineStruct[i].isdded == true {
                
                // enter price in dictionary
                let indexPath = NSIndexPath(row:i, section:0)
                let cell : editOrderCell? = self.orderDetailTable.cellForRow(at: indexPath as IndexPath) as! editOrderCell?
                
                medicineStruct[i].price = (cell?.txtPrice.text)!
                
                // check if any selected field empty
                if   medicineStruct[i].price == "0" ||  medicineStruct[i].price == "" || medicineStruct[i].quantity == "" {
                    alert("Warning!", message: "Please enter proper detail for medicine " + medicineStruct[i].medicine_name)
                    return false
                }
                
                // append dict into array
                let selctedMedicines = [
                    "medicine_name": medicineStruct[i].medicine_name,
                    "quantity":medicineStruct[i].quantity,
                    "assigned_pharmacy": medicineStruct[i].assigned_pharmacy,
                    "medicine_id":medicineStruct[i].medicine_id,
                    "price":medicineStruct[i].price
                ]
                medicalList.append(selctedMedicines as [String : Any])
            }
        }
        return true
    }
    
    func checkSelectedValue() -> Bool {
        return self.medicineStruct.allSatisfy({$0.isSelected == false}) ?  false  :  true
    }
    
    @IBAction func buttonView(_ sender: UIButton){
        imgView.isHidden = false
        for i in 0..<imgArr.count{
            let imgURL = imgArr[i]
            self.imgView.sd_setImage(with: URL(string:imgURL), completed: nil)
            self.hiddenView.isHidden = false
        }
    }
    
    @IBAction func btnAddMore(_ sender: UIButton){
        self.medicineStruct.append(MedicineModel(assigned_pharmacy: "", medicine_id:  "", medicine_name:  "", price: "", quantity: "",isdded: true))
        
        index = index + 1
        
        if index >= 1{
            inputStr1.append("")
            inputStr2.append(0)
            inputStr3.append(4)
            inputStr4.append(0)
            inputStr5.append(0)
        }
        
        self.comingFrom = "AddMore"
        self.tableHeight.constant = CGFloat(self.medicineStruct.count * 50)
        self.superViewHeight.constant = self.collectionHeight.constant + self.tableHeight.constant + 150
        self.orderDetailTable.reloadData()
    }
    
    @IBAction func btnRemove(_ sender: UIButton){
        self.medicineStruct.remove(at: sender.tag)
        self.tableHeight.constant = CGFloat(self.medicineStruct.count * 50)
        self.superViewHeight.constant = self.collectionHeight.constant + self.tableHeight.constant + 150
        self.orderDetailTable.reloadData()
    }
    
    func hideDescriptonView(status:Bool){
        self.hiddenView.isHidden = status
        self.descriptionView.isHidden = status
    }
    
    @IBAction func btnSaveText(_ sender: UIButton){
        
        if self.txtUploadPrescription.text == "Enter Description"{
            alert("Alert", message: "Description should not be empty")
        }else if  self.txtUploadPrescription.text == "" {
            self.btnAdddescription.setTitle("+ADD DESCRIPTION", for: .normal)
            self.hideDescriptonView(status:true)
        }else{
            
            UserDefaults.standard.set(self.txtUploadPrescription.text, forKey: "txt")
            self.btnAdddescription.setTitle("VIEW DESCRIPTION", for: .normal)
            
            self.hideDescriptonView(status:true)
        }
    }
    
    @IBAction func btnCancel(_ sender: UIButton) {
        self.hideDescriptonView(status:true)
    }
    
    @IBAction func addDescription(_ sender: UIButton) {
        
        self.hideDescriptonView(status:false)
        if self.btnAdddescription.currentTitle == "+ADD DESCRIPTION" {
            self.txtUploadPrescription.text! = "Enter Description"
            self.txtUploadPrescription.textColor = UIColor.lightGray
            self.txtUploadPrescription.resignFirstResponder()
        }else {
            
            self.txtUploadPrescription.text! = UserDefaults.standard.value(forKey: "txt") as! String
        }
    }
    
    //MARK:- API'S
    
    func getOrderDetailAPI(){
        self.showProgress()
        let prams : [String : Any] = ["request_id":requestId]
        NetworkingService.shared.getData_HeaderParameter(PostName: Constants.kGetOrderDetail, parameters: prams ){ (resp) in
            
            let res = resp as! NSDictionary
            
            print(resp)
            // array of images
            let dataArr = (res.value(forKeyPath: "data") as? NSArray ?? [])
            
            let prescr = dataArr.value(forKey: "precription") as! NSArray
            let prescrIndex = prescr[0] as? NSArray
            self.imgArr = prescrIndex?.value(forKey: "pre_image") as? [String] ?? []
            
            if self.imgArr.count == 0{
                self.collectionHeight.constant = 0
            }
            
            self.orderDetailCollection.reloadData()
            // array of medicines
            
            let medicineArr = dataArr.value(forKey: "medicine") as! NSArray
            self.medIndex = medicineArr[0] as! [[String:Any]]
            
            print(self.medIndex)
            
            for data in 0..<self.medIndex.count{
                let medicine_name = self.medIndex[data]["medicine_name"] as? String ?? "medicine_name"
                let quantity = self.medIndex[data]["quantity"] as? Int ?? 01
                let assigned_pharmacy = self.medIndex[data]["assigned_pharmacy"] as? Int ?? 01
                let medicine_id = self.medIndex[data]["medicine_id"] as? Int ?? 01
                let price = self.medIndex[data]["price"] as? Int ?? 01
                
                self.inputStr1.append(medicine_name)
                self.inputStr2.append(quantity)
                self.inputStr3.append(assigned_pharmacy)
                self.inputStr4.append(medicine_id)
                self.inputStr5.append(price)
                print(self.inputStr2,self.inputStr1,self.inputStr3,self.inputStr4,self.inputStr5)
            }
            
            for i in 0..<self.medIndex.count{
                self.medicineStruct.append(MedicineModel(assigned_pharmacy:"34", medicine_id:  "\((self.medIndex[i] as AnyObject).value(forKey: "id")  ?? "")", medicine_name:  "\((self.medIndex[i] as AnyObject).value(forKey: "medicine_name")  ?? "")", price: "", quantity: "\((self.medIndex[i] as AnyObject).value(forKey: "quantity")  ?? "")",isSelected: false, isdded:false))
            }
            
            print(self.medicineStruct)
            self.tableHeight.constant = CGFloat(self.medicineStruct.count * 50)
            self.orderDetailTable.reloadData()
            
            // set others data
            let txtOrder = dataArr.value(forKey: "instruction") as! NSArray
            let txtAddress = dataArr.value(forKey: "address") as! NSArray
            let createdAt = dataArr.value(forKey: "created_at") as! NSArray
            let statuus = dataArr.value(forKey: "status") as! NSArray
            
            if txtOrder[0] as? String == ""{
                self.txtOrderInstructions.text = "No instructions"
            }
            self.txtOrderInstructions.isUserInteractionEnabled = false
            
            self.txtAddress.text =  (txtAddress[0] as! String)
            self.orderREceivedDate.text = "Order Received: "  + self.changeDateToString(myDate: createdAt[0] as! String)
            self.status.text =  (statuus[0] as! String)
            
            
            self.imgStatus.image = #imageLiteral(resourceName: "accepted")
            self.status.textColor = Constants.DARK_Green
            self.orderDetailCollection.reloadData()
            self.superViewHeight.constant = self.collectionHeight.constant + self.tableHeight.constant + 150
            self.hideProgress()
        }
    }
    
    func editOrderApi(){
        let total = self.totalPrice.text!
        
        let replaced = total.replacingOccurrences(of: "₹", with: "")
        print(total as Any)
        let token = UserDefaults.standard.value(forKey: Constants.kDeviceID)
        let dataDict:Dictionary = [
            "data": medicalList
        ]
        
        let jsonData = try! JSONSerialization.data(withJSONObject:dataDict)
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)
        print(jsonString as Any)
        let medicinesDict = [
            "token": "Bearer \(token ?? "")" as AnyObject ,
            "request_id": requestId as AnyObject ,
            "pharmacy_instruction": txtOrderInstructions.text! as AnyObject ,
            "subtotal": 80 as AnyObject ,
            "total": replaced as AnyObject,
            "medicine":jsonString as Any
            ] as [String : AnyObject]
        
        //print(medicinesDict)
        print(medicinesDict)
        showProgress()
        if ConnectSocket.shared.socket.status == .connected {
            ConnectSocket.shared.socket.emitWithAck("edit_order",medicinesDict).timingOut(after: 5.0) { (response) in
                print(response)
                if let viewControllers = self.navigationController?.viewControllers {
                    for vc in viewControllers {
                        if vc.isKind(of: TabBarViewController.classForCoder()) {
                            self.navigationController?.popToViewController(vc, animated: true)
                        }
                    }
                }
                //self.navigationController?.popViewController(animated: true)
                self.hideProgress()
            }
        }
    }
    
    func changeDateToString(myDate:String) -> String{
        var convertedLocalTime:String = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd H:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let dt = dateFormatter.date(from: myDate)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-dd h:mm a"
        convertedLocalTime = dateFormatter.string(from: dt!)
        return convertedLocalTime
    }
    
    enum StorageType {
        case userDefaults
        case fileSystem
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    
    private func store(image: UIImage, forKey key: String, withStorageType storageType: StorageType) {
        if let pngRepresentation = image.pngData() {
            switch storageType {
            case .fileSystem:
                // Save to disk
                if let filePath = filePath(forKey: key) {
                    do  {
                        try pngRepresentation.write(to: filePath,
                                                    options: .atomic)
                    } catch let err {
                        print("Saving file resulted in error: ", err)
                    }
                }
            case .userDefaults:
                // Save to user defaults
                UserDefaults.standard.set(pngRepresentation, forKey: key)
            }
        }
        // Implementation
    }
    private func retrieveImage(forKey key: String, inStorageType storageType: StorageType)-> UIImage? {
        switch storageType {
        case .fileSystem:
            // Retrieve image from disk
            if let filePath =  filePath(forKey: key){
                let fileData = FileManager.default.contents(atPath: filePath.path)
                let image = UIImage(data: fileData!)
                return image
            }
        case .userDefaults:
            // Retrieve image from user defaults
            if let imageData = UserDefaults.standard.object(forKey: key) as? Data,
                let image = UIImage(data: imageData) {
                return image
            }
        }
        return nil
    }
    private func filePath(forKey key: String) -> URL? {
        let fileManager = FileManager.default
        guard let documentURL = fileManager.urls(for: .documentDirectory,
                                                 in: FileManager.SearchPathDomainMask.userDomainMask).first else { return nil }
        return documentURL.appendingPathComponent(key + ".png")
    }
}

@available(iOS 13.0, *)
extension EditOrderViewController : UITableViewDelegate , UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(medicineStruct.count)
        //  if let  array =  medicineStruct.count as? Int  {
        return medicineStruct.count
        //  }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard tableView == orderDetailTable else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "mediceNameCell", for: indexPath) as! mediceNameCell
            cell.lblMedicnesName.text = (mediceneNameArray[indexPath.row] as! String)
            return cell
        }
        
        
        if let cell = orderDetailTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? editOrderCell {
            print("")
            
            // set textfield data
            cell.txtName.text = medicineStruct[indexPath.row].medicine_name
            cell.txtQuantity.text = medicineStruct[indexPath.row].quantity
            cell.txtPrice.text = medicineStruct[indexPath.row].price
            
            if indexPath.row == 0 {
                cell.txtPrice.becomeFirstResponder()
            }
            
            // tag to buttons
            cell.btnCross.tag = indexPath.row
            cell.btnCheck.tag = indexPath.row
            
            cell.txtName.tag = indexPath.row
            cell.txtQuantity.tag = indexPath.row
            cell.txtPrice.tag = indexPath.row
            
            
            cell.txtName.delegate = self
            cell.txtName.addTarget(self, action: #selector(GetValue_textFieldDidChange), for: .editingChanged)
            
            cell.txtQuantity.delegate = self
            cell.txtQuantity.addTarget(self, action: #selector(GetValue_textFieldDidChange2), for: .editingChanged)
            
            cell.txtPrice.delegate = self
            cell.txtPrice.addTarget(self, action: #selector(GetValue_textFieldDidChange3), for: .editingChanged)
            
            // check status of selected and cross button
            cell.btnCross.isHidden =  medicineStruct[indexPath.row].isdded == true ?  false  : true
            cell.btnCheck.isHidden = medicineStruct[indexPath.row].isdded == true ? true : false
            
            // set selcted images
            cell.btnCheck.setImage(medicineStruct[indexPath.row].isSelected == true ? #imageLiteral(resourceName: "checkSelected")  : #imageLiteral(resourceName: "checkBox"), for: .normal)
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard tableView != orderDetailTable else {
             return
        }
    }
    
    // Set the spacing between sections
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard tableView != medicineNameTableView else {
            return UITableView.automaticDimension
        }
        return 40
    }
    
    @objc func GetValue_textFieldDidChange(textfield: UITextField) {
        self.medicineStruct[textfield.tag].medicine_name = textfield.text!
        selectedTexfield = textfield.tag
        self.medicinesNameView.isHidden = false
        print("Now Texfield is ",selectedTexfield ?? 0)
        self.seachMEdines(text: textfield.text!)
        // self.orderDetailTable.reloadData()
        print(self.medicineStruct[textfield.tag].medicine_name)
    }
    
    
    func seachMEdines(text:String){
        self.showProgress()
        let prams  = ["search":text]
        NetworkingService.shared.getData_HeaderParameter2(PostName: Constants.KSearchMedicines, parameters: prams ){ (resp) in
            
            self.hideProgress()
            let res = resp as! NSDictionary
            
            print(resp)
            let dataArr = (res.value(forKeyPath: "data") as? NSArray ?? [])
            guard dataArr.count > 0 else {
                self.medicinesNameView.isHidden = true
                return
            }
            
            self.mediceneNameArray = dataArr.value(forKey: "full_name") as! NSArray
            self.medicineNameTableView.reloadData()
        }
        self.hideProgress()
    }
    
    @objc func GetValue_textFieldDidChange2(textfield: UITextField) {
        self.medicineStruct[textfield.tag].quantity = textfield.text!
        self.orderDetailTable.reloadData()
    }
    
    
    @objc   func GetValue_textFieldDidChange3(textfield: UITextField) {
        
        self.medicineStruct[textfield.tag].price = textfield.text!
        
        if let text =  Int(self.medicineStruct[textfield.tag].quantity) , let subtotal =  textfield.text == "" ? 0 : Int(textfield.text!)
        {
            let percentage = subtotal * text
            self.medicineStruct[textfield.tag].total = percentage
            self.calculateTotal()
        }
    }
    
    func calculateTotal(){
        var total = 0
        for  i in 0..<medicineStruct.count{
            print(self.medicineStruct[i].total)
            total += self.medicineStruct[i].total
            self.totalPrice.text =  "₹" + "\(total)"
        }
        self.orderDetailTable.reloadData()
    }
    
    //MARK:- textfield delegate methods
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
       // self.medicineTableView.isScrollEnabled = false
       // self.medicinesNameView.isHidden = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
      //  self.medicineTableView.isScrollEnabled = true
        self.medicinesNameView.isHidden = true
    }
    
}

class editOrderCell : UITableViewCell{
    @IBOutlet var txtName: UITextField!
    @IBOutlet var txtQuantity: UITextField!
    @IBOutlet var txtPrice: UITextField!
    @IBOutlet var imgCross: UIImageView!
    @IBOutlet var btnCross: UIButton!
    @IBOutlet var btnCheck: UIButton!
    @IBOutlet var imgCheck: UIImageView!
}
class mediceNameCell : UITableViewCell {
 
    @IBOutlet var lblMedicnesName: UILabel!
}

@available(iOS 13.0, *)
extension EditOrderViewController : UICollectionViewDataSource , UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        print(imgArr.count)
        return imgArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? editOrderDetailCell
        let imgURL = imgArr[indexPath.row]
        print(imgURL,imgArr)
        
        cell!.imgView.sd_setImage(with: URL(string:imgURL), completed: nil)
        cell!.btnView.tag = indexPath.row
        cell!.btnDownload.tag = indexPath.row
        return cell!
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: 80,height: 90)
    }
}

class editOrderDetailCell : UICollectionViewCell{
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var btnDownload: UIButton!
    @IBOutlet var btnView: UIButton!
}

@available(iOS 13.0, *)
extension EditOrderViewController : UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView){
        
        if textView.text == "Enter Description" {
            textView.text = nil
            textView.textColor = UIColor.black
        }else {
            textView.textColor = UIColor.lightGray
        }
        
        //        if textView.textColor == UIColor.lightGray {
        //            textView.text = nil
        //            textView.textColor = UIColor.black
        //        }
    }
    //
    //    func textViewDidChange(_ textView: UITextView) {
    //        if self.txtUploadPrescription.text! == "" || self.txtUploadPrescription.text! == "Enter Description"{
    //            buttonSave.isUserInteractionEnabled = false
    //            buttonSave.tintColor = .gray
    //        }else {
    //            buttonSave.isUserInteractionEnabled = true
    //            buttonSave.titleColor(for: .focused)
    //        }
    //    }
    //
    //    func textViewDidEndEditing(_ textView: UITextView){
    //        if textView.text.isEmpty {
    //            self.txtUploadPrescription.text! = "Enter Description"
    //            textView.textColor = UIColor.lightGray
    //            if self.txtUploadPrescription.text! == "" || self.txtUploadPrescription.text! == "Enter Description"{
    //                buttonSave.isUserInteractionEnabled = false
    //                buttonSave.tintColor = .gray
    //            }else {
    //                buttonSave.isUserInteractionEnabled = true
    //                buttonSave.titleColor(for: .focused)
    //            }
    //        }
    //    }
}
