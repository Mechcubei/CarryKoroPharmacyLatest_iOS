//
//  OrderHomeVC.swift
//  Pharmacy
//
//  Created by osx on 28/01/20.
//  Copyright © 2020 osx. All rights reserved.
//

import UIKit
import Alamofire

protocol tabBarViewDelegate: class {
    func addTabBarView(tap:Int)
}
@available(iOS 13.0, *)
@available(iOS 12.0, *)
class OrderHomeVC: UIViewController {
    
    @IBOutlet weak var orderCollectionView: UICollectionView!
    @IBOutlet weak var fifthLine: UILabel!
    @IBOutlet weak var inprocessLbl: UILabel!
    @IBOutlet var orderHistoryTableView: UITableView!
    @IBOutlet var firstLine: UILabel!
    @IBOutlet var secondLine: UILabel!
    @IBOutlet var thirdLine: UILabel!
    @IBOutlet var txtSearch: UITextField!
    @IBOutlet var lblAll: UILabel!
    @IBOutlet var lblCompleted: UILabel!
    @IBOutlet var forthLine: UILabel!
    @IBOutlet var lblPending: UILabel!
    @IBOutlet var datePickerOut: UIDatePicker!
    @IBOutlet var hiddenView: UILabel!
    @IBOutlet var lblaccepted: UILabel!
    @IBOutlet var datePickerView: UIView!
    @IBOutlet var txtFromDate: UITextField!
    @IBOutlet var txtToDate: UITextField!
    @IBOutlet var noDataview: UIView!
    @IBOutlet var firstHeightConstraint: NSLayoutConstraint!
    @IBOutlet var firstTopConstraint: NSLayoutConstraint!
    let headerViewMaxHeight: CGFloat = 50
    let headerViewMinHeight: CGFloat = 0
    var addressArr  = NSArray()
    var requestIdArr =  NSArray()
    var userNameArr = NSArray()
    var requeststatusArr = NSArray()
    var requesttypeArr = NSArray()
    var InstructionArr = NSArray()
    var ordernumberArr = NSArray()
    var medicinecountArr = NSArray()
    var amountArray = NSArray()
    var dateArr = NSArray()
   var currencies_symbolArr =  NSArray()
    var homeVM = OrderHomeViewModel()
    var searchOrder = ""
    var comingFrom = ""
    var orderStatus = ""
    var ischecked : Bool = true
    var lastContentOffset: CGFloat = 0
    var rows = 0
    var nameArray = ["ALL ORDERS","PENDING","ACCEPTED","IN-PROCESS","ONGOING"]
    
    //MARK:- Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noDataview.isHidden = true
        orderStatus = "all"
        hiddenView.isHidden = true
        datePickerOut.isHidden = true
        self.datePickerView.isHidden = true
      
        self.navigationItem.setHidesBackButton(true, animated: true)
        // self.navigationController?.isNavigationBarHidden = false
        
        txtSearch.delegate = self

        firstLine.isHidden = false
        secondLine.isHidden = true
        thirdLine.isHidden = true
        lblAll.textColor = Constants.THEME_COLOR
        lblPending.textColor = .gray
        lblCompleted.textColor = .gray
        lblaccepted.textColor  = .gray
        inprocessLbl.isHidden = false
        forthLine.textColor = .gray
        fifthLine.isHidden = true
        inprocessLbl.isHidden = true
        forthLine.textColor = .gray
                       
        ConnectSocket.shared.addHandler()
        ConnectSocket.shared.connectSocket()
        
       // self.updatedList()
        
        if #available(iOS 10.0, *) {
            orderHistoryTableView.refreshControl = refreshControl
        } else {
            orderHistoryTableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        
        // lblTransit.textColor = .gray
        // Do any additional setup after loading the view.
    }
    
    @objc private func refreshData(_ sender: Any) {
        // Fetch Weather Data
         getOrderHistoryAPI()
        parmacyUpdateList()
        edit_request_pharmacytopharmacy()
        callPharmacyListener()
    }
        
    override func viewWillAppear(_ animated: Bool) {
        
        self.getOrderHistoryAPI()
        
        firstTopConstraint.constant = 0
        firstHeightConstraint.constant = 50
        //self.navigationController?.isNavigationBarHidden = false
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
    }
    
    @IBAction func barBtnOrderSearch(_ sender: Any) {
                
    }
            
    @IBAction func btnChangeColor(_ sender: UIButton) {
        if sender.tag ==  0{
            firstLine.isHidden = false
            secondLine.isHidden = true
            thirdLine.isHidden = true
            lblAll.textColor = Constants.THEME_COLOR
            lblPending.textColor = .gray
            lblCompleted.textColor = .gray
            lblaccepted.textColor  = .gray
            inprocessLbl.textColor = .gray
            orderStatus = "all"
            inprocessLbl.isHidden = true
            fifthLine.isHidden = true
            inprocessLbl.isHidden = true
            forthLine.textColor = .gray
            
          getOrderHistoryAPI()
          
        }
        else if sender.tag ==  1 {
            firstLine.isHidden = true
            secondLine.isHidden = false
            thirdLine.isHidden = true
            lblAll.textColor = .gray
            lblCompleted.textColor = .gray
            lblPending.textColor = Constants.THEME_COLOR
            lblaccepted.textColor  = .gray
            inprocessLbl.isHidden = true
            fifthLine.isHidden = true
            inprocessLbl.textColor = .gray
            orderStatus = "pending"
            getOrderHistoryAPI()
           

        }
        else if sender.tag ==  2 {
            firstLine.isHidden = true
            secondLine.isHidden = true
            inprocessLbl.isHidden = true
            lblAll.textColor = .gray
            lblCompleted.textColor = .gray
            lblaccepted.textColor = Constants.THEME_COLOR
            lblPending.textColor  = .gray
            thirdLine.isHidden = false
            forthLine.textColor = .gray
            fifthLine.isHidden = true
            inprocessLbl.textColor = .gray
            orderStatus = "accepted"
            getOrderHistoryAPI()
          

        }
        else if sender.tag ==  3 {
            firstLine.isHidden = true
            secondLine.isHidden = true
            forthLine.isHidden = false
            lblAll.textColor = .gray
            lblCompleted.textColor = .gray
            lblaccepted.textColor = .gray
            forthLine.textColor =  Constants.THEME_COLOR
            orderStatus = "in-process"
            fifthLine.isHidden = true
            thirdLine.isHidden = true
            inprocessLbl.isHidden = false
            getOrderHistoryAPI()
           

        }
        
        else if sender.tag ==  4 {
                   firstLine.isHidden = true
                   secondLine.isHidden = true
                inprocessLbl.isHidden = true
                   lblAll.textColor = .gray
                   lblCompleted.textColor = Constants.THEME_COLOR
                  lblaccepted.textColor = .gray
                   orderStatus = "ongoing"
                 forthLine.textColor = .gray
                   thirdLine.isHidden = true
                fifthLine.isHidden = false
                   getOrderHistoryAPI()
                  

               }
        
        
    }
    
    @IBAction func datePickerChanged(_ sender: Any) {
        
    }
    
    @IBAction func btnCancelDate(_ sender: Any) {
        hiddenView.isHidden = true
        datePickerOut.isHidden = true
        self.datePickerView.isHidden = true
        if comingFrom == "fromDate"{
            self.txtFromDate.text = ""
            getOrderHistoryAPI()
        }else if comingFrom == "toDate"{
            self.txtToDate.text = ""
            getOrderHistoryAPI()
             

        }
        
    }
    
    @IBAction func btnDateDone(_ sender: Any) {
        hiddenView.isHidden = true
        datePickerOut.isHidden = true
        self.datePickerView.isHidden = true
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        let strDate = dateFormatter.string(from: datePickerOut.date)
        if comingFrom == "fromDate"{
            self.txtFromDate.text = strDate
            if txtToDate.text == "" {
                alert("Alert", message: "Also select the end date to get the detail")
            }else {
                getOrderHistoryAPI()
                parmacyUpdateList()
                edit_request_pharmacytopharmacy()
                callPharmacyListener()

            }
        }else if comingFrom == "toDate"{
            self.txtToDate.text = strDate
            if txtFromDate.text == "" {
                alert("Alert", message: "Also select the start date to get the detail")
            }
            getOrderHistoryAPI()
            

        }
    }
    
    @IBAction func btnFromDate(_ sender: UIButton) {
        comingFrom = "fromDate"
        hiddenView.isHidden = false
        datePickerOut.isHidden = false
        self.datePickerView.isHidden = false
    }
    
    @IBAction func btnToDate(_ sender: UIButton) {
        comingFrom = "toDate"
        hiddenView.isHidden = false
        datePickerOut.isHidden = false
        self.datePickerView.isHidden = false
        
    }
    
    //MARK:-----------------------------------------Register API --------------------------------------------
   func parmacyUpdateList(){
     ConnectSocket.shared.socket.on("add_request_pharmacy") { (response, ack) in
        print(response)
    }
    
    }
    
    func callPharmacyListener(){
        ConnectSocket.shared.socket.on("call_request_pharmacy") { (response, ack) in
           print(response)
       }
       
       }
    
       
    func edit_request_pharmacytopharmacy(){
        ConnectSocket.shared.socket.on("edit_request_pharmacytopharmacy") { (response, emitter) in
            print(response)
        }
    }
    
    
       
    
    func getOrderHistoryAPI(){
        var prams = [String:Any]()
        if orderStatus == "all" {
            if comingFrom == "text" {
                prams = ["order_number":searchOrder,"list_type":"all","order_status":""]
            }
            else if comingFrom == "fromDate" {
                
                prams = ["from_date":self.txtFromDate.text!,"to_date":self.txtToDate.text!,"list_type":"all","order_status":""]
            }else if txtToDate.text == "" && txtFromDate.text == ""{
                prams  = ["list_type":"all","order_status":""]
            } else{
                self.showProgress()
                prams  = ["list_type":"all","order_status":""]
            }
            
        }else if orderStatus == "pending" {
            if comingFrom == "text" {
                prams = ["order_number":searchOrder,"list_type":"all","order_status":orderStatus]
            }
            else if comingFrom == "fromDate" {
                
                prams = ["from_date":self.txtFromDate.text!,"to_date":self.txtToDate.text!,"list_type":"all","order_status":orderStatus]
            }else if txtToDate.text == "" && txtFromDate.text == ""{
                prams  = ["list_type":"","order_status":orderStatus]
            } else{
                self.showProgress()
                prams  = ["list_type":"","order_status":orderStatus]
            }
        }else if orderStatus == "ongoing" {
            if comingFrom == "text" {
                prams = ["order_number":searchOrder,"list_type":"all","order_status":orderStatus]
            }
            else if comingFrom == "fromDate" {
                prams = ["from_date":self.txtFromDate.text!,"to_date":self.txtToDate.text!,"list_type":"all","order_status":orderStatus]
            }else if txtToDate.text == "" && txtFromDate.text == ""{
                prams  = ["list_type":"","order_status":orderStatus]
            } else{
                self.showProgress()
                prams  = ["list_type":"","order_status":orderStatus]
            }
            
        }
        else if orderStatus == "accepted" {
            if comingFrom == "text" {
                prams = ["order_number":searchOrder,"list_type":"all","order_status":orderStatus]
            }
            else if comingFrom == "fromDate" {
                prams = ["from_date":self.txtFromDate.text!,"to_date":self.txtToDate.text!,"list_type":"all","order_status":orderStatus]
            }else if txtToDate.text == "" && txtFromDate.text == ""{
                prams  = ["list_type":"","order_status":orderStatus]
            } else{
                self.showProgress()
                prams  = ["list_type":"","order_status":orderStatus]
            }
            
        }
        else if orderStatus == "in-process" {
                  if comingFrom == "text" {
                      prams = ["order_number":searchOrder,"list_type":"all","order_status":orderStatus]
                  }
                  else if comingFrom == "fromDate" {
                      prams = ["from_date":self.txtFromDate.text!,"to_date":self.txtToDate.text!,"list_type":"all","order_status":orderStatus]
                  }else if txtToDate.text == "" && txtFromDate.text == ""{
                      prams  = ["list_type":"","order_status":orderStatus]
                  } else{
                      self.showProgress()
                      prams  = ["list_type":"","order_status":orderStatus]
                  }
                  
              }
        
        print(prams)
        NetworkingService.shared.getData_HeaderParameter2(PostName: Constants.KOrderSearch, parameters: prams ){ (resp) in
            let res = resp as! NSDictionary
     print(resp)
            if let dic = res.value(forKeyPath: "data.order_details"){
                self.addressArr = ((dic as AnyObject).value(forKey: "address") ?? "") as! NSArray
                self.requestIdArr = ((dic as AnyObject).value(forKey: "request_id") ?? "") as! NSArray
                self.requesttypeArr = ((dic as AnyObject).value(forKey: "request_type") ?? "") as! NSArray
                self.userNameArr = ((dic as AnyObject).value(forKey: "username") ?? "") as! NSArray
                self.medicinecountArr = ((dic as AnyObject).value(forKey: "medicine_count") ?? "") as! NSArray
                self.ordernumberArr = ((dic as AnyObject).value(forKey: "order_number") ?? "") as! NSArray
                self.InstructionArr = ((dic as AnyObject).value(forKey: "instruction") ?? "") as! NSArray
                self.requeststatusArr = ((dic as AnyObject).value(forKey: "request_status") ?? "") as! NSArray
                self.dateArr = ((dic as AnyObject).value(forKey: "created_at") ?? "") as! NSArray
                
                self.amountArray = ((dic as AnyObject).value(forKey: "total") ?? "") as! NSArray
                self.currencies_symbolArr = (dic as AnyObject).value(forKey: "currencies_symbol") as! NSArray
                
                print(self.amountArray)
                self.noDataview.isHidden = true
                self.hideProgress()
                 self.parmacyUpdateList()
                self.edit_request_pharmacytopharmacy()
                self.callPharmacyListener()
               // self.orderCollectionView.reloadData()
                refreshControl.endRefreshing()
               
                
            }
            let data = res.value(forKeyPath: "data") as! NSDictionary
            //  print(data)
            if data.count == 0{
                self.ordernumberArr = []
                self.noDataview.isHidden = false
            }
            self.orderHistoryTableView.reloadData()
            self.title = "Dashboard"
           // self.navigationController?.isNavigationBarHidden = false
            self.hideProgress()
        }
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == txtSearch {
            textField.resignFirstResponder()
            return false
        }
        return true
    }
        
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        self.navigationController?.isNavigationBarHidden = false
//
//    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.navigationController?.isNavigationBarHidden = false
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        
        if string.isEmpty
        {
            comingFrom = "empty"
            txtSearch.text = String((txtSearch.text?.dropLast())!)
        }
        else
        {
            comingFrom = "text"
            searchOrder = textField.text!+string
            getOrderHistoryAPI()
        }
        getOrderHistoryAPI()
        return true
    }
    
    
}
@available(iOS 13.0, *)
extension OrderHomeVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ordernumberArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? orderHomeCell {
            // cell.shadowView.layer.shadowPath = UIBezierPath(rect: cell.shadowView.bounds).cgPath
            //if "\(String(describing: UserDefaults.standard.value(forKey: Constants.kDeviceID)))" == "\(self.medicineStruct[indexPath.row].id)" || "\(String(describing: UserDefaults.standard.value(forKey: Constants.kDeviceID)))" == "\(0)" {
            cell.shadowView.layer.shadowRadius = 2
            cell.shadowView.layer.shadowOffset = .zero
            cell.shadowView.layer.shadowOpacity = 0.1
            self.title = "Dashboard"
            self.navigationController?.isNavigationBarHidden = false
            let indexPath = IndexPath(item: indexPath.row, section: 0)
            self.orderHistoryTableView.insertRows(at: [indexPath], with: .right)
            cell.txtOrderNumber.text = (ordernumberArr[indexPath.row] as? String)
            //                    cell.txtRequestType.text = (requesttypeArr[indexPath.row] as? String)
            cell.txtAddress.text = (addressArr[indexPath.row] as? String)
            cell.lblStatus.text = (requeststatusArr[indexPath.row] as? String)
            cell.lblDate.text = (dateArr[indexPath.row] as? String)
            print(amountArray)
            
            //cell.totalCost.text = "Thiru"
            
            
            
            
            if requeststatusArr[indexPath.row] as! String == "pending"{
                cell.imgStatus.image = #imageLiteral(resourceName: "pending")
                cell.lblStatus.textColor = .systemYellow
            }
            else if requeststatusArr[indexPath.row] as! String == "accepted"{
                cell.imgStatus.image = #imageLiteral(resourceName: "accepted")
                cell.lblStatus.textColor = Constants.DARK_Green
            }
            else if requeststatusArr[indexPath.row] as! String == "ongoing"{
                cell.imgStatus.image = #imageLiteral(resourceName: "ongoing")
                cell.lblStatus.textColor = .green
            }
            else if requeststatusArr[indexPath.row] as! String == "in-process"{
                cell.imgStatus.image = #imageLiteral(resourceName: "inprogress-1")
                cell.lblStatus.textColor = .blue
            }
            var myDate:String = cell.lblDate.text ?? ""
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
            cell.lblDate.text = convertedLocalTime
            return cell
        }
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if requeststatusArr[indexPath.row] as! String == "accepted" {
            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditOrderViewController") as? EditOrderViewController {
                viewController.requestId =  Int(requestIdArr[indexPath.row] as! String)!
                viewController.username = userNameArr[indexPath.row] as! String
                viewController.ordernumber = ordernumberArr[indexPath.row] as! String
                if let navigator = self.navigationController{
                    navigator.pushViewController(viewController, animated: true)
                }
            }
        }
            else if requeststatusArr[indexPath.row] as! String == "in-process" {
                if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "inprogressView") as? inprogressView {
                    viewController.requestId =  Int(requestIdArr[indexPath.row] as! String)!
                    viewController.ordernumber = ordernumberArr[indexPath.row] as! String
                     viewController.currencies_symbol = currencies_symbolArr[indexPath.row] as? String ?? "\u{20B9}"
                    viewController.name = userNameArr[indexPath.row] as! String
               viewController.priceValue = amountArray[indexPath.row] as! Double
                    
                    if let navigator = self.navigationController{
                        navigator.pushViewController(viewController, animated: true)
                    }
                }
            }
            else if requeststatusArr[indexPath.row] as! String == "pickup" || requeststatusArr[indexPath.row] as! String == "ongoing" {
                if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ongoingVc") as? ongoingVc {
                    viewController.requestId = Int(requestIdArr[indexPath.row] as! String)!
                    viewController.ordernumber = ordernumberArr[indexPath.row] as! String
                     viewController.currencies_symbol = currencies_symbolArr[indexPath.row] as! String
                 viewController.name = userNameArr[indexPath.row] as! String
               viewController.price = amountArray[indexPath.row] as! Double
                    
                    if let navigator = self.navigationController{
                        navigator.pushViewController(viewController, animated: true)
                    }
                }
            }
            
            
//            else if requeststatusArr[indexPath.row] as! String == "ongoing" {
//                if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ongoingVc") as? ongoingVc {
//                    viewController.requestId = requestIdArr[indexPath.row] as! Int
//                    viewController.price = amountArray[indexPath.row] as! Double
//                    viewController.currencies_symbol = currencies_symbolArr[indexPath.row] as! String
//                    viewController.ordernumber = ordernumberArr[indexPath.row] as! String
//                    if let navigator = self.navigationController{
//                        navigator.pushViewController(viewController, animated: true)
//                    }
//                }
//            }
            
        else {
            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OrderDetailsVC") as? OrderDetailsVC {
                viewController.requestId =    Int(requestIdArr[indexPath.row] as! String)!
                 viewController.ordernumber = ordernumberArr[indexPath.row] as! String
                viewController.username = userNameArr[indexPath.row] as! String
                if let navigator = self.navigationController{
                    navigator.pushViewController(viewController, animated: true)
                }
            }
        }
    }
}

class orderHomeCell : UITableViewCell {
    @IBOutlet var shadowView: DesignableView!
    @IBOutlet var txtOrderNumber: UILabel!
    @IBOutlet var txtRequestType: UILabel!
    @IBOutlet var txtAddress: UILabel!
    @IBOutlet var lblStatus: UILabel!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var imgStatus: UIImageView!
    
    
    @IBOutlet weak var totalCost: UILabel!
    
    
    
}
@available(iOS 13.0, *)
extension OrderHomeVC:UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y: CGFloat = scrollView.contentOffset.y
        let newHeaderViewHeight: CGFloat = firstHeightConstraint.constant - y
        if newHeaderViewHeight > headerViewMaxHeight {
            firstHeightConstraint.constant = headerViewMaxHeight
        } else if newHeaderViewHeight < headerViewMinHeight {
            firstHeightConstraint.constant = headerViewMinHeight
        } else {
            firstHeightConstraint.constant = newHeaderViewHeight
            scrollView.contentOffset.y = 0 // block scroll view
        }
    }
    
    
}

//@available(iOS 13.0, *)
//extension OrderHomeVC : UICollectionViewDataSource , UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
//
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//
//
//        return nameArray.count
//    }
//
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OrderListing", for: indexPath) as? OrderListing
//
//        cell?.nameLbl.text = nameArray[indexPath.row]
//
//        return cell!
//
//       }
//
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
//
//        return CGSize(width: 180,height: 30)
//    }
//
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OrderListing", for: indexPath) as! OrderListing
//
//        if indexPath.item == 0{
//            if cell.isSelected == true{
//            cell.nameLbl.textColor =  UIColor.red
//            cell.firstView.backgroundColor = UIColor.red
//            orderStatus = "all"
//            getOrderHistoryAPI()
//            orderCollectionView.reloadData()
//            }
//        }else if indexPath.item == 1{
//            if cell.isSelected == true{
//            cell.nameLbl.textColor =  UIColor.red
//            cell.firstView.backgroundColor =  UIColor.red
//            orderStatus = "pending"
//            getOrderHistoryAPI()
//            orderCollectionView.reloadData()
//            }
//        }
//        else if indexPath.item == 2 {
//            if cell.isSelected == true{
//            cell.nameLbl.textColor =  UIColor.red
//            cell.firstView.backgroundColor =  UIColor.red
//            orderStatus = "accepted"
//            getOrderHistoryAPI()
//            orderCollectionView.reloadData()
//            }
//        }else if indexPath.item == 3 {
//            if cell.isSelected == true{
//            cell.nameLbl.textColor =  UIColor.red
//            cell.firstView.backgroundColor =  UIColor.red
//
//            orderStatus = "in-process"
//            getOrderHistoryAPI()
//            orderCollectionView.reloadData()
//            }
//        }
//        else if indexPath.item == 4 {
//            if cell.isSelected == true{
//            cell.nameLbl.textColor =  UIColor.red
//            cell.firstView.backgroundColor =  UIColor.red
//
//            orderStatus = "ongoing"
//            getOrderHistoryAPI()
//            orderCollectionView.reloadData()
//            }
//        }
//
//
//    }
//
//
//}
//
//class OrderListing :UICollectionViewCell {
//    @IBOutlet weak var nameLbl: UILabel!
//
//    @IBOutlet weak var firstView: UIView!
//
//    override var isSelected: Bool {
//        didSet {
//            nameLbl.textColor = .red
//        }
//    }
//
//}
