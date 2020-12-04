//
//  OrderDetailsVC.swift
//  Pharmacy
//
//  Created by osx on 24/01/20.
//  Copyright © 2020 osx. All rights reserved.
//

import UIKit
import SDWebImage
import SocketIO

@available(iOS 13.0, *)
class OrderDetailsVC: UIViewController {
    
    // tables outlets
    @IBOutlet var orderDetailTable: UITableView!
    @IBOutlet var cancelTable: UITableView!
    
    // collection table outlets
    @IBOutlet var orderDetailCollection: UICollectionView!
    
    // texfields outkets
    @IBOutlet var txtOrderInstructions: UITextField!
    @IBOutlet var txtAddress: UITextField!
    
    // label outlets
    @IBOutlet weak var userNmae: UILabel!
    @IBOutlet var orderREceivedDate: UILabel!
    @IBOutlet weak var blinkingLbl: UILabel!
    @IBOutlet var status: UILabel!
    @IBOutlet var lblOrderNumber: UILabel!
    @IBOutlet var headerPrice: UILabel!
    
    // view outlets
    @IBOutlet var orderDetailsView: UIView!
    @IBOutlet var hiddenView: UIView!
    @IBOutlet weak var cancelationView: UIView!
    @IBOutlet weak var tableData: UIView!
    
    // image view outlets
    @IBOutlet var imgStatus: UIImageView!
    @IBOutlet var imgShow: UIImageView!
    
    // designable oulets
    @IBOutlet var cancelView: DesignableView!
    @IBOutlet var SureCancelView: DesignableView!
    @IBOutlet weak var superviewForshadow: DesignableView!
    
    // scroll outlet
    @IBOutlet var scrollView: UIScrollView!
    
    // constraints outlets
    @IBOutlet var tableHeight: NSLayoutConstraint!
    @IBOutlet var superViewHeight: NSLayoutConstraint!
    @IBOutlet var collectionHeight: NSLayoutConstraint!
    @IBOutlet var orderInstTOp: NSLayoutConstraint!
    @IBOutlet var quantityTrailing: NSLayoutConstraint!
    @IBOutlet weak var cancelData: NSLayoutConstraint!
    
    // properties
    var imgArr = [String]()
    var nameArr = NSArray()
    var qtyArr = NSArray()
    var priceArr = NSArray()
    var cancelArr = NSArray()
    var StatusVal = ""
    var assignedPharmacyArr = NSArray()
    var tapGesture = UITapGestureRecognizer()
    var requestId = Int()
    var medicineStruct = [MedicineModel]()
    var filteredResult = [MedicineModel]()
    var ordernumber = ""
    var username = ""
    
    //MARK:-Life cycle methods
    override func viewDidLoad(){
        super.viewDidLoad()
        
        self.title = "Order Details"
        print(username)
        
        ConnectSocket.shared.addHandler()
        ConnectSocket.shared.connectSocket()
        
        self.getOrderDetailAPI()
        
        self.lblOrderNumber.text = ordernumber

        self.initialSetup()
       
        self.navigationController?.isNavigationBarHidden = true
    
    }
    
    override func viewWillAppear(_ animated: Bool){
        setUpBackButtonNav()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    //MARK:-Class extra fuctions
    func initialSetup(){
        
        self.hideViews()
        self.tableDelegates()
        self.gesture()
        self.viewShadows()
    }
    
    func hideViews(){
        tableData.isHidden = true
        hiddenView.isHidden = true
        cancelationView.isHidden = false
        hiddenView.isUserInteractionEnabled = true
        SureCancelView.isHidden = true
    }
    
    func tableDelegates(){
        orderDetailTable.delegate = self
        orderDetailTable.dataSource = self
        orderDetailCollection.delegate = self
        orderDetailCollection.dataSource = self
        cancelTable.delegate = self
        cancelTable.dataSource = self
        
        orderDetailTable.separatorStyle = .none

    }
    
    func gesture(){
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(OrderDetailsVC.handleTap(sender:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        hiddenView.addGestureRecognizer(tapGesture)
    }
        
    @objc func handleTap(sender: UITapGestureRecognizer? = nil){
        tableData.isHidden = true
        hiddenView.isHidden = true
        imgShow.isHidden = true
        cancelationView.isHidden = false
        SureCancelView.isHidden = true
        cancelData.constant = 120
    }
    
    func viewShadows(){
        cancelData.constant = 120
        superviewForshadow.layer.shadowColor = UIColor.black.cgColor
        superviewForshadow.layer.shadowOpacity = 0.5
        superviewForshadow.layer.shadowOffset = .zero
        superviewForshadow.layer.shadowRadius = 1
        imgShow.isHidden = true
    }
    
    //MARK:- Actions
    
    @IBAction func accept(_ sender: UIButton){
        self.AcceptOrderAPI()
    }
    
    @IBAction func decline(_ sender: UIButton) {
             cancelView.isHidden = false
             tableData.isHidden = false
             cancelData.constant = 300
             
             // hiddenView.isHidden = false
             cancelReason()
         }
    
    @IBAction func btnNo(_ sender: UIButton) {
        SureCancelView.isHidden = true
            //hiddenView.isHidden = true
        cancelData.constant = 120
            //cancelView.isHidden = true
        tableData.isHidden = true
        cancelationView.isHidden = false
    }

    
    @IBAction func btnYes(_ sender: UIButton) {
        self.CancelOrderAPI()
    }
    
    
   
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.navigationController?.isNavigationBarHidden = false
        
        return false
    }
    
  
    @IBAction func buttonDownload(_ sender: UIButton) {
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
                                // self.hiddenView.isHidden = true
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
    
    @IBAction func buttonView(_ sender: UIButton) {
        self.hiddenView.isHidden = false
        imgShow.isHidden = false
        cancelationView.isHidden = false
        for i in 0..<imgArr.count{
            let imgURL = imgArr[i]
            self.imgShow.sd_setImage(with: URL(string:imgURL), completed: nil)
            
        }
    }
    
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        return imgShow
    }
    
    func getOrderDetailAPI(){
        self.showProgress()
        let prams : [String : Any] = ["request_id":requestId]
        NetworkingService.shared.getData_HeaderParameter(PostName: Constants.kGetOrderDetail, parameters: prams ){ (resp) in
            let res = resp as! NSDictionary
            print(resp)
            let dataArr = (res.value(forKeyPath: "data") as? NSArray ?? [])
            let prescr = dataArr.value(forKey: "precription") as! NSArray
            let prescrIndex = prescr[0] as? NSArray
            self.imgArr = prescrIndex?.value(forKey: "pre_image") as? [String] ?? []
            print(self.imgArr)
            
            if self.imgArr.count == 0{
                self.collectionHeight.constant = 0
            }
            let medicineArr = dataArr.value(forKey: "medicine") as! NSArray
            let medIndex = medicineArr[0] as! NSArray
            var newMedIndex = medicineArr[0] as! NSArray
            self.nameArr = medIndex.value(forKey: "medicine_name") as! NSArray
            
            print(self.tableHeight.constant)
            self.qtyArr = medIndex.value(forKey: "quantity") as! NSArray
            self.priceArr = medIndex.value(forKey: "price") as! NSArray
            let txtOrder = dataArr.value(forKey: "instruction") as! NSArray
            self.assignedPharmacyArr = (medIndex.value(forKey: "assigned_pharmacy") as! NSArray)
            
            for i in 0..<medIndex.count{
                self.medicineStruct.append(MedicineModel(assigned_pharmacy: "\((medIndex[i] as AnyObject).value(forKey: "assigned_pharmacy")  ?? "")", medicine_id:  "\((medIndex[i] as AnyObject).value(forKey: "id")  ?? "")", medicine_name:  "\((medIndex[i] as AnyObject).value(forKey: "medicine_name")  ?? "")", price: "\((medIndex[i] as AnyObject).value(forKey: "price")  ?? "")", quantity: "\((medIndex[i] as AnyObject).value(forKey: "quantity")  ?? "")",showDeleteButton: "no",showCheck:"no"))
            }
                        
            self.filteredResult = self.medicineStruct.filter{$0.assigned_pharmacy == "\(UserDefaults.standard.value(forKey: Constants.kUserID)!)"}
            
            self.tableHeight.constant = CGFloat(self.nameArr.count * 40)
            let txtAddress = dataArr.value(forKey: "address") as! NSArray
            self.txtAddress.text = (txtAddress[0] as! String)
            if (txtOrder[0] as! String) == "" {
               // self.orderInstTOp.constant = 5
                self.txtOrderInstructions.text = "No Instructions"
                self.txtOrderInstructions.isUserInteractionEnabled = false
               // self.orderDetailsView.isHidden = true
            }else {
                self.txtOrderInstructions.text =  (txtOrder[0] as! String)
            }
            let createdAt = dataArr.value(forKey: "created_at") as! NSArray
            self.orderREceivedDate.text =  (createdAt[0] as! String)
            var myDate:String = self.orderREceivedDate.text ?? ""
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
            self.orderREceivedDate.text = "Order Received: " + convertedLocalTime
            let statuus = dataArr.value(forKey: "status") as! NSArray
            self.status.text =  (statuus[0] as! String)
            let Status = dataArr.value(forKey: "status") as! NSArray
            
            self.StatusVal =  (Status[0] as! String)
            if  self.StatusVal == "pending"{
                self.imgStatus.image = #imageLiteral(resourceName: "pending")
                self.status.textColor = .systemYellow
                
                // self.blinkingLbl.isHidden = true
                
            }
            else if self.StatusVal == "accepted"{
                self.imgStatus.image = #imageLiteral(resourceName: "accepted")
                //  self.userNmae.text = self.username
                self.cancelationView.isHidden = true
                // self.blinkingLbl.startBlink()
                
                
                self.status.textColor = Constants.DARK_Green
            }
            else if self.StatusVal == "ongoing"{
                
                self.imgStatus.image = #imageLiteral(resourceName: "ongoing")
                self.status.textColor = .systemGreen
            }
            else if self.StatusVal == "in-process"
            {
                self.imgStatus.image = #imageLiteral(resourceName: "inprogress-1")
                
                self.status.textColor = .blue
            }
            self.orderDetailTable.reloadData()
            self.orderDetailCollection.reloadData()
            self.navigationController?.isNavigationBarHidden = false
            self.superViewHeight.constant = self.collectionHeight.constant + self.tableHeight.constant + 70
            self.hideProgress()
        }
        
    }
    
    func cancelReason(){
        self.showProgress()
        let   prams : [String : Any]  = ["cancel_type":"pharmacy"]
        NetworkingService.shared.getData_HeaderParameter(PostName: Constants.kcancelReason, parameters: prams ){ (resp) in
            let res = resp as! NSDictionary
            print(resp)
            let dataArr = (res.value(forKeyPath: "data") as? NSArray ?? [])
            self.cancelArr = dataArr.value(forKey: "comment") as! NSArray
            self.cancelTable.reloadData()
            self.hideProgress()
        }
    }
    func AcceptOrderAPI(){
        
        
        self.acceptSocket()
        

    }
        
    func acceptSocket(){
        
        let object = UserDefaults.standard.value(forKey: Constants.kDeviceID)
        let datafield : [String:Any] = [
            "request_id":requestId,
            "token":"Bearer \(object ?? "")"
        ]
        print(datafield)
        self.showProgress()
        if  ConnectSocket.shared.socket.status == .connected {
            ConnectSocket.shared.socket.emitWithAck("accept_order", datafield).timingOut(after: 5.0) { (data) in
            print(data)
            self.hideProgress()
            let res = data as! [[String:Any]]
            if let status =  res[0]["has_data"] as? Int {
                let data = res[0]["data"] as? [[String:Any]]
                let requestId = data![0]["request_id"] as! String
                
                switch status {
                    case 1:
                        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditOrderViewController") as? EditOrderViewController {
                            viewController.requestId = Int(requestId)! 
                            viewController.username = self.username
                            viewController.ordernumber = self.ordernumber 
                            if let navigator = self.navigationController{
                                navigator.pushViewController(viewController, animated: true)
                            }
                    }
                    
                        
                       // self.navigationController?.popViewController(animated: true)
                    case 0:
                        self.alert("Alert", message:res[0]["message"] as! String)

                    default:
                        self.alert("Alert", message:res[0]["message"] as! String)
                    }
                }
            }
        }
    }
            
    func CancelOrderAPI(){
        
        self.showProgress()
        ConnectSocket.shared.cancelOrder(request_id: requestId, cancel_commentid: 2)
        DispatchQueue.main.async {
            
        let alertController = UIAlertController(title: "Title", message: "Order Cancelled", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                UIAlertAction in
                self.navigationController?.popViewController(animated: true)
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
        self.hideProgress()
        self.getOrderDetailAPI()
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
extension OrderDetailsVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == orderDetailTable {
            
            print(medicineStruct.count)
            return medicineStruct.count
        }
        
        print(cancelArr.count)
        return cancelArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == orderDetailTable {
            if let cell = orderDetailTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? orderCell {
                cell.txtName.text = medicineStruct[indexPath.row].medicine_name
                cell.txtQuantity.text = "\(medicineStruct[indexPath.row].quantity)"
                
                
                //
                return cell
            }
            return UITableViewCell()
            
        }
        else if tableView == cancelTable {
            if let cell2 = cancelTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? cancelCell {
                cell2.lblReson.text = (cancelArr[indexPath.row] as! String)
                return cell2
            }
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //hiddenView.isHidden = false
        //cancelView.isHidden = true
        
        cancelData.constant = 140
        tableData.isHidden = true
        SureCancelView.isHidden = false
        cancelationView.isHidden = true
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
}

class orderCell : UITableViewCell{
    @IBOutlet var txtName: UITextField!
    
    
    @IBOutlet weak var txtQuantity: UITextField!
    
}

@available(iOS 13.0, *)
extension OrderDetailsVC : UICollectionViewDataSource , UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(imgArr.count)
        return imgArr.count
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? orderDetailCell1 {
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
class orderDetailCell1 : UICollectionViewCell{
    
    @IBOutlet weak var buttonView: UIButton!
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var buttondownload: UIButton!
}

class cancelCell : UITableViewCell{
    
    @IBOutlet weak var lblReson: UILabel!
    
}
