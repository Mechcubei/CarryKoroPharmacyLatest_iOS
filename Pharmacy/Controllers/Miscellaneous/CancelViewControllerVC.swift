//
//  CancelViewControllerVC.swift
//  Pharmacy
//
//  Created by GT-Mechcubei on 4/24/20.
//  Copyright © 2020 osx. All rights reserved.
//

import UIKit
import SDWebImage
 @available(iOS 13.0, *)
class CancelViewControllerVC: UIViewController {

     @IBOutlet weak var tableHeight: NSLayoutConstraint!
        @IBOutlet weak var orderDetailTableView: UITableView!
        @IBOutlet weak var scrollView: UIScrollView!
        @IBOutlet weak var orderCollectionView: UICollectionView!
        @IBOutlet weak var orderNumber: UILabel!
        @IBOutlet weak var orderInstructions: UITextField!
        @IBOutlet weak var deleveryAddress: UITextField!
        @IBOutlet weak var imgStatus: UIImageView!
        var name = ""
   var priceValue = Double()
  
        @IBOutlet weak var createdAt: UILabel!
        var price = Double()
        var totalString = [String]()
        var currencies_symbol = ""
        @IBOutlet weak var blinkingLbl: UILabel!
        
        @IBOutlet weak var status: UILabel!
        @IBOutlet weak var collectionHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var hiddenView: UIView!
    
    @IBOutlet weak var imageView: UIImageView!
    
        
        @IBOutlet weak var superviewHeight: NSLayoutConstraint!
        
       var totalArray = [Int]()
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
        var inputStr2 = [String]()
        var inputStr3 = [String]()
        var ordernumber = ""
        
        
        @IBOutlet weak var totalCost: UILabel!
        @IBOutlet weak var Gst: UILabel!
        @IBOutlet weak var subTotal: UILabel!
        @IBOutlet weak var deleveryCharge: UILabel!
        

        override func viewDidLoad() {
            super.viewDidLoad()
            orderDetailTableView.delegate = self
            orderDetailTableView.dataSource = self
            
            orderDetailTableView.reloadData()
            comingFrom = "didload"
            getOrderDetailAPI()
    //        superviewTable.layer.shadowColor = UIColor.black.cgColor
    //        superviewTable.layer.shadowOpacity = 0.5
    //        superviewTable.layer.shadowOffset = .zero
          //  superviewTable.layer.shadowRadius = 2
          //  self.title = "Edit Order Details"
            
            
            self.orderNumber.text = ordernumber
            orderCollectionView.delegate = self
            orderCollectionView.dataSource = self
            
            hiddenView.isHidden = true
            imageView.isHidden = true
            tapGesture = UITapGestureRecognizer(target: self, action: #selector(CancelViewControllerVC.handleTap(sender:)))
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
                   print(self.imgArr.count)
                   
                   if self.imgArr.count == 0{
                                             self.collectionHeight.constant = 0
                       //self.addMoreView.isHidden = true
                                         }
                   self.orderCollectionView.reloadData()
                   
                   var medicineArr = dataArr.value(forKey: "medicine") as! NSArray
                   let medIndex = medicineArr[0] as! NSArray
                   self.nameArr = medIndex.value(forKey: "medicine_name") as! NSArray
                   for i in 0..<medIndex.count{
                       self.medicineStruct.append(MedicineModel(assigned_pharmacy: "\((medIndex[i] as AnyObject).value(forKey: "assigned_pharmacy")  ?? "")", medicine_id:  "\((medIndex[i] as AnyObject).value(forKey: "id")  ?? "")", medicine_name:  "\((medIndex[i] as AnyObject).value(forKey: "medicine_name")  ?? "")", price: "\((medIndex[i] as AnyObject).value(forKey: "price")  ?? "")", quantity: "\((medIndex[i] as AnyObject).value(forKey: "quantity")  ?? "")",showDeleteButton: "no",showCheck:"no"))
                       print(self.medicineStruct)
                    
                    let quantity = Int(self.medicineStruct[i].quantity)
                                   let price = Int(self.medicineStruct[i].price)
                                   let tax = Int(quantity!*price!)
                                   print(tax)
                                  
                                   self.totalArray.append(tax)
                                   
                                   self.totalString = self.totalArray.map { String($0) }
                                  
                                   print(self.totalArray)

                                   let total = self.totalArray.reduce(0, +)
                                   
                                   self.subTotal.text = "\(total)"
                    
                       
                       print(self.medicineStruct.count)
                   }
                   self.tableHeight.constant = CGFloat(self.nameArr.count * 50)
                   print(self.tableHeight.constant)
                   self.orderDetailTableView.reloadData()
                    
                   self.qtyArr = medIndex.value(forKey: "quantity") as! NSArray
                   self.priceArr = medIndex.value(forKey: "price") as! NSArray
                   let txtOrder = dataArr.value(forKey: "instruction") as! NSArray
                   self.orderInstructions.text =  (txtOrder[0] as! String)
                   let txtAddress = dataArr.value(forKey: "address") as! NSArray
                   self.deleveryAddress.text =  (txtAddress[0] as! String)
                   let createdAt = dataArr.value(forKey: "created_at") as! NSArray
                
                let totalValue = self.price
                let total = (totalValue*100).rounded()/100
                self.totalCost.text = self.currencies_symbol+"\(total)"
                
                
                if total <= 500{
                    let deleveryCharge = 50
                    print(self.totalArray)

                   let subtotal = self.totalArray.reduce(0, +)
                    
                    self.deleveryCharge.text = self.currencies_symbol+"\(deleveryCharge)"
                    let subTot = Int(total) - deleveryCharge-subtotal
                    let total = "\(subTot)"
                    print(total)
                    
                    self.Gst.text = "\(total)"
                    
                    
                }else{
                    let deleveryCharge = 0
                    self.deleveryCharge.text = self.currencies_symbol+"\(deleveryCharge)"
                    
                    print(self.totalArray)

                     let subtotal = self.totalArray.reduce(0, +)
                    
                    self.deleveryCharge.text = self.currencies_symbol+"\(deleveryCharge)"
                    let subTot = Int(total) - deleveryCharge-subtotal
                    let total = "\(subTot)"
                    print(total)
                    
                    self.Gst.text = "\(total)"
                    
                }
                
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
                   self.status.textColor =  .green
                   self.createdAt.text = "Order Received: " + convertedLocalTime
                   let statuus = dataArr.value(forKey: "status") as! NSArray
                   self.status.text =  (statuus[0] as! String)
                   self.orderCollectionView.reloadData()
                      self.superviewHeight.constant = self.collectionHeight.constant + self.tableHeight.constant + 150
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
    extension CancelViewControllerVC : UITableViewDelegate , UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            print(medicineStruct.count)
            return medicineStruct.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if let cell = orderDetailTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? OngoingCell {
                  
                    cell.txtName.text = medicineStruct[indexPath.row].medicine_name
                    cell.txtQuantity.text = medicineStruct[indexPath.row].quantity
                    cell.txtPrice.text = medicineStruct[indexPath.row].price
                //cell.pricetxt.text = totalString[indexPath.row]
        
                    cell.txtName.delegate = self
                    cell.txtName.addTarget(self, action: #selector(GetValue_textFieldDidChange), for: .editingChanged)
                    cell.txtQuantity.delegate = self
                    cell.txtQuantity.addTarget(self, action: #selector(GetValue_textFieldDidChange2), for: .editingChanged)
                    cell.txtPrice.delegate = self
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
            //  self.medicineStruct.append(MedicineModel(assigned_pharmacy: "", id:  "", medicine_name:  value, price: "", quantity: "",showDeleteButton: "yes",showCheck:"yes"))
            
        }
        
        func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
            self.navigationController?.isNavigationBarHidden = false

            return false
        }
        
        @objc func GetValue_textFieldDidChange2(textfield: UITextField) {
            let value = ("TextField \(String(describing: textfield.text)) Tag : \(textfield.tag)")
            //self.medicineStruct.append(MedicineModel(assigned_pharmacy: "", id:  "", medicine_name:  "", price: "", quantity: value,showDeleteButton: "yes",showCheck:"yes"))
        }
        @objc func GetValue_textFieldDidChange3(textfield: UITextField) {
            let value = ("TextField \(String(describing: textfield.text)) Tag : \(textfield.tag)")
            // self.medicineStruct.append(MedicineModel(assigned_pharmacy: "", id:  "", medicine_name:  "", price: "", quantity: value,showDeleteButton: "yes",showCheck:"yes"))
        }
        
    }



    @available(iOS 13.0, *)
    extension CancelViewControllerVC : UICollectionViewDataSource , UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
       
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            
            print(imgArr.count)
            return imgArr.count
        }
        
        
       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            if let cell = orderCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? OngoingCellCollection {
                let imgURL = imgArr[indexPath.row]
                
            cell.imgView.sd_setImage(with: URL(string:imgURL), completed: nil)
//                cell.btnView.tag = indexPath.row
//                cell.btnDownload.tag = indexPath.row
//               
                return cell
            }
            return UICollectionViewCell()
        }

        
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{

            return CGSize(width: 80,height: 90)
        }
        

        
        
    }


    class CancelCell : UITableViewCell{
        @IBOutlet var txtName: UITextField!
        @IBOutlet var txtQuantity: UITextField!
        @IBOutlet weak var pricetxt: UITextField!
        @IBOutlet var txtPrice: UITextField!
      
        @IBAction func NotEditing(_ sender: UITextField) {
            
            self.txtPrice.endEditing(false)
            
        }
        @IBAction func stopEditing(_ sender: UITextField) {
            
             self.pricetxt.endEditing(false)
            
        }
}


    class CancelCellCollection : UICollectionViewCell{
        @IBOutlet var imgView: UIImageView!
        @IBOutlet var btnDownload: UIButton!
        @IBOutlet var btnView: UIButton!
    }



