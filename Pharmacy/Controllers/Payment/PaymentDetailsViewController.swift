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
    @IBOutlet weak var onlinepayment: UILabel!
    
    @IBOutlet weak var totalCollection: UILabel!
    @IBOutlet weak var cashCollection:UILabel!
    @IBOutlet weak var onlineCollection:UILabel!
    
    var currencies_symbolArr = NSArray()
    var commissionArray = NSArray()
    
    var addressArr  = NSArray()
    var requestIdArr =  NSArray()
    var userNameArr = NSArray()
    var requeststatusArr = NSArray()
    var medicineCount = NSArray()

    
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
        
        if #available(iOS 13.4, *) {
            datePickerOut.preferredDatePickerStyle = UIDatePickerStyle.wheels
        } else {
            // Fallback on earlier versions
        }
        
        
        hiddenView.isHidden = true
        datePickerOut.isHidden = true
        self.datePickerView.isHidden = true
        
        // get payments details
        comingFrom = "payment"
        self.setUptabs(hideFirstLine: false, hideSecondLine: true, hideThirdLine: true, firstLineColour:Constants.THEME_COLOR , seconLoneColour: .gray, thirdLineColour: .gray)
    }
    
    func setUptabs(hideFirstLine:Bool , hideSecondLine:Bool , hideThirdLine:Bool ,  firstLineColour:UIColor , seconLoneColour:UIColor, thirdLineColour:UIColor){
        firstLine.isHidden = hideFirstLine
        secondLine.isHidden = hideSecondLine
        thirdLine.isHidden = hideThirdLine
        lblAll.textColor = firstLineColour
        labelCash.textColor = seconLoneColour
        lblOnline.textColor = thirdLineColour
        self.getOrderHistoryAPI()

    }
    
    //MARK:- Actions
    @IBAction func btnCancelDate(_ sender: Any){
        hiddenView.isHidden = true
        datePickerOut.isHidden = true
        self.datePickerView.isHidden = true
        if comingFrom == "fromDate"{
            self.txtFromDate.text = ""
           // self.getOrderHistoryAPI()
        }else if comingFrom == "toDate"{
            self.txtToDate.text = ""
           // self.getOrderHistoryAPI()
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
            //self.getOrderHistoryAPI()
        }else if comingFrom == "toDate"{
            self.txtToDate.text = strDate
           // self.getOrderHistoryAPI()
        }
    }
    
    @IBAction func btnFromDate(_ sender: UIButton) {
        comingFrom = "fromDate"
        datePickerOut.isHidden = false
        self.datePickerView.isHidden = false
    }
    
    @IBAction func btnToDate(_ sender: UIButton) {
        comingFrom = "toDate"
        datePickerOut.isHidden = false
        self.datePickerView.isHidden = false
    }
    
    @IBAction func btnChangeColor(_ sender: UIButton) {
        if sender.tag ==  0 {
            comingFrom = "payment"
            setUptabs(hideFirstLine: false, hideSecondLine: true, hideThirdLine: true, firstLineColour:Constants.THEME_COLOR , seconLoneColour: .gray, thirdLineColour: .gray)
        }
        else if sender.tag ==  1 {
            comingFrom = "cash"
            setUptabs(hideFirstLine: true, hideSecondLine: false, hideThirdLine: true, firstLineColour: .gray, seconLoneColour: Constants.THEME_COLOR , thirdLineColour: .gray)
        }
        else if sender.tag ==  2 {
            comingFrom = "online"
            setUptabs(hideFirstLine: true, hideSecondLine: true, hideThirdLine: false, firstLineColour:.gray , seconLoneColour: .gray, thirdLineColour: Constants.THEME_COLOR)
        }
    }
    
    func getOrderHistoryAPI(){
        self.showProgress()
        var prams = [String:Any]()
        prams = [
                 "list_type":comingFrom,
                 "from_date": "",  //self.txtFromDate.text! == "Choose date" ? "" : self.txtFromDate.text!,
                 "to_date": "" //self.txtToDate.text!  == "Choose date" ? "" : self.txtToDate.text!
                ]
        print(prams)
        NetworkingService.shared.getData_HeaderParameter(PostName: Constants.KOrderSearch, parameters: prams ){ (resp) in
            self.hideProgress()
            print(resp)
            
            let res = resp as! NSDictionary
            guard  res["has_data"] as! Int == 1 else{
                self.ordernumberArr = []
                self.paymentTableView.reloadData()
                return
            }
            print(resp)
            let completeresponse = res["data"] as! [String:Any]
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
                self.commissionArray = ((dic as AnyObject).value(forKey: "carrykoro_commision") ?? "") as! NSArray
                self.medicineCount = ((dic as AnyObject).value(forKey: "medicine_count") ?? "") as! NSArray

            }
            let allPayments = completeresponse["allpayment"] as? Double ?? 90.89
            let allcashPayments = completeresponse["cash"] as? Double ??  90.000
            let allonlinePayments = completeresponse["online"] as? Double ??  90.000
            let totalCollection = completeresponse["pharmacy_earning"] as? Double ?? 90.89
            let cashCollections = completeresponse["pharmacy_earning_cash"] as? Double ?? 90.89
            let onlineCollections = completeresponse["pharmacy_earning_online"] as? Double ?? 90.89
            
            let total = (allPayments*100).rounded()/100
            let totalCash = (allcashPayments*100).rounded()/100
            let totalOnline = (allonlinePayments*100).rounded()/100
            let TotalCollection = (totalCollection*100).rounded()/100
            let CashCOllection = (cashCollections*100).rounded()/100
            let OnlineCollection = (onlineCollections*100).rounded()/100
            
            let currencies_symbol  = self.currencies_symbolArr[0] as? String ?? ""
            self.totalAmount.text = currencies_symbol + "\(total)"
            self.lblCash.text = currencies_symbol + "\(totalCash)"
            self.onlinepayment.text = currencies_symbol + "\(totalOnline)"
            self.totalCollection.text =  currencies_symbol +  "\(TotalCollection)"
            self.cashCollection.text =  currencies_symbol + "\(CashCOllection)"
            self.onlineCollection.text =  currencies_symbol + "\(OnlineCollection)"
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
        let indexPath = IndexPath(item: indexPath.row, section: 0)
        self.paymentTableView.insertRows(at: [indexPath], with: .right)
        cell.medicineName.text = (ordernumberArr[indexPath.row] as? String)
        cell.quantity.text =  "\((self.medicineCount[indexPath.row] as! Int))" + " medicines"
        cell.lblStatus.text = (requesttypeArr[indexPath.row] as? String)
        cell.lblLocation.text = (addressArr[indexPath.row] as? String)
        cell.lblStatus.text = (requeststatusArr[indexPath.row] as? String)
        cell.lblDate.text = (dateArr[indexPath.row] as? String)
        cell.lblCommision.text =  "Commission:" + "\(currencies_symbolArr[indexPath.row])" + "\(Float( commissionArray[indexPath.row] as! Double))"
        cell.lblAmount.text = currencies_symbolArr[indexPath.row] as! String + "\(amountArray[indexPath.row] as! Double)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ongoingVc") as? ongoingVc {
            viewController.requestId =  requestIdArr[indexPath.row] as! Int
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
        return 155
    }
}

class paymemtDetailCell : UITableViewCell{
    @IBOutlet var shadowView: DesignableView!
    @IBOutlet var medicineName: UILabel!
    @IBOutlet var quantity: UILabel!
    @IBOutlet var lblLocation: UILabel!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblStatus: UILabel!
    @IBOutlet var lblCommision: UILabel!
    @IBOutlet var lblAmount: UILabel!

    
}

