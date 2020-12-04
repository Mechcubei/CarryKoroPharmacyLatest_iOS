//
//  orderDetailHomeVC.swift
//  Pharmacy
//
//  Created by GT-Mechcubei on 4/21/20.
//  Copyright © 2020 osx. All rights reserved.
//

import UIKit
@available(iOS 13.0, *)

class orderDetailHomeVC: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    
    @IBOutlet weak var orderNumberLbl: UILabel!
    
    
    @IBOutlet weak var orderREceivedDate: UILabel!
    @IBOutlet weak var txtinstruction: UITextField!
    @IBOutlet weak var deliveryAddress: UITextField!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var statusimage: UIImageView!
    @IBOutlet weak var orderDetailTableView: UITableView!
    
    
    @IBOutlet weak var orderInstruction: UILabel!
    @IBOutlet weak var deliveryAddressLbl: UILabel!
    @IBOutlet weak var orderDetailCollectionView: UICollectionView!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        orderDetailTableView.delegate = self
        orderDetailTableView.dataSource = self
        orderDetailCollectionView.delegate = self
        orderDetailCollectionView.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    
    func getOrderDetailAPI(){
            
            medicineStruct = [MedicineModel]()
            filteredResult = [MedicineModel]()
            print(medicineStruct,filteredResult)
            
            self.showProgress()
            
            let prams : [String : Any] = ["request_id":requestId]
            NetworkingService.shared.getData_HeaderParameter(PostName: Constants.kGetOrderDetail, parameters: prams ){ (resp) in
                let res = resp as! NSDictionary
                print(resp)
                let dataArr = (res.value(forKeyPath: "data") as? NSArray ?? [])
                let prescr = dataArr.value(forKey: "precription") as! NSArray
                let prescrIndex = prescr[0] as? NSArray
                self.imgArr = prescrIndex?.value(forKey: "pre_image") as? [String] ?? []
                if self.imgArr.count == 0{
                               //self.collectionHeight.constant = 0
                 }
                let medicineArr = dataArr.value(forKey: "medicine") as! NSArray
                let medIndex = medicineArr[0] as! NSArray
                var newMedIndex = medicineArr[0] as! NSArray
                self.nameArr = medIndex.value(forKey: "medicine_name") as! NSArray
               
                //print(self.tableHeight.constant)
                self.qtyArr = medIndex.value(forKey: "quantity") as! NSArray
                self.priceArr = medIndex.value(forKey: "price") as! NSArray
                let txtOrder = dataArr.value(forKey: "instruction") as! NSArray
                self.assignedPharmacyArr = (medIndex.value(forKey: "assigned_pharmacy") as! NSArray)
                for i in 0..<medIndex.count{
                    self.medicineStruct.append(MedicineModel(assigned_pharmacy: "\((medIndex[i] as AnyObject).value(forKey: "assigned_pharmacy")  ?? "")", medicine_id:  "\((medIndex[i] as AnyObject).value(forKey: "id")  ?? "")", medicine_name:  "\((medIndex[i] as AnyObject).value(forKey: "medicine_name")  ?? "")", price: "\((medIndex[i] as AnyObject).value(forKey: "price")  ?? "")", quantity: "\((medIndex[i] as AnyObject).value(forKey: "quantity")  ?? "")",showDeleteButton: "no",showCheck:"no"))
                }
              
                self.filteredResult = self.medicineStruct.filter{$0.assigned_pharmacy == "\(UserDefaults.standard.value(forKey: Constants.kUserID)!)"}
                
                print(self.filteredResult.count)
                print(self.medicineStruct.count)
                
                
               //  self.tableHeight.constant = CGFloat(self.nameArr.count * 40)
                 let txtAddress = dataArr.value(forKey: "address") as! NSArray
                 self.deliveryAddress.text = (txtAddress[0] as! String)
                if (txtOrder[0] as! String) == "" {
                    //self.orderInstTOp.constant = 5
                    //self.orderDetailsView.isHidden = true
                }else {
                       self.orderInstruction.text =  (txtOrder[0] as! String)
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
                              self.statusimage.image = #imageLiteral(resourceName: "pending")
                              self.status.textColor = .systemYellow
                              
                          }
                          else if self.StatusVal == "accepted"{
                              self.statusimage.image = #imageLiteral(resourceName: "accepted")
                            self.status.textColor = Constants.DARK_Green
                          }
                          else if self.StatusVal == "ongoing"{
    //                        self.accept.isHidden = true
    //                          self.decline.isHidden = true
                              self.statusimage.image = #imageLiteral(resourceName: "ongoing")
                              self.status.textColor = .systemGreen
                          }
                          else if self.StatusVal == "in-process"
                          {
                              self.statusimage.image = #imageLiteral(resourceName: "inprogress-1")
    //                        self.accept.isHidden = true
    //                        self.decline.isHidden = true
                              self.status.textColor = .blue
                          }
                self.orderDetailTableView.reloadData()
                self.orderDetailCollectionView.reloadData()
                 self.navigationController?.isNavigationBarHidden = false
               // self.superViewHeight.constant = self.collectionHeight.constant + self.tableHeight.constant + 10
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


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

@available(iOS 13.0, *)
extension orderDetailHomeVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == orderDetailTableView {
         print(medicineStruct.count)
            return medicineStruct.count
        }
        return cancelArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == orderDetailTableView {
            if let cell = orderDetailTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? orderCell {
                cell.txtName.text = medicineStruct[indexPath.row].medicine_name
                cell.txtQuantity.text = "\(medicineStruct[indexPath.row].quantity)"
                cell.txtPrice.text = "\(medicineStruct[indexPath.row].price)"
                    if self.StatusVal == "pending"{
                        //self.quantityTrailing.constant = -25
                      //  cell.QuantityValTrailing.constant = 5
                        //self.headerPrice.isHidden = true
                        cell.txtPrice.isHidden = true
                    }
                return cell
            }
                return UITableViewCell()
            
        }
//        else if tableView == cancelTable {
//            if let cell2 = cancelTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? cancelCell {
//                cell2.lblReason.text = (cancelArr[indexPath.row] as! String)
//                return cell2
//            }
//        }
        return UITableViewCell()
    }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // hiddenView.isHidden = false
//         cancelView.isHidden = true
//         SureCancelView.isHidden = false
    }
    
}


class orderCell : UITableViewCell{
    @IBOutlet var txtName: UITextField!
    @IBOutlet var txtQuantity: UITextField!
    @IBOutlet var txtPrice: UITextField!
  
    //@IBOutlet var QuantityValTrailing: NSLayoutConstraint!
}

@available(iOS 13.0, *)
extension orderDetailHomeVC : UICollectionViewDataSource , UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? orderDetailCell1 {
            let imgURL = imgArr[indexPath.item]
            
            cell.imgView.sd_setImage(with: URL(string:imgURL), completed: nil)
            cell.btnView.tag = indexPath.item
            cell.btnDownload.tag = indexPath.item
           
            return cell
        }
        return UICollectionViewCell()
    }

    
}

class orderDetailCell1 : UICollectionViewCell{
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var btnDownload: UIButton!
    @IBOutlet var btnView: UIButton!
}

//class cancelCell : UITableViewCell{
//    @IBOutlet var lblReason: UILabel!
//}
