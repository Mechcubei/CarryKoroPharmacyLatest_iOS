//
//  NotificationViewController.swift
//  HealthCare
//
//  Created by osx on 10/01/20.
//  Copyright © 2020 osx. All rights reserved.
//

import UIKit
@available(iOS 12.0, *)
@available(iOS 13.0, *)

class NotificationViewController: UIViewController {
 
    
    @IBOutlet var notificationTableView: UITableView!
    
    //MARK:- properties
    var titleArray = [String]()
    var dateArray  = [String]()
    var descriptionArray  = [String]()
    var orderArray  = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        // read notification
        self.readNotification()
                              
        // get notifications
        self.getNotification()
        
        UIView.transition(with: notificationTableView,
                                  duration: 0.35,
                                  options: .transitionCrossDissolve,
                                  animations:
        { () -> Void in
            
            self.notificationTableView.reloadData()
        },
                                  completion: nil);
        // Do any additional setup after loading the view.
    }
    //MARK:- Api
    func readNotification(){
        
        let parms:[String:Any] = ["":""]
               NetworkingService.shared.getData_HeaderParameter(PostName: Constants.KReadNotification, parameters: parms) { (response) in
                      print(response)
        }
    }
    
    func getNotification(){
              let parms:[String:Any] = ["":""]
                  NetworkingService.shared.getData_HeaderParameter(PostName: Constants.KgetNotification, parameters: parms) { (response) in
                         print(response)
                   
                   let resp = response as! NSDictionary
                   let value = resp["data"] as! [[String:Any]]
                   
                   guard value.count > 0 else {
                       return
                   }
                                                 
                   for data in 0..<value.count{
                       self.titleArray.append(value[data]["noti_title"] as! String)
                       self.orderArray.append(value[data]["order_number"] as! String)
                       self.descriptionArray.append(value[data]["noti_body"] as! String)
                       self.dateArray.append(value[data]["updated_at"] as! String)
                   }
                   self.notificationTableView.reloadData()
               }
          }
     
}
@available(iOS 13.0, *)
extension NotificationViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NotificationTableCell
        
        
        //cell.shadowView.layer.shadowPath = UIBezierPath(rect: cell.shadowView.bounds).cgPath
        cell.shadowView.layer.shadowRadius = 2
        cell.shadowView.layer.shadowOffset = .zero
        cell.shadowView.layer.shadowOpacity = 1

        //set notification data
        cell.lblheading.text = self.titleArray[indexPath.row]
        cell.lblOrderNumber.text  = self.orderArray[indexPath.row]
        cell.lblDescription.text  = self.descriptionArray[indexPath.row]
        cell.lblDate.text  = self.dateArray[indexPath.row]
        
        return  cell
    }
}

class NotificationTableCell : UITableViewCell {
    
    @IBOutlet var shadowView: DesignableView!
    @IBOutlet var lblheading: UILabel!
    @IBOutlet var lblOrderNumber: UILabel!
    @IBOutlet var lblDescription: UILabel!
    @IBOutlet var lblDate: UILabel!

}

