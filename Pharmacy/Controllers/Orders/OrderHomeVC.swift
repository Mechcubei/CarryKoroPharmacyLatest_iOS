
//  OrderHomeVC.swift
//  Pharmacy
//
//  Created by osx on 28/01/20.
//  Copyright © 2020 osx. All rights reserved.


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
    
    @IBOutlet var noDataview: UIView!
    @IBOutlet var firstHeightConstraint: NSLayoutConstraint!
    @IBOutlet var firstTopConstraint: NSLayoutConstraint!
    
    
    @IBOutlet var txtFromDate: UITextField!
    @IBOutlet var txtToDate: UITextField!
    @IBOutlet var fromCancelButton: UIButton!
    @IBOutlet var toCancelButton: UIButton!
    
    
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
        
        
        self.initialSetup()
        self.orderStatus = "all"
        self.setUptabs(hideFirstLine: false, hideSecondLine: true, hideThirdLine: true, hidefourthLine: true, hidefifthLine: true, firstLineColour: Constants.THEME_COLOR, seconLoneColour: .gray, thirdLineColour: .gray, fourthLineColour: .gray, fifthlineColour: .gray)
        
    }
    
    func initialSetup(){
        self.navigationItem.setHidesBackButton(true, animated: true)
        noDataview.isHidden = true
        hiddenView.isHidden = true
        datePickerOut.isHidden = true
        self.datePickerView.isHidden = true
        txtSearch.delegate = self
        
        ConnectSocket.shared.addHandler()
        ConnectSocket.shared.connectSocket()
        if #available(iOS 10.0, *) {
            orderHistoryTableView.refreshControl = refreshControl
        } else {
            orderHistoryTableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
    }
    
    func removeSelectedDate(){
        self.txtToDate.text = ""
        self.txtFromDate.text = ""
        self.setCalenderAndCanelImage(cancelFrom: false, cancelTo: false)
    }
    
    @objc private func refreshData(_ sender: Any) {
        // Fetch Weather Data
        getOrderHistoryAPI()
    }
    
    func  setCalenderAndCanelImage(cancelFrom:Bool,cancelTo:Bool) {
        self.fromCancelButton.setImage(!cancelFrom ?  UIImage(named: "calender1") : UIImage(named: "cross"), for: .normal)
        self.toCancelButton.setImage(!cancelTo ?   UIImage(named: "calender1") : UIImage(named: "cross"), for: .normal)
    }
    
    func dateFromString(Date:String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/mm/yy"
        return formatter.date(from: Date)!
    }
    
    func compareDate(fromDate:String,toDate:String) -> Bool{
        let fromDate: Date =   dateFromString(Date: fromDate)  // dateFormatter.stringFromDate(date1)
        let toDate: Date =  dateFromString(Date: toDate)
        if toDate  < fromDate {
            print("to date should not greated then from date")
            return true
        }
        return false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.removeSelectedDate()
        self.getOrderHistoryAPI()
        
        firstTopConstraint.constant = 0
        firstHeightConstraint.constant = 50
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
    }
    
    @IBAction func barBtnOrderSearch(_ sender: Any) {
    }
    
    func setUptabs(hideFirstLine:Bool , hideSecondLine:Bool , hideThirdLine:Bool , hidefourthLine :Bool,hidefifthLine:Bool, firstLineColour:UIColor , seconLoneColour:UIColor, thirdLineColour:UIColor,fourthLineColour:UIColor, fifthlineColour:UIColor){
        firstLine.isHidden = hideFirstLine
        secondLine.isHidden = hideSecondLine
        thirdLine.isHidden = hideThirdLine
        inprocessLbl.isHidden = hidefourthLine
        fifthLine.isHidden = hidefifthLine
        
        lblAll.textColor = firstLineColour
        lblPending.textColor = seconLoneColour
        lblaccepted.textColor = thirdLineColour
        forthLine.textColor = fourthLineColour
        lblCompleted.textColor = fifthlineColour
        self.getOrderHistoryAPI()
        
    }
    
    
    @IBAction func btnChangeColor(_ sender: UIButton) {
        if sender.tag ==  0{
            orderStatus = "all"
            setUptabs(hideFirstLine: false, hideSecondLine: true, hideThirdLine: true, hidefourthLine: true, hidefifthLine: true, firstLineColour: Constants.THEME_COLOR, seconLoneColour: .gray, thirdLineColour: .gray, fourthLineColour: .gray, fifthlineColour: .gray)
        }  else if sender.tag ==  1 {
            orderStatus = "pending"
            setUptabs(hideFirstLine: true, hideSecondLine: false, hideThirdLine: true, hidefourthLine: true, hidefifthLine: true, firstLineColour: .gray, seconLoneColour: Constants.THEME_COLOR, thirdLineColour: .gray, fourthLineColour: .gray, fifthlineColour: .gray)
        }
        else if sender.tag ==  2 {
            orderStatus = "accepted"
            setUptabs(hideFirstLine: true, hideSecondLine: true, hideThirdLine: false, hidefourthLine: true, hidefifthLine: true, firstLineColour: .gray, seconLoneColour: .gray, thirdLineColour: Constants.THEME_COLOR, fourthLineColour: .gray, fifthlineColour: .gray)
        }else if sender.tag ==  3 {
            orderStatus = "in-process"
            setUptabs(hideFirstLine: true, hideSecondLine: true, hideThirdLine: true, hidefourthLine: false, hidefifthLine: true, firstLineColour: .gray, seconLoneColour: .gray, thirdLineColour: .gray, fourthLineColour: Constants.THEME_COLOR, fifthlineColour: .gray)
        }else if sender.tag ==  4 {
            orderStatus = "ongoing"
            setUptabs(hideFirstLine: true, hideSecondLine: true, hideThirdLine: true, hidefourthLine: true, hidefifthLine: false, firstLineColour: .gray, seconLoneColour: .gray, thirdLineColour: .gray, fourthLineColour: .gray, fifthlineColour: Constants.THEME_COLOR)
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
            if self.txtToDate.text != "" {
                guard !self.compareDate(fromDate:txtFromDate.text!,toDate: self.txtToDate.text!)  else {
                    alert("Alert", message: "To date should not be greater than from date!")
                    return
                }
            }
            
            self.setCalenderAndCanelImage(cancelFrom: true, cancelTo:  txtToDate.text == "" ? false : true)
            
            if txtToDate.text == "" {
                
                alert("Alert", message: "Also select the end date to get the detail")
                
            }else {
                
                getOrderHistoryAPI()
                
            }
        }else if comingFrom == "toDate"{
            self.txtToDate.text = strDate
            if self.txtFromDate.text != "" {
                guard !self.compareDate(fromDate:txtFromDate.text!,toDate: self.txtToDate.text!)  else {
                    alert("Alert", message: "To date should not be freater than from date")
                    return
                }
            }
            
            self.setCalenderAndCanelImage(cancelFrom: txtFromDate.text == "" ? false : true, cancelTo: true)
            
            if txtFromDate.text == "" {
                alert("Alert", message: "Also select the start date to get the detail")
            }else {
                getOrderHistoryAPI()
            }
        }
    }
    
    @IBAction func btnFromDate(_ sender: UIButton) {
        self.setDatePicker(comeFrom:"fromDate")
    }
    
    
    @IBAction func btnToDate(_ sender: UIButton) {
        self.setDatePicker(comeFrom:"toDate")
    }
    
    
    func setDatePicker(comeFrom:String){
        hiddenView.isHidden = false
        datePickerOut.isHidden = false
        self.datePickerView.isHidden = false
        self.comingFrom = comeFrom
    }
    
    @IBAction func btnFromDateCancel(_ sender: Any) {
        guard fromCancelButton.currentImage != UIImage(named: "calender1") else {
            self.setDatePicker(comeFrom:"fromDate")
            return
        }
                
        txtFromDate.text = ""
        txtToDate.text == "" ? getOrderHistoryAPI() : ()
        setCalenderAndCanelImage(cancelFrom: false, cancelTo:  txtToDate.text == "" ? false : true)
    }
    
    @IBAction func btnToDateCancel(_ sender: Any) {
        
        guard toCancelButton.currentImage != UIImage(named: "calender1") else {
            self.setDatePicker(comeFrom:"toDate")
            return
        }
        
        txtToDate.text = ""
        txtFromDate.text == "" ? getOrderHistoryAPI() : ()
        setCalenderAndCanelImage(cancelFrom: txtFromDate.text == "" ? false : true, cancelTo: false)
    }
    
    //MARK:-----------------------------------------Register API --------------------------------------------
      
    func getOrderHistoryAPI(){
        var prams = [String:Any]()
        prams = [
            "order_number": txtSearch.text!,
            "list_type": orderStatus == "all" ?  orderStatus : "" ,
            "order_status": orderStatus == "all" ? "" : orderStatus,
            "from_date" : txtFromDate.text!,
            "to_date" : txtToDate.text!
        ]
        
        print(prams)
        self.showProgress()
        NetworkingService.shared.getData_HeaderParameter2(PostName: Constants.KOrderSearch, parameters: prams ){ (resp) in
            self.hideProgress()
            let res = resp as! NSDictionary
            print(resp)
            guard res["message"] as! String !=  "No Record Found" else {
                self.ordernumberArr = []
                self.noDataview.isHidden = false
                self.orderHistoryTableView.reloadData()
                return
            }
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
                refreshControl.endRefreshing()
            }
            
            self.noDataview.isHidden = true
            self.orderHistoryTableView.reloadData()
            self.title = "Dashboard"
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
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.navigationController?.isNavigationBarHidden = false
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        comingFrom = "text"
        searchOrder =  string  //textField.text!+string
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
            
            cell.totalCost.text = "Thiru"
            
            if requeststatusArr[indexPath.row] as! String == "pending"{
                cell.imgStatus.image = #imageLiteral(resourceName: "pending")
                cell.lblStatus.textColor = .systemYellow
                cell.costView.isHidden = true
                
            }
            else if requeststatusArr[indexPath.row] as! String == "accepted"{
                cell.imgStatus.image = #imageLiteral(resourceName: "accepted")
                cell.lblStatus.textColor = Constants.DARK_Green
                cell.costView.isHidden = true
                
            }
            else if requeststatusArr[indexPath.row] as! String == "ongoing"{
                cell.imgStatus.image = #imageLiteral(resourceName: "ongoing")
                cell.lblStatus.textColor = .green
                cell.costView.isHidden = false
                cell.totalCost.text = ((currencies_symbolArr[indexPath.row] as? String)!) + ("\((amountArray[indexPath.row] as? Double)!)")
            }
            else if requeststatusArr[indexPath.row] as! String == "in-process"{
                cell.imgStatus.image = #imageLiteral(resourceName: "inprogress-1")
                cell.lblStatus.textColor = .blue
                cell.costView.isHidden = false
                cell.totalCost.text = ((currencies_symbolArr[indexPath.row] as? String)!) + ("\((amountArray[indexPath.row] as? Double)!)")
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
                viewController.requestId =  requestIdArr[indexPath.row] as! Int
                viewController.username = userNameArr[indexPath.row] as! String
                viewController.ordernumber = ordernumberArr[indexPath.row] as! String
                if let navigator = self.navigationController{
                    navigator.pushViewController(viewController, animated: true)
                }
            }
        }
        else if requeststatusArr[indexPath.row] as! String == "in-process" {
            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "inprogressView") as? inprogressView {
                viewController.requestId =  requestIdArr[indexPath.row] as! Int
                viewController.ordernumber = ordernumberArr[indexPath.row] as! String
                viewController.currencies_symbol = currencies_symbolArr[indexPath.row] as? String ?? "\u{20B9}"
                viewController.name = userNameArr[indexPath.row] as! String
                viewController.priceValue = amountArray[indexPath.row] as! Double
                viewController.address = addressArr[indexPath.row] as! String
                viewController.StatusVal = requeststatusArr[indexPath.row] as! String
                if let navigator = self.navigationController{
                    navigator.pushViewController(viewController, animated: true)
                }
            }
        }
        
        else if requeststatusArr[indexPath.row] as! String == "pickup" || requeststatusArr[indexPath.row] as! String == "ongoing" {
            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ongoingVc") as? ongoingVc {
                viewController.requestId = requestIdArr[indexPath.row] as! Int
                viewController.ordernumber = ordernumberArr[indexPath.row] as! String
                viewController.currencies_symbol = currencies_symbolArr[indexPath.row] as! String
                viewController.name = userNameArr[indexPath.row] as! String
                viewController.price = amountArray[indexPath.row] as! Double
                
                if let navigator = self.navigationController{
                    navigator.pushViewController(viewController, animated: true)
                }
            }
        } else {
            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OrderDetailsVC") as? OrderDetailsVC {
                viewController.requestId =    requestIdArr[indexPath.row] as! Int
                viewController.ordernumber = ordernumberArr[indexPath.row] as! String
                viewController.username = userNameArr[indexPath.row] as! String
                viewController.CreatedDate = (dateArr[indexPath.row] as? String)
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
    @IBOutlet weak var costView: UIView!
    
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

