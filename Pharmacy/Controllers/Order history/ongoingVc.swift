//
//  inprogressView.swift
//  Pharmacy
//
//  Created by GT-Mechcubei on 4/20/20.
//  Copyright © 2020 osx. All rights reserved.
//

import UIKit
import SDWebImage

@available(iOS 13.0, *)

class ongoingVc: UIViewController,UIScrollViewDelegate {
    
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    @IBOutlet weak var orderDetailTableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var orderCollectionView: UICollectionView!
    @IBOutlet weak var orderNumber: UILabel!
    @IBOutlet weak var orderInstructions: UITextField!
    @IBOutlet weak var deleveryAddress: UITextField!
    
    @IBOutlet weak var contentView: UIView!
    var StatusVal = ""
    
    @IBOutlet weak var imgStatus: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var hiddenView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var superviewHeightView: DesignableView!
    var medicineStruct = [MedicineModel]()
    
    
    @IBOutlet weak var totalAmountView: DesignableView!
    
    
    @IBOutlet weak var createdAt: UILabel!
    var price = Double()
    var totalString = [String]()
    var currencies_symbol = ""
    @IBOutlet weak var blinkingLbl: UILabel!
    
    var name = ""
    
    @IBOutlet weak var addMoreView: DesignableView!
    
    
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var collectionHeight: NSLayoutConstraint!
    
    @IBOutlet weak var driverName: UILabel!
    @IBOutlet weak var superviewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var mobileNumber: UILabel!
    @IBOutlet weak var driverImage: UIImageView!

    var totalArray = [Int]()
    var imgArr = [String]()
    var nameArr = NSArray()
    var addNewArr = [String]()
    var qtyArr = NSArray()
    var priceArr = NSArray()
    var cancelArr = NSArray()
    var tapGesture = UITapGestureRecognizer()
    var requestId = Int()
    var index = Int()
    var comingFrom = ""
    var secondValue = ""
    var data = ""
    var inputStr1 = [String]()
    var inputStr2 = [String]()
    var inputStr3 = [String]()
    var ordernumber = ""
    var userNameArray = NSArray()
    var phoneArray = NSArray()
    var phone:String!
    
    var currentPage : Int!
    @IBOutlet weak var totalCost: UILabel!

    //MARK:- Life cycle methods 
    override func viewDidLoad() {
        super.viewDidLoad()
        orderDetailTableView.delegate = self
        orderDetailTableView.dataSource = self
        
        userName.text = name
        
        orderDetailTableView.reloadData()
        comingFrom = "didload"
        self.title = "Order Details"
        getOrderDetailAPI()
        orderDetailTableView.separatorStyle = .none
        print(requestId)
        orderTracking()
        
        navigationController?.navigationBar.isHidden = true
        superviewHeightView.layer.shadowColor = UIColor.black.cgColor
        superviewHeightView.layer.shadowOpacity = 0.5
        superviewHeightView.layer.shadowOffset = .zero
        superviewHeightView.layer.shadowRadius = 1
        totalAmountView.layer.shadowColor = UIColor.black.cgColor
        totalAmountView.layer.shadowOpacity = 0.5
        totalAmountView.layer.shadowOffset = .zero
        totalAmountView.layer.shadowRadius = 1
        self.orderNumber.text = ordernumber
        orderCollectionView.delegate = self
        orderCollectionView.dataSource = self
        
        hiddenView.isHidden = true
        imageView.isHidden = true
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(ongoingVc.handleTap(sender:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        hiddenView.addGestureRecognizer(tapGesture)
        hiddenView.isUserInteractionEnabled = true
        
        // totalPrice.text = "\u{20B9}"+"\(0.0)"
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer? = nil){
        hiddenView.isHidden = true
        imageView.isHidden = true
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    @IBAction func StopTFEditing(_ sender: UITextField) {
        
        orderInstructions.endEditing(true)
    }
    
    @IBAction func adressEditing(_ sender: Any) {
        deleveryAddress.endEditing(true)
    }
    
    func orderTracking(){
        let parms = ["request_id":requestId]
        NetworkingService.shared.getData_HeaderParameter(PostName: Constants.korderTracking, parameters: parms) { (response) in
            
            let res = response as! NSDictionary
            
            let dataArr = (res.value(forKeyPath: "data") as? NSDictionary ?? [:])
            let orderDetail = (dataArr.value(forKeyPath: "order_details") as? NSArray ?? [])
            let orderdetailInd = orderDetail[0] as! NSDictionary
            
            // driver info
            let driverInfo = (orderdetailInd.value(forKeyPath: "driver") as? NSArray ?? [])
            print(driverInfo)
            let driverDetailInd = driverInfo[0] as? NSDictionary ?? [:]
            self.driverName.text = driverDetailInd.value(forKey: "username") as? String ?? ""
            
            self.mobileNumber.text = "\(driverDetailInd.value(forKey: "phone") as? Int ?? 0)"
            self.phone = "\(driverDetailInd.value(forKey: "phone") as? Int ?? 0)"

            if let driverImage = driverDetailInd.value(forKey: "image") {
                self.driverImage.sd_setImage(with: URL(string:driverImage as! String), completed: nil)
            }
            
//            // Pharmacy info
//            let pharmacyInfo = (orderdetailInd.value(forKeyPath: "pharmacy_details") as? NSArray ?? [])
//            let pharmacyDetailInd = driverInfo[0] as? NSDictionary ?? [:]
//            self.mobileNumber.text = "\(driverDetailInd.value(forKey: "phone") as? Int ?? 0)"

        }
    }
        
    override func viewDidAppear(_ animated: Bool) {
    }
    
    @IBAction func callButton(_ sender: Any) {
        if let url = URL(string: "tel://\(phone!)"),
                              UIApplication.shared.canOpenURL(url) {
                              UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    @IBAction func message(_ sender: Any) {
        let sms: String = "sms:\(phone!)&body="
            let strURL: String = sms.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            UIApplication.shared.open(URL.init(string: strURL)!, options: [:], completionHandler: nil)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.navigationController?.isNavigationBarHidden = false
        return false
    }
    @IBAction func downloadBtn(_ sender: Any) {
        
        for i in 0..<imgArr.count{
            self.showProgress()
            self.hiddenView.isHidden = false
            
            
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
                                self.hiddenView.isHidden = true
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
    @IBAction func viewBtn(_ sender: Any) {
        
        imageView.isHidden = false
        for i in 0..<imgArr.count{
            let imgURL = imgArr[i]
            self.imageView.sd_setImage(with: URL(string:imgURL), completed: nil)
            self.hiddenView.isHidden = false
        }
        
    }
    
    //MARK:- Api
    func getOrderDetailAPI(){
        self.showProgress()
        let prams : [String : Any] = ["request_id":requestId]
        NetworkingService.shared.getData_HeaderParameter(PostName: Constants.kGetOrderDetail, parameters: prams ){ [self] (resp) in
            let res = resp as! NSDictionary
            print(resp)
            let dataArr = (res.value(forKeyPath: "data") as? NSArray ?? [])
            let prescr = dataArr.value(forKey: "precription") as! NSArray
            let prescrIndex = prescr[0] as? NSArray
            self.imgArr = prescrIndex?.value(forKey: "pre_image") as? [String] ?? []
            print(self.imgArr.count)
            
            if self.imgArr.count == 0{
                self.collectionHeight.constant = 0
                //self.addMoreView.isHidden = true
            }
            self.orderCollectionView.reloadData()
            
            let medicineArr = dataArr.value(forKey: "medicine") as! NSArray
            let medIndex = medicineArr[0] as! NSArray
            self.nameArr = medIndex.value(forKey: "medicine_name") as! NSArray
            for i in 0..<medIndex.count{
                self.medicineStruct.append(MedicineModel(assigned_pharmacy: "\((medIndex[i] as AnyObject).value(forKey: "assigned_pharmacy")  ?? "")", medicine_id:  "\((medIndex[i] as AnyObject).value(forKey: "id")  ?? "")", medicine_name:  "\((medIndex[i] as AnyObject).value(forKey: "medicine_name")  ?? "")", price: "\((medIndex[i] as AnyObject).value(forKey: "price")  ?? "")", quantity: "\((medIndex[i] as AnyObject).value(forKey: "quantity")  ?? "")",showDeleteButton: "no",showCheck:"no"))
                print(self.medicineStruct)
                
//                let quantity = Int(self.medicineStruct[i].quantity)
//                let price = Int(self.medicineStruct[i].price)
//                let tax = Int(quantity!*price!)
//                self.totalArray.append(tax)
//                self.totalString = self.totalArray.map { String($0) }
            }
            
            for i in 0..<self.medicineStruct.count{
                self.totalString.append(medicineStruct[i].price)
            }
                        
            
            self.tableHeight.constant = CGFloat(self.nameArr.count * 50)
            self.orderDetailTableView.reloadData()
            
            self.qtyArr = medIndex.value(forKey: "quantity") as! NSArray
            self.priceArr = medIndex.value(forKey: "price") as! NSArray
            let txtOrder = dataArr.value(forKey: "instruction") as! NSArray
            self.orderInstructions.text =   (txtOrder[0] as! String) == "" ?  "No instruction"  : (txtOrder[0] as! String)
            let txtAddress = dataArr.value(forKey: "address") as! NSArray
            self.deleveryAddress.text =  (txtAddress[0] as! String)
            let createdAt = dataArr.value(forKey: "created_at") as! NSArray
            
            let totalValue = self.price
            let total = (totalValue*100).rounded()/100
            self.totalCost.text = self.currencies_symbol + "\(total)"
                        
            self.createdAt.text = (createdAt[0] as! String)
            var myDate:String = self.createdAt.text ?? ""
            var convertedLocalTime:String = ""
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd H:mm:ss"
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            if let dt = dateFormatter.date(from: myDate) {
                dateFormatter.timeZone = TimeZone.current
                dateFormatter.dateFormat = "yyyy-MM-dd h:mm a"
                convertedLocalTime = dateFormatter.string(from: dt)
            } else {
                print("There was an error decoding the string")
            }
            
            
            
            self.imgStatus.image = #imageLiteral(resourceName: "ongoing")
            self.status.textColor = .systemGreen
            
            self.createdAt.text = "Order Received: " + convertedLocalTime
            let statuus = dataArr.value(forKey: "status") as! NSArray
            self.status.text =  (statuus[0] as! String)
            self.orderCollectionView.reloadData()
            self.superviewHeight.constant = self.collectionHeight.constant + self.tableHeight.constant + 70
            
            self.hideProgress()
        }
        
    }
    
    
    
    
    enum StorageType {
        case userDefaults
        case fileSystem
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
extension ongoingVc : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(medicineStruct.count)
        return medicineStruct.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = orderDetailTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? OngoingCell {
            
            cell.txtName.text = medicineStruct[indexPath.row].medicine_name
            cell.txtQuantity.text = medicineStruct[indexPath.row].quantity
            cell.txtPrice.text = medicineStruct[indexPath.row].price
            cell.priceTxt.text = totalString[indexPath.row]
            
            cell.txtName.delegate = self
            cell.txtName.addTarget(self, action: #selector(GetValue_textFieldDidChange), for: .editingChanged)
            cell.txtQuantity.delegate = self
            cell.txtQuantity.addTarget(self, action: #selector(GetValue_textFieldDidChange2), for: .editingChanged)
            cell.txtPrice.delegate = self
            
            
            cell.priceTxt.delegate = self
            cell.priceTxt.addTarget(self, action: #selector(GetValue_textFieldDidChange4), for: .editingChanged)
            cell.txtPrice.addTarget(self, action: #selector(GetValue_textFieldDidChange3), for: .editingChanged)
            
            
            if medicineStruct[indexPath.row].showDeleteButton == "yes"{
                cell.txtName.isUserInteractionEnabled = true
                cell.txtQuantity.isUserInteractionEnabled = true
            }else if medicineStruct[indexPath.row].showDeleteButton == "no"{
                cell.txtName.isUserInteractionEnabled = false
                cell.txtQuantity.isUserInteractionEnabled = false
                addNewArr.append("0")
            }
            return cell
        }
        
        return UITableViewCell()
    }
    
    // Set the spacing between sections
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    
    @objc func GetValue_textFieldDidChange(textfield: UITextField) {
        let value = ("TextField \(String(describing: textfield.text)) Tag : \(textfield.tag)")
        self.medicineStruct[textfield.tag].price = textfield.text!
        print(medicineStruct)
        //          self.medicineStruct.append(MedicineModel(assigned_pharmacy: "", id:  "", medicine_name:  value, price: "", quantity: "",showDeleteButton: "yes",showCheck:"yes"))
    }
        
    @objc func GetValue_textFieldDidChange3(textfield: UITextField) {
        let value = ("TextField \(String(describing: textfield.text)) Tag : \(textfield.tag)")
        self.medicineStruct[textfield.tag].price = textfield.text!
        print(medicineStruct)
        //          self.medicineStruct.append(MedicineModel(assigned_pharmacy: "", id:  "", medicine_name:  value, price: "", quantity: "",showDeleteButton: "yes",showCheck:"yes"))
        
    }
    
    @objc func GetValue_textFieldDidChange2(textfield: UITextField) {
        let value = ("TextField \(String(describing: textfield.text)) Tag : \(textfield.tag)")
        self.medicineStruct[textfield.tag].price = textfield.text!
        print(medicineStruct)
    }
    
    @objc func GetValue_textFieldDidChange4(textfield: UITextField) {
        let value = ("TextField \(String(describing: textfield.text)) Tag : \(textfield.tag)")
        self.medicineStruct[textfield.tag].price = textfield.text!
        print(medicineStruct)
    }
}



@available(iOS 13.0, *)
extension ongoingVc : UICollectionViewDataSource , UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        print(imgArr.count)
        return imgArr.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? OngoingCellCollection {
            let imgURL = imgArr[indexPath.row]
            
            cell.imgView.sd_setImage(with: URL(string:imgURL), completed: nil)
            //            cell.btnView.tag = indexPath.row
            //            cell.btnDownload.tag = indexPath.row
            
            return cell
        }
        return UICollectionViewCell()
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        return CGSize(width: 80,height: 80)
    }
    
    
    
    
}


class OngoingCell : UITableViewCell{
    
    
    @IBOutlet weak var txtName: UITextField!
    
    
    
    @IBOutlet weak var txtQuantity: UITextField!
    
    
    @IBOutlet weak var txtPrice: UITextField!
    
    @IBOutlet weak var priceTxt: UITextField!
    
    
}


class OngoingCellCollection : UICollectionViewCell{
    
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var buttonDownload: UIButton!
    
    @IBOutlet weak var buttonView: UIButton!
    
}


