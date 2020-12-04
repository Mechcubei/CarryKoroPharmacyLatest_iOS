//
//  OrderHistoryViewController.swift
//  Pharmacy
//
//  Created by osx on 15/01/20.
//  Copyright © 2020 osx. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
@available(iOS 12.0, *)

class OrderHistoryViewController: UIViewController {
    
    @IBOutlet var secondView: DesignableView!
    @IBOutlet var firstHeightConstraint: NSLayoutConstraint!
    @IBOutlet var firstView: DesignableView!
    @IBOutlet var notificationTableView: UITableView!
    @IBOutlet var firstLine: UIView!
    @IBOutlet var secondLine: UIView!
    @IBOutlet var thirdLine: UIView!
    @IBOutlet var lblAll: UILabel!
    @IBOutlet var lblCompleted: UILabel!
    @IBOutlet var lblPending: UILabel!
    @IBOutlet var noDataview: UIView!
    @IBOutlet var datePickerOut: UIDatePicker!
    @IBOutlet var hiddenView: UIView!
    @IBOutlet var datePickerView: UIView!
    @IBOutlet var txtFromDate: UITextField!
    @IBOutlet var txtToDate: UITextField!
    @IBOutlet var txtSearch: UITextField!
    
    var amountArr = NSArray()
    
    let headerViewMaxHeight: CGFloat = 50
    let headerViewMinHeight: CGFloat = 0
    var addressArr  = NSArray()
    var requestIdArr =  NSArray()
    var requeststatusArr = NSArray()
    var requesttypeArr = NSArray()
    var ordernumberArr = NSArray()
    var userNameArr =  NSArray()
    var medicinecountArr = NSArray()
    var InstructionArr = NSArray()
    var dateArr = NSArray()
    var amountArray = NSArray()
    var currencies_symbolArr = NSArray()
    var searchOrder = ""
    var comingFrom = ""
    var orderStatus = ""
    var ischecked : Bool = true
    var priceArr = NSArray()
    var rows = 0
    
    
    // MARK:- Life cycle methods
    
    override func viewDidLoad(){
        super.viewDidLoad()
        ischecked = true
        hiddenView.isHidden = true
        datePickerView.isHidden = true
        // self.navigationController?.isNavigationBarHidden = true
        
        navigationItem.backBarButtonItem?.tintColor = .white
        firstLine.isHidden = false
        secondLine.isHidden = true
        thirdLine.isHidden = true
        lblAll.textColor = Constants.THEME_COLOR
        lblPending.textColor = .gray
        lblCompleted.textColor = .gray
        txtSearch.delegate = self
        
        if  orderStatus == "cancel" || orderStatus == "complete"{
            getOrderHistoryAPI()
        }
        
        datePickerOut.addTarget(self, action:#selector(actionForDatePicker), for: UIControl.Event.valueChanged)
        
        
        if #available(iOS 10.0, *) {
            notificationTableView.refreshControl = refreshControl
        } else {
            notificationTableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        
    }
    
    @objc private func refreshData(_ sender: Any){
        // Fetch Weather Data
        getOrderHistoryAPI()
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    
    @IBAction func barBtnOrderSearch(_ sender: Any){
        ischecked =  !ischecked
    }
            
    @IBAction func datepicker(_ sender: Any) {
        
        var todayDate = Date()
        var minimumDate = DateComponents()
        minimumDate.day = 01
        minimumDate.month = 01
        minimumDate.year = 1978
        datePickerOut.minimumDate = Calendar.current.date(from: minimumDate)
        datePickerOut.maximumDate = Date()
        
        
        
        
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
    
    
    @objc func actionForDatePicker(){
        
        
        
        //ageCountTF.text = ("\(year) years \(month) months \(date) days")
        
        
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
            getOrderHistoryAPI()
        }
        else if comingFrom == "toDate"{
            self.txtToDate.text = strDate
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
    
    @IBAction func btnChangeColor(_ sender: UIButton) {
        if sender.tag ==  0 {
            firstLine.isHidden = false
            secondLine.isHidden = true
            thirdLine.isHidden = true
            lblAll.textColor = Constants.THEME_COLOR
            lblPending.textColor = .gray
            lblCompleted.textColor = .gray
            if  orderStatus == "cancel" || orderStatus == "complete"{
                getOrderHistoryAPI()
            }
            
            
            
        }
        else if sender.tag ==  1 {
            firstLine.isHidden = true
            secondLine.isHidden = true
            thirdLine.isHidden = false
            lblAll.textColor = .gray
            lblCompleted.textColor = .gray
            lblPending.textColor =  Constants.THEME_COLOR
            orderStatus = "cancel"
            getOrderHistoryAPI()
            
        }
        else if sender.tag ==  2 {
            firstLine.isHidden = true
            secondLine.isHidden = false
            thirdLine.isHidden = true
            lblAll.textColor = .gray
            lblCompleted.textColor = Constants.THEME_COLOR
            lblPending.textColor = .gray
            orderStatus = "complete"
            getOrderHistoryAPI()
        }
        
    }
    func getOrderHistoryAPI(){
        
        self.noDataview.isHidden = true
        self.hiddenView.isHidden = true
        self.datePickerView.isHidden = true
        var prams = [String:Any]()
        if orderStatus == "old" {
            if comingFrom == "text" {
                prams = ["order_number":searchOrder,"list_type":"","order_status":""]
            }
            else if comingFrom == "fromDate" {
                
                prams = ["from_date":self.txtFromDate.text!,"to_date":self.txtToDate.text!,"list_type":"","order_status":""]
            }else if txtToDate.text == "" && txtFromDate.text == ""{
                prams  = ["list_type":"","order_status":""]
            } else{
                self.showProgress()
                prams  = ["list_type":"","order_status":""]
            }
            
        }else if orderStatus == "cancel" {
            if comingFrom == "text" {
                prams = ["order_number":searchOrder,"list_type":"","order_status":orderStatus]
            }
            else if comingFrom == "fromDate" {
                
                prams = ["from_date":self.txtFromDate.text!,"to_date":self.txtToDate.text!,"list_type":"","order_status":orderStatus]
            }else if txtToDate.text == "" && txtFromDate.text == ""{
                prams  = ["list_type":"","order_status":orderStatus]
            } else{
                self.showProgress()
                prams  = ["list_type":"","order_status":orderStatus]
            }
        }else if orderStatus == "complete"{
            if comingFrom == "text" {
                prams = ["order_number":searchOrder,"list_type":"","order_status":orderStatus]
            }
            else if comingFrom == "fromDate" {
                
                prams = ["from_date":self.txtFromDate.text!,"to_date":self.txtToDate.text!,"list_type":"","order_status":orderStatus]
            }else if txtToDate.text == "" && txtFromDate.text == ""{
                prams  = ["list_type":"","order_status":orderStatus]
            }else{
                self.showProgress()
                prams  = ["list_type":"","order_status":orderStatus]
            }
        }
        
        NetworkingService.shared.getData_HeaderParameter(PostName: Constants.KOrderSearch, parameters: prams ){ (resp) in
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
                self.priceArr = ((dic as AnyObject).value(forKey: "total") ?? "") as! NSArray
                self.dateArr = ((dic as AnyObject).value(forKey: "created_at") ?? "") as! NSArray
                self.amountArray = ((dic as AnyObject).value(forKey: "total") ?? "") as! NSArray
                
                self.amountArr = ((dic as AnyObject).value(forKey: "total") ?? "") as! NSArray
                self.currencies_symbolArr = (dic as AnyObject).value(forKey: "currencies_symbol") as! NSArray
                
                self.datePickerView.isHidden = true
                self.hideProgress()
                refreshControl.endRefreshing()
            }
            let data = res.value(forKeyPath: "data") as! NSDictionary
            print(data)
            if data.count == 0{
                self.ordernumberArr = []
                self.noDataview.isHidden = false
                self.hiddenView.isHidden = true
            }
            self.notificationTableView.reloadData()
            self.hideProgress()
        }
        self.hideProgress()
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        navigationController?.setNavigationBarHidden(false, animated: true)
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
extension OrderHistoryViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ordernumberArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? HistoryCell {
            // cell.shadowView.layer.shadowPath = UIBezierPath(rect: cell.shadowView.bounds).cgPath
            //if "\(String(describing: UserDefaults.standard.value(forKey: Constants.kDeviceID)))" == "\(self.medicineStruct[indexPath.row].id)" || "\(String(describing: UserDefaults.standard.value(forKey: Constants.kDeviceID)))" == "\(0)" {
            
            cell.shadowView.layer.shadowRadius = 2
            cell.shadowView.layer.shadowOffset = .zero
            cell.shadowView.layer.shadowOpacity = 0.1
            let indexPath = IndexPath(item: indexPath.row, section: 0)
            self.notificationTableView.insertRows(at: [indexPath], with: .right)
            cell.txtOrderNumber.text = (ordernumberArr[indexPath.row] as? String)
            cell.lblStatus.text = (requesttypeArr[indexPath.row] as? String)
            cell.txtAddress.text = (addressArr[indexPath.row] as? String)
            cell.lblStatus.text = (requeststatusArr[indexPath.row] as? String)
            cell.lblDate.text = (userNameArr[indexPath.row] as? String)
            cell.dateLbl.text = (dateArr[indexPath.row] as? String)
            notificationTableView.showsVerticalScrollIndicator = false
            var myDate:String = cell.dateLbl.text ?? ""
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
            // cell.lblDate.text = convertedLocalTime
            if (priceArr[indexPath.row] as? Int) == 0 || (priceArr[indexPath.row] as? Int) == nil {
                cell.lblTotalCost.isHidden = true
                cell.lblPrice.isHidden = true
            }else {
                cell.lblTotalCost.isHidden = false
                cell.lblPrice.isHidden = false
                cell.lblPrice.text = "\(currencies_symbolArr[0])" + ("\(priceArr[indexPath.row] as? Int ?? 0)")
            }
            if requeststatusArr[indexPath.row] as! String == "complete"{
                cell.imgStatus.image = #imageLiteral(resourceName: "completed")
                cell.lblStatus.textColor = Constants.DARK_Green
            }
            else if requeststatusArr[indexPath.row] as! String == "cancel"{
                cell.imgStatus.image = #imageLiteral(resourceName: "cancel-1")
                cell.lblStatus.textColor = .red
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        if requeststatusArr[indexPath.row] as! String == "cancel" {
            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "inprogressView") as? inprogressView {
                viewController.requestId = Int(requestIdArr[indexPath.row] as! String)!
                viewController.ordernumber = ordernumberArr[indexPath.row] as! String
                viewController.currencies_symbol = currencies_symbolArr[indexPath.row] as? String ?? "\u{20B9}"
                viewController.name = userNameArr[indexPath.row] as! String
                viewController.priceValue = amountArray[indexPath.row] as! Double
                
                if let navigator = self.navigationController{
                    navigator.pushViewController(viewController, animated: true)
                }
            }
        }else
            if requeststatusArr[indexPath.row]  as! String == "complete"{
                if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ongoingVc") as? ongoingVc {
                    viewController.requestId = Int(requestIdArr[indexPath.row] as! String)!
                    viewController.ordernumber = ordernumberArr[indexPath.row] as! String
                    viewController.currencies_symbol = currencies_symbolArr[indexPath.row] as? String ?? "\u{20B9}"
                    
                    viewController.name = userNameArr[indexPath.row] as! String
                    viewController.price = amountArr[indexPath.row] as! Double
                    
                    if let navigator = self.navigationController{
                        navigator.pushViewController(viewController, animated: true)
                    }
            }
        }
    }
}

class HistoryCell : UITableViewCell{
    @IBOutlet var shadowView: DesignableView!
    @IBOutlet var txtOrderNumber: UILabel!
    @IBOutlet var txtAddress: UILabel!
    @IBOutlet var lblStatus: UILabel!
    @IBOutlet var lblTotalCost: UILabel!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblPrice: UILabel!
    @IBOutlet var imgStatus: UIImageView!
    
    
    @IBOutlet weak var dateLbl: UILabel!
    
}

@available(iOS 13.0, *)
extension OrderHistoryViewController:UIScrollViewDelegate {
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
