//
//  OldOrdersViewController.swift
//  Pharmacy
//
//  Created by osx on 11/02/20.
//  Copyright © 2020 osx. All rights reserved.
//

import UIKit

@available(iOS 12.0, *)
@available(iOS 13.0, *)
class OldOrdersViewController: UIViewController {

    
    @IBOutlet var paymentTableView: UITableView!
    @IBOutlet var firstLine: UIView!
    @IBOutlet var secondLine: UIView!
    @IBOutlet var thirdLine: UIView!
    @IBOutlet var lblAll: UILabel!
    @IBOutlet var lblCash: UILabel!
    @IBOutlet var lblOnline: UILabel!
     var rows = 0
    override func viewDidLoad() {
        super.viewDidLoad()
       
      
        firstLine.isHidden = false
        secondLine.isHidden = true
        thirdLine.isHidden = true
        lblAll.textColor = Constants.THEME_COLOR
        lblCash.textColor = .gray
        lblOnline.textColor = .gray
      
    }
    @IBAction func btnChangeColor(_ sender: UIButton) {
        
        if sender.tag ==  0 {
            firstLine.isHidden = false
            secondLine.isHidden = true
            thirdLine.isHidden = true
                lblAll.textColor = Constants.THEME_COLOR
                    lblCash.textColor = .gray
                    lblOnline.textColor = .gray
        }
        else if sender.tag ==  1 {
            firstLine.isHidden = true
            secondLine.isHidden = false
            thirdLine.isHidden = true
            lblCash.textColor = Constants.THEME_COLOR
            lblOnline.textColor = .gray
            lblAll.textColor = .gray
        }
        else if sender.tag ==  2 {
            firstLine.isHidden = true
            secondLine.isHidden = true
            thirdLine.isHidden = false
             lblCash.textColor = Constants.THEME_COLOR
                       lblOnline.textColor = .gray
                       lblAll.textColor = .gray
        }
     
        
        
    }
//    override func viewDidAppear(_ animated: Bool) {
//           super.viewDidAppear(animated)
//
//           //insertRowsMode2()
//           insertRowsMode3()
//       }
//    // MARK: - third way to show table
//    func insertRowsMode3() {
//        //adding logic to reset rows
//        rows = 0
//        //invoke the new insertRowMode3 function
//        insertRowMode3(ind: 0)
//    }
//
//    //Changed insertRowMode3 into recursive to gain reusability
//    //1. removed the second input of string
//    //2. removed the completion handler
//    //3. added recursive invokation
//    func insertRowMode3(ind:Int) {
//        let indPath = IndexPath(row: 1, section: 0)
//        //rows = ind + 1
//        notificationTableView.insertRows(at: [indPath], with: .right)
//
//        //add condition here if ind == ary.count-1 return
//
//        DispatchQueue.main.asyncAfter(deadline: .now()+0.02) {
//            //invoke the function itself
//            self.insertRowMode3(ind: ind+1)
//        }
//    }
    
    
}
@available(iOS 13.0, *)
extension OldOrdersViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! oldOrderDetailCell
        
        // cell.shadowView.layer.shadowPath = UIBezierPath(rect: cell.shadowView.bounds).cgPath
        cell.shadowView.layer.shadowRadius = 2
        cell.shadowView.layer.shadowOffset = .zero
        cell.shadowView.layer.shadowOpacity = 1
        let indexPath = IndexPath(item: indexPath.row, section: 0)
        self.paymentTableView.insertRows(at: [indexPath], with: .right)
        //self.notificationTableView.reloadRows(at: [(indexPath as IndexPath)], with: .left)
        return  cell
    }
}

class oldOrderDetailCell : UITableViewCell {
    
    @IBOutlet var shadowView: DesignableView!
    // @IBOutlet var btnMinus: UIButton!
    @IBOutlet var txtMedicine: UITextField!
    @IBOutlet var txtQuantity: UITextField!
}

