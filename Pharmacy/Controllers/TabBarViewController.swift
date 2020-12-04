//
//  TabBarViewController.swift
//  TugForceDriverEnd
//
//  Created by osx on 30/09/19.
//  Copyright © 2019 osx. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)

class TabBarViewController: UIViewController, tabBarViewDelegate{
    
    //MARK:- Outkets
    @IBOutlet var barBtnImg: UIBarButtonItem!
    @IBOutlet var barBtnText: UIBarButtonItem!
    @IBOutlet var imgHome: UIImageView!
    @IBOutlet var imgCalls: UIImageView!
    @IBOutlet var imgOrders: UIImageView!
    @IBOutlet var imgProfile: UIImageView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet var buttons: [UIButton]!
    
    //MARK:- Properties
    var badgecount:Int?
        
    func addTabBarView(tap: Int){
        selectedIndex = tap
        buttons[selectedIndex].isSelected = true
        didTapOnBar(buttons[selectedIndex])
    }
    
   
    
    var FirstViewController1 = UIViewController()
    var SecondViewController = UIViewController()
    var ThirdViewController = UIViewController()
    var FourthViewController = UIViewController()
    
    var selectedIndex: Int = 0
    var viewControllers = [UIViewController]()
    
    //MARK:- Life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getNotificationCount()
        
        
        let obj = OrderHomeVC()
        // obj.callDelegate = self
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        FirstViewController1 = storyboard.instantiateViewController(withIdentifier: "OrderHomeVC")
        SecondViewController = storyboard.instantiateViewController(withIdentifier: "PaymentDetailsViewController")
        ThirdViewController = storyboard.instantiateViewController(withIdentifier: "OrderHistoryViewController")
        FourthViewController = storyboard.instantiateViewController(withIdentifier: "SettingsViewController")
        viewControllers = [FirstViewController1,SecondViewController,ThirdViewController,FourthViewController]
        //Set the Initial Tab when the App Starts.
        buttons[selectedIndex].isSelected = true
        didTapOnBar(buttons[selectedIndex])
    }
    
    //MARK:-Api
    func getNotificationCount(){
        let parms:[String:Any] = ["":""]
        NetworkingService.shared.getData_HeaderParameter(PostName: Constants.KNotificationCount, parameters: parms) { (response) in
            print(response)
            let resp = response as! NSDictionary
            let value = resp["data"] as! [String:Any]
            let count = value["total_notification"] as! Int
            self.badgecount = count
        }
    }
    
    func setUpMenuButton(){
        let menuBtn = UIButton(type: .custom)
        menuBtn.frame = CGRect(x: 0.0, y: 0.0, width: 30, height: 30)
        menuBtn.setImage(#imageLiteral(resourceName: "notification "), for: .normal)
        menuBtn.addTarget(self, action: #selector(TabBarViewController.moveToNotifications), for: UIControl.Event.touchUpInside)
        let lblBadge = UILabel.init(frame: CGRect.init(x: 20, y: 0, width: 15, height: 15))
        lblBadge.backgroundColor = Constants.THEME_COLOR
        lblBadge.clipsToBounds = true
        lblBadge.layer.cornerRadius = 7
        lblBadge.textColor = UIColor.white
        lblBadge.textAlignment = .center
        lblBadge.layer.borderWidth = 1
        lblBadge.layer.borderColor = UIColor.white.cgColor
        lblBadge.text = "\(badgecount ?? 0)"
        lblBadge.font =   lblBadge.font.withSize(10)
        
        //lblBadge.isHidden = badgecount == 0 ? true  : false
        menuBtn.addSubview(badgecount != 0 ? lblBadge : UIView())
                
        let menuBarItem = UIBarButtonItem(customView: menuBtn)
        let currWidth = menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 35)
        currWidth?.isActive = true
        let currHeight = menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 35)
        currHeight?.isActive = true
        self.navigationItem.rightBarButtonItem = menuBarItem
    }
    
    @objc func moveToNotifications(){
        print("moved")
        let vc = UIStoryboard.init(name: "Main", bundle: nil)
              let notiVC =  vc.instantiateViewController(withIdentifier: "NotificationViewController") as? NotificationViewController
        self.navigationController?.pushViewController(notiVC!, animated: true)
    }

    //MARK:- Actions
    @IBAction func didTapOnBar(_ sender: UIButton) {
        
    //Get Access to the Previous and Current Tab Button.
        
        if sender.tag == 0{
            self.title = "DashBoard"
            self.navigationController?.isNavigationBarHidden = false
            self.navigationItem.setHidesBackButton(true, animated:true)
            self.navigationItem.rightBarButtonItem = nil
            
            self.imgHome.image = #imageLiteral(resourceName: "orderhome ")
            self.imgCalls.image = #imageLiteral(resourceName: "paymentUnselected")
            self.imgOrders.image = #imageLiteral(resourceName: "historyUnselected")
            self.imgProfile.image = #imageLiteral(resourceName: "settings ")
            self.setUpMenuButton()
            
//          let button: UIButton = UIButton(type: UIButton.ButtonType.custom) as! UIButton
//          button.setImage(#imageLiteral(resourceName: "notification "), for: .normal)
//          button.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
//          let barButton = UIBarButtonItem(customView: button)
//          self.navigationItem.rightBarButtonItem = barButton
            
        } else if sender.tag == 1{
            
        self.title = "Payment"
          self.navigationController?.isNavigationBarHidden = false
            self.navigationItem.setHidesBackButton(true, animated:true)
            imgCalls.image = #imageLiteral(resourceName: "paymentSelected")
            imgOrders.image = #imageLiteral(resourceName: "historyUnselected")
            imgHome.image = #imageLiteral(resourceName: "home ")
            imgProfile.image = #imageLiteral(resourceName: "settings ")
            self.navigationItem.rightBarButtonItem = nil
            
        } else if sender.tag == 2{
            self.title = "Order History"
            self.navigationController?.isNavigationBarHidden = false
            self.navigationItem.setHidesBackButton(true, animated:true)
            
            imgOrders.image = #imageLiteral(resourceName: "HistorySelected")
            imgCalls.image = #imageLiteral(resourceName: "paymentUnselected")
            imgHome.image = #imageLiteral(resourceName: "home ")
            imgProfile.image = #imageLiteral(resourceName: "settings ")
            self.navigationItem.rightBarButtonItem = nil
            
                        
        } else if sender.tag == 3{
            self.title = "Settings"
            self.navigationController?.isNavigationBarHidden = false
            self.navigationItem.setHidesBackButton(true, animated:true)
            self.navigationItem.rightBarButtonItem = nil
            imgProfile.image = #imageLiteral(resourceName: "settings-")
            imgCalls.image = #imageLiteral(resourceName: "paymentUnselected")
            imgOrders.image = #imageLiteral(resourceName: "historyUnselected")
            imgHome.image = #imageLiteral(resourceName: "home ")
        }
        
        
        
        func EditPressed() {
            print("Share to fb")
        }
                
        
        selectedIndex = sender.tag
        let previousIndex = selectedIndex
        //Remove the Previous ViewController and Set Button State.
        buttons[previousIndex].isSelected = false
        let previousVC = viewControllers[previousIndex]
        previousVC.willMove(toParent: nil)
        previousVC.view.removeFromSuperview()
        previousVC.removeFromParent()
        //Add the New ViewController and Set Button State.
        sender.isSelected = true
        let vc = viewControllers[selectedIndex]
        addChild(vc)
        vc.view.frame = contentView.bounds
        contentView.addSubview(vc.view)
        vc.didMove(toParent: self)
    }
}


