//
//  PaymentDetailsViewController.swift
//  Pharmacy
//
//  Created by osx on 24/01/20.
//  Copyright © 2020 osx. All rights reserved.
//

import UIKit

@available(iOS 12.0, *)
@available(iOS 13.0, *)
class PaymentDetailsViewController: UIViewController {
    
    @IBOutlet var lblSpend: UILabel!
    @IBOutlet var paymentTableView: UITableView!
    @IBOutlet var firstLine: UIView!
    @IBOutlet var secondLine: UIView!
    @IBOutlet var thirdLine: UIView!
    @IBOutlet var lblAll: UILabel!
    @IBOutlet var lblCash: UILabel!
    @IBOutlet var lblOnline: UILabel!
    @IBOutlet var datePickerOut: UIDatePicker!
    @IBOutlet var hiddenView: UIView!
    @IBOutlet var datePickerView: UIView!
    @IBOutlet var txtFromDate: UILabel!
    @IBOutlet var txtToDate: UILabel!
    // @IBOutlet var noDataView: UIView!
    //@IBOutlet var lblCash: UILabel!
    @IBOutlet weak var totalAmount: UILabel!
    @IBOutlet weak var labelCash:UILabel!
    
    var currencies_symbolArr = NSArray()
    
    @IBOutlet weak var onlinepayment: UILabel!
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
    //var userNameArr = NSArray()
    var comingFrom = ""
    var rows = 0
    
    //MARK:-Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setIntialData()
        //self.getOrderHistoryAPI()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        // getOrderHistoryAPI()
    }
    
    //MARK:- class extra functions
    func setIntialData(){
        
        hiddenView.isHidden = true
        datePickerOut.isHidden = true
        self.datePickerView.isHidden = true
        firstLine.isHidden = false
        secondLine.isHidden = true
        thirdLine.isHidden = true
        lblAll.textColor = Constants.THEME_COLOR
        labelCash.textColor = .gray
        lblOnline.textColor = .gray
        comingFrom = "payment"
    }
    
    //MARK:- Actions
    @IBAction func btnCancelDate(_ sender: Any){
        hiddenView.isHidden = true
        datePickerOut.isHidden = true
        
        self.datePickerView.isHidden = true
        
        if comingFrom == "fromDate"{
            
            self.txtFromDate.text = ""
            
            self.getOrderHistoryAPI()
            
        }else if comingFrom == "toDate"{
            
            self.txtToDate.text = ""
            
            self.getOrderHistoryAPI()
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
            
            self.getOrderHistoryAPI()
        }else if comingFrom == "toDate"{
            
            self.txtToDate.text = strDate
            
            self.getOrderHistoryAPI()
        }
    }
    
    @IBAction func btnFromDate(_ sender: UIButton) {
        comingFrom = "fromDate"
        //hiddenView.isHidden = false
        datePickerOut.isHidden = false
        self.datePickerView.isHidden = false
    }
    
    @IBAction func btnToDate(_ sender: UIButton) {
        comingFrom = "toDate"
        // hiddenView.isHidden = false
        datePickerOut.isHidden = false
        self.datePickerView.isHidden = false
        
    }
    @IBAction func btnChangeColor(_ sender: UIButton) {
        if sender.tag ==  0 {
            firstLine.isHidden = false
            secondLine.isHidden = true
            thirdLine.isHidden = true
            lblAll.textColor = Constants.THEME_COLOR
            labelCash.textColor = .gray
            lblOnline.textColor = .gray
            comingFrom = "payment"
            
            self.getOrderHistoryAPI()
        }
        else if sender.tag ==  1 {
            firstLine.isHidden = true
            secondLine.isHidden = false
            thirdLine.isHidden = true
            labelCash.textColor = Constants.THEME_COLOR
            lblOnline.textColor = .gray
            lblAll.textColor = .gray
            comingFrom = "cash"
            
            self.getOrderHistoryAPI()
        }
        else if sender.tag ==  2 {
            
            firstLine.isHidden = true
            secondLine.isHidden = true
            thirdLine.isHidden = false
            labelCash.textColor = .gray
            lblOnline.textColor = Constants.THEME_COLOR
            lblAll.textColor = .gray
            comingFrom = "online"
            self.getOrderHistoryAPI()
        }
    }
    
    
    func getOrderHistoryAPI(){
        self.showProgress()
        var prams = [String:Any]()
        if comingFrom == "payment" {
            if comingFrom == "fromDate" {
                prams = ["from_date":self.txtFromDate.text!,"to_date":self.txtToDate.text!,"list_type":"payment"]
            }else if txtToDate.text == "" && txtFromDate.text == ""{
                prams  = ["list_type":"payment" ]
            } else{
                prams  = ["list_type":"payment" ]
            }
        }else if comingFrom == "cash"{
            if comingFrom == "fromDate" {
                prams = ["from_date":self.txtFromDate.text!,"to_date":self.txtToDate.text!,"list_type":"cash"]
            }else if txtToDate.text == "" && txtFromDate.text == ""{
                prams  = ["list_type":"cash"]
            } else{
                prams  = ["list_type":"cash"]
            }
        }else if comingFrom == "online" {
            if comingFrom == "fromDate" {
                
                prams = ["from_date":self.txtFromDate.text!,"to_date":self.txtToDate.text!,"list_type":"online"]
            }else if txtToDate.text == "" && txtFromDate.text == ""{
                prams  = ["list_type":"online"]
            } else{
                prams  = ["list_type":"online" ]
            }
        }
        
        NetworkingService.shared.getData_HeaderParameter(PostName: Constants.KOrderSearch, parameters: prams ){ (resp) in
            
            self.hideProgress()
            print(resp)
            let res = resp as! NSDictionary
            
            
            guard  res["has_data"] as! Int == 1 else{
                
                return
            }
            
            print(resp)
            
            let completeresponse = res["data"] as! [String:Any]
            let allPayments = completeresponse["allpayment"] as? Double ?? 90.89
            let allcashPayments = completeresponse["cash"] as? Double ??  90.000
            let allonlinePayments = completeresponse["online"] as? Double ??  90.000
            
            
            if let dic = res.value(forKeyPath: "data.order_details"){
                self.addressArr = ((dic as AnyObject).value(forKey: "address") ?? "") as! NSArray
                self.requestIdArr = ((dic as AnyObject).value(forKey: "request_id") ?? "") as! NSArray
                self.requesttypeArr = ((dic as AnyObject).value(forKey: "request_type") ?? "") as! NSArray
                self.userNameArr = ((dic as AnyObject).value(forKey: "username") ?? "") as! NSArray
                self.medicinecountArr = ((dic as AnyObject).value(forKey: "medicine_count") ?? "") as! NSArray
                self.userNameArr = ((dic as AnyObject).value(forKey: "username") ?? "") as! NSArray
                self.ordernumberArr = ((dic as AnyObject).value(forKey: "order_number") ?? "") as! NSArray
                self.InstructionArr = ((dic as AnyObject).value(forKey: "instruction") ?? "") as! NSArray
                self.requeststatusArr = ((dic as AnyObject).value(forKey: "payment_status") ?? "") as! NSArray
                self.dateArr = ((dic as AnyObject).value(forKey: "created_at") ?? "") as! NSArray
                self.amountArray = ((dic as AnyObject).value(forKey: "total") ?? "") as! NSArray
                self.currencies_symbolArr = (dic as AnyObject).value(forKey: "currencies_symbol") as! NSArray
                
                //self.noDataView.isHidden = true
                self.hideProgress()
            }
            
            
            let currencies_symbol  = self.currencies_symbolArr[0] as? String ?? ""
            let totalValue = allPayments
            let total = (totalValue*100).rounded()/100
            
            self.totalAmount.text = currencies_symbol + "\(total)"
            let totalCashPayment = allcashPayments
            let totalCash = (totalCashPayment*100).rounded()/100
            // self.cashPayment.text = currencies_symbol+"\(totalCash)"
            
            let totalOnlinePayment = allonlinePayments
            let totalOnline = (totalOnlinePayment*100).rounded()/100
            
            self.onlinepayment.text = currencies_symbol+"\(totalOnline)"
            
            let data = res.value(forKeyPath: "data") as! NSDictionary
            if data.count == 0{
                self.ordernumberArr = []
                
                //self.noDataView.isHidden = false
            }
            
            self.paymentTableView.reloadData()
            self.hideProgress()
        }
    }
    
}
@available(iOS 13.0, *)
extension PaymentDetailsViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ordernumberArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! paymemtDetailCell
        
        // cell.shadowView.layer.shadowPath = UIBezierPath(rect: cell.shadowView.bounds).cgPath
        cell.shadowView.layer.shadowRadius = 2
        cell.shadowView.layer.shadowOffset = .zero
        cell.shadowView.layer.shadowOpacity = 1
        let indexPath = IndexPath(item: indexPath.row, section: 0)
        self.paymentTableView.insertRows(at: [indexPath], with: .right)
        cell.medicineName.text = (ordernumberArr[indexPath.row] as? String)
        cell.lblStatus.text = (requesttypeArr[indexPath.row] as? String)
        cell.lblLocation.text = (addressArr[indexPath.row] as? String)
        cell.lblStatus.text = (requeststatusArr[indexPath.row] as? String)
        cell.lblDate.text = (dateArr[indexPath.row] as? String)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ongoingVc") as? ongoingVc {
            viewController.requestId =  Int(requestIdArr[indexPath.row] as! String)!
            viewController.price = amountArray[indexPath.row] as! Double
            viewController.name = userNameArr[indexPath.row] as! String
            viewController.currencies_symbol = currencies_symbolArr[indexPath.row] as! String
            viewController.ordernumber = ordernumberArr[indexPath.row] as! String
            
            if let navigator = self.navigationController{
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105
    }
    
    
}

class paymemtDetailCell : UITableViewCell{
    @IBOutlet var shadowView: DesignableView!
    @IBOutlet var medicineName: UILabel!
    @IBOutlet var quantity: UILabel!
    @IBOutlet var lblLocation: UILabel!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblStatus: UILabel!
    
}

