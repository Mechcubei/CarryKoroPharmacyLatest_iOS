//
//  OrderHistoryViewController.swift
//  Pharmacy
//
//  Created by osx on 15/01/20.
//  Copyright © 2020 osx. All rights reserved.


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
        hiddenView.isHidden = true
        navigationItem.backBarButtonItem?.tintColor = .white
        
        self.orderStatus = ""
        self.setUptabs(hideFirstLine: false, hideSecondLine: true, hideThirdLine: true, firstLineColour:Constants.THEME_COLOR , seconLoneColour: .gray, thirdLineColour: .gray)
        
        if #available(iOS 10.0, *) {
            notificationTableView.refreshControl = refreshControl
        } else {
            notificationTableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    
    @objc private func refreshData(_ sender: Any){
        getOrderHistoryAPI()
    }
    
    func setUptabs(hideFirstLine:Bool , hideSecondLine:Bool , hideThirdLine:Bool ,  firstLineColour:UIColor , seconLoneColour:UIColor, thirdLineColour:UIColor){
        firstLine.isHidden = hideFirstLine
        secondLine.isHidden = hideSecondLine
        thirdLine.isHidden = hideThirdLine
        lblAll.textColor = firstLineColour
        lblPending.textColor =  thirdLineColour
        lblCompleted.textColor = seconLoneColour
        self.getOrderHistoryAPI()
    }
    @IBAction func btnChangeColor(_ sender: UIButton) {
        if sender.tag ==  0 {
            orderStatus = ""
            setUptabs(hideFirstLine: false, hideSecondLine: true, hideThirdLine: true, firstLineColour:Constants.THEME_COLOR , seconLoneColour: .gray, thirdLineColour: .gray)
        }
        else if sender.tag ==  1 {
            orderStatus = "cancel"
            setUptabs(hideFirstLine: true, hideSecondLine: true, hideThirdLine: false, firstLineColour:.gray , seconLoneColour: .gray, thirdLineColour: Constants.THEME_COLOR)
        }
        else if sender.tag ==  2 {
            orderStatus = "complete"
            setUptabs(hideFirstLine: true, hideSecondLine: false, hideThirdLine: true, firstLineColour: .gray, seconLoneColour: Constants.THEME_COLOR , thirdLineColour: .gray)
           
        }
    }
    func getOrderHistoryAPI(){
        self.noDataview.isHidden = true
        var prams = [String:Any]()
        prams = [
                 "list_type":orderStatus == "" ? "old" : "",
                 "order_status":orderStatus
                ]
        print(prams)
        self.showProgress()
        NetworkingService.shared.getData_HeaderParameter(PostName: Constants.KOrderSearch, parameters: prams ){ (resp) in
            self.hideProgress()
            
            let res = resp as! NSDictionary
            guard  res["has_data"] as! Int == 1 else{
                self.noDataview.isHidden = false
                self.ordernumberArr = []
                self.notificationTableView.reloadData()
                return
            }
            
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
                refreshControl.endRefreshing()
            }
            self.notificationTableView.reloadData()
        }
    }
}

@available(iOS 13.0, *)
extension OrderHistoryViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ordernumberArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? HistoryCell {
            cell.shadowView.layer.shadowRadius = 2
            cell.shadowView.layer.shadowOffset = .zero
            cell.shadowView.layer.shadowOpacity = 0.1
            let indexPath = IndexPath(item: indexPath.row, section: 0)
            self.notificationTableView.insertRows(at: [indexPath], with: .right)
            cell.txtOrderNumber.text = (ordernumberArr[indexPath.row] as? String)
            cell.lblStatus.text = (requesttypeArr[indexPath.row] as? String)
            cell.txtAddress.text = (addressArr[indexPath.row] as? String)
            cell.lblStatus.text = (requeststatusArr[indexPath.row] as? String)
           // cell.lblDate.text = (userNameArr[indexPath.row] as? String)
            cell.dateLbl.text = (dateArr[indexPath.row] as? String)
            notificationTableView.showsVerticalScrollIndicator = false
            
            cell.imgStatus.image = requeststatusArr[indexPath.row] as! String == "cancel" ?  #imageLiteral(resourceName: "cancel-1") : #imageLiteral(resourceName: "accepted")
            cell.lblStatus.textColor = requeststatusArr[indexPath.row] as! String == "cancel" ?  .red : Constants.DARK_Green
            cell.lblTotalCost.isHidden = requeststatusArr[indexPath.row] as! String == "cancel" ?  true : false
            cell.lblPrice.isHidden = requeststatusArr[indexPath.row] as! String == "cancel" ?  true : false
            cell.lblPrice.text = "\(currencies_symbolArr[indexPath.row])" + ("\(priceArr[indexPath.row] as? Int ?? 0)")
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if requeststatusArr[indexPath.row] as! String == "cancel" {
            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "inprogressView") as? inprogressView {
                viewController.requestId = requestIdArr[indexPath.row] as! Int
                viewController.ordernumber = ordernumberArr[indexPath.row] as! String
                viewController.currencies_symbol = currencies_symbolArr[indexPath.row] as? String ?? "\u{20B9}"
                viewController.name = userNameArr[indexPath.row] as! String
                viewController.priceValue = amountArray[indexPath.row] as! Double
                viewController.address = self.addressArr[indexPath.row] as! String
                if let navigator = self.navigationController{
                    navigator.pushViewController(viewController, animated: true)
                }
            }
        }else
            if requeststatusArr[indexPath.row]  as! String == "complete"{
                if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ongoingVc") as? ongoingVc {
                    viewController.requestId = requestIdArr[indexPath.row] as! Int
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
