//
//  CountryViewController.swift
//  Pharmacy
//
//  Created by osx on 14/02/20.
//  Copyright © 2020 osx. All rights reserved.
import UIKit
import SDWebImage



@available(iOS 13.0, *)
class CountryViewController: UIViewController , UITableViewDataSource, UITableViewDelegate{

    var callback : ((String) -> Void)?
    @IBOutlet weak var tableView: UITableView!
    
    //Variables
    var params = [String:Any]()
    var getCounrtyResp = [CountryModel]()
    var getCode = ""
     
    override func viewDidLoad() {
        super.viewDidLoad()
        getCountryAPI()
        print(getCounrtyResp)
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        SingletonVariables.sharedInstance.getCode = SingletonVariables.sharedInstance.getCodeArr[indexPath.row] as! String
        SingletonVariables.sharedInstance.flagImg = SingletonVariables.sharedInstance.getFlagArr[indexPath.row] as! String
        callback?(SingletonVariables.sharedInstance.getCode)
        callback?(SingletonVariables.sharedInstance.flagImg)
        self.navigationController?.popViewController(animated: true) 
    }
      
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if self.getCounrtyResp.count != 0{
            return self.getCounrtyResp.count }
        else{ return 0 }
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! countryTableCell
        cell.imgTick.isHidden = true
        let countryModelDetail =  self.getCounrtyResp[indexPath.row]
        cell.lblcountryName.text = countryModelDetail.name
        cell.lblCountryCode.text = countryModelDetail.Code
        let imgUrl = countryModelDetail.flagImg
        cell.imgView.sd_setImage(with: URL(string:imgUrl), completed: nil)
        return cell
    }
    
    //MARK:-----------------------------------------CountryCode API --------------------------------------------

    func getCountryAPI(){
        let params : [String:Any] = ["" : ""]
        NetworkingService.shared.getCountryData(PostName: Constants.kCountryDetail, parameters: params as! [String : String]){ (resp) in
            print(resp)
            let dic = resp as! NSDictionary
            print(dic)
            if (dic.value(forKey: "has_data") as? String == "0")
            {
                
                Utilities.ShowAlertView2(title: "Alert",message: dic.value(forKey: "message") as! String, viewController: self)
            }
            else
            {
                if let data = (dic.value(forKey: "data") as? NSArray)?.mutableCopy() as? NSMutableArray
                {
                    self.getCounrtyResp = [CountryModel]()
                    for index in 0..<data.count
                    {
                        self.getCounrtyResp.append(CountryModel(flagImg: "\((data[index] as AnyObject).value(forKey: "country_flag") ?? "")", name: "\((data[index] as AnyObject).value(forKey: "name") ?? "")", Code: "+" + "\((data[index] as AnyObject).value(forKey: "country_code") ?? "")", CodeName: "\((data[index] as AnyObject).value(forKey: "code2") ?? "")"))
                        SingletonVariables.sharedInstance.countryCodeName = (data.value(forKey: "code2") as? NSArray)!
                        for i in 0..<SingletonVariables.sharedInstance.countryCodeName.count {
                            let matchCountry = SingletonVariables.sharedInstance.countryCodeName[i]
                            let locale = Locale.current
                            let currentCountry = locale.regionCode!
                            if "\(matchCountry)" == "\(currentCountry)" {
                            print("hereeeyyyyecdsfsdfdsfsfsdfsdfdsfsdfdsfdsfds--------------")
                            }
                        }
                        
                        SingletonVariables.sharedInstance.getCodeArr = (data.value(forKey: "country_code") as? NSArray)!
                        SingletonVariables.sharedInstance.getFlagArr = (data.value(forKey: "country_flag") as? NSArray)!
                    }
                    self.tableView.reloadData()
                }
            }
            self.tableView.reloadData()
        }
    }
    
    
    

}

class countryTableCell: UITableViewCell {
    
    
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var lblcountryName: UILabel!
    @IBOutlet var lblCountryCode: UILabel!
    @IBOutlet var imgTick: UIImageView!
    
}
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */



