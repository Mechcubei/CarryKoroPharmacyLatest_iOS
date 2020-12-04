//
//  WebService.swift
//  Tugforce
//
//  Created by osx on 06/06/19.
//  Copyright © 2019 osx. All rights reserved.
//

 
//

import Foundation
import Alamofire
import AVFoundation
import UIKit
struct Profile{
    var firstName: String
    var lastName: String
    var email: String
    var countryCode: String
    var mobileNo : String
    var profileImg : String
    var serviceTypeID : Int
    var userTypeID : Int
    var vehicleInfo:NSDictionary
    var driverInfo:NSDictionary
    var gender: String
    var vehicle_type_id:String
}
typealias JSONDictionary = [String:Any]

class NetworkingService {
    
    private init() {}
    static let shared = NetworkingService()
    
    typealias JSONDictionary = [String:Any]
    
    
    
    func getData(PostName: String,parameters: [String:Any], completion: @escaping (Any)->Void) {
        let url = URL(string:Constants.kBaseUrl+PostName)
        Alamofire.request(url!, method:.post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            switch(response.result){
            case .success(_):
                if let data = response.result.value
                {
                    print(response.result.value as Any)
                    print(data)
                    DispatchQueue.main.async {
                        completion(data)}
                }
                break
            case .failure(_):
                print(response.result.error!)
                break
            }
        }
    }
    
    
    func getData2(PostName: String,parameters: [String:String], completion: @escaping (Any)->Void){
        let url = URL(string:Constants.kBaseUrl+PostName)
        
        Alamofire.request(url!, method:.get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            switch(response.result) {
            case .success(_):
                if let data = response.result.value
                {
                    print(response.result.value as Any)
                    print(data)
                    DispatchQueue.main.async {
                        completion(data)}
                }
                break
            case .failure(_):
                print(response.result.error!)
                break
            }
        }
    }
    
    
    func getData3(PostName: String,parameters: [String:String], completion: @escaping (Any)->Void) {
        let url = URL(string:Constants.kBaseUrl+PostName)
        Alamofire.request(url!, method:.get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            switch(response.result) {
            case .success(_):
                if let data = response.result.value
                {
                    print(response.result.value as Any)
                    print(data)
                    DispatchQueue.main.async {
                        completion(data)}
                }
                break
            case .failure(_):
                print(response.result.error!)
                break
            }
        }
    }
    
    func getCountryData(PostName: String,parameters: [String:String], completion: @escaping (Any)->Void) {
        let url = URL(string:Constants.kBaseUrl+PostName)
        Alamofire.request(url!, method:.get
            , parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            switch(response.result){
            case .success(_):
                if let data = response.result.value
                {
                    print(response.result.value as Any)
                    print(data)
                    DispatchQueue.main.async {
                        completion(data)}
                }
                break
            case .failure(_):
                print(response.result.error!)
                
                break
            }
        }
    }
    
    func getData_Header(PostName: String,parameters:[String:String], completion: @escaping (Any)->Void) {
        let url = URL(string:Constants.kBaseUrl+PostName)
        let headers = ["content-type": "application/json", "Authorization": UserDefaults.standard.value(forKey: Constants.kDeviceID)]
        
        Alamofire.request(url!, method:.post, parameters : nil, encoding: JSONEncoding.default, headers: headers as! HTTPHeaders ).responseJSON { response in
            
            print(response)
            switch(response.result){
            case .success(_):
                if let data = response.result.value
                {
                    print(response.result.value as Any)
                    print(data)
                    DispatchQueue.main.async {
                        completion(data)}
                }
                break
            case .failure(_):
                if let data = response.result.error
                {
                    print(response.result.value as Any)
                    print(data)
                }
                break
            }
        }
    }
    func getData_HeaderParameter(PostName: String,parameters: [String:Any], completion: @escaping (Any)->Void) {
        let url = URL(string:Constants.kBaseUrl+PostName)
       let headers = [ "content-type": "application/json", "Authorization": "Bearer " +  "\(String(describing: UserDefaults.standard.value(forKey: Constants.kDeviceID)!))"]
     
        print(headers)
        Alamofire.request(url!, method:.post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            print(response)

            switch(response.result) {

                
            case .success(_):
                if let data = response.result.value
                {
                   // print(response.result.value as Any)
                    //print(data)
                    DispatchQueue.main.async{
                        completion(data)}
                }
                break
            case .failure(_):
                
                var error:Error?
                if let data = response.result.error
                {
                    
                    error = data
                    print(error.debugDescription)
                   // print(response.result.value as Any)
                   // print(data)
                }
                break
            }
        }
    }
    
    private func webservicesPostRequest(baseString: String, parameters: [String:String],success:@escaping (_ response: NSDictionary)-> Void, failure:@escaping (_ error: Error) -> Void){
        
        let headers = ["Authorization": UserDefaults.standard.value(forKey: Constants.kDeviceID)]
        
        let sessionConfiguration = URLSessionConfiguration.default
        
        let session = URLSession(configuration: sessionConfiguration, delegate: nil, delegateQueue: OperationQueue.main)
        
        let jsonData = try? JSONSerialization.data(withJSONObject:parameters)
        
        guard let url = URL(string: baseString) else{
            return
        }
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers as! [String : String]
        request.httpMethod = "POST"
        request.httpBody = jsonData
        
        let dataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if error == nil{
                if let responseData = data{
                    do{
                        let json = try JSONSerialization.jsonObject(with: responseData, options: [])
                        success(json as? NSDictionary ?? NSDictionary())
                    }
                    catch let err{
                        print(err)
                        failure(err)
                    }
                }
            }else{
                failure(error!)
            }
        }
        dataTask.resume()
    }
    
    func getData_HeaderParameter2(PostName: String,parameters: [String:Any], completion: @escaping (Any)->Void) {
        let url = URL(string:Constants.baseUrl+PostName)
        let headers = [ "content-type": "application/json", "Authorization": "Bearer " +  "\(String(describing: UserDefaults.standard.value(forKey: Constants.kDeviceID)!))"]
     
        print(headers)
        Alamofire.request(url!, method:.post, parameters: parameters, encoding: JSONEncoding.default, headers: headers ).responseJSON { response in
            
            print(response)
            switch(response.result) {
                
                
            case .success(_):
                if let data = response.result.value
                {
                   // print(response.result.value as Any)
                    //print(data)
                    DispatchQueue.main.async{
                        completion(data)}
                }
                break
            case .failure(_):
                if let data = response.result.error
                {
                    print(response.result.value as Any)
                    print(data)
                }
                break
            }
        }
    }
            
    func getUserProfile(vc:UIViewController,prams:[String:String],success:@escaping (_ response: Profile) -> Void){
        webservicesPostRequest(baseString: Constants.kBaseUrl + Constants.kGetProfile, parameters: prams, success: { (res) in
            print(res)
            if let dic = res.value(forKey: "data") as? NSDictionary{
                success(Profile(firstName: "\(dic.value(forKey: "first_name") ?? "")", lastName: "\(dic.value(forKey: "last_name") ?? "last_name")", email: "\(dic.value(forKey: "email") ?? "")", countryCode: "\(dic.value(forKey: "id") ?? "")", mobileNo: "\(dic.value(forKey: "mobile") ?? "mobile")", profileImg: "\(dic.value(forKey: "user_image") ?? "mobile")", serviceTypeID: dic.value(forKey: "service_type_id") as! Int, userTypeID: dic.value(forKey: "user_type_id") as! Int, vehicleInfo: dic.value(forKey: "vehicle_info") as? NSDictionary ?? [1 : 2], driverInfo: dic.value(forKey: "driver_info") as? NSDictionary ?? [1 : 2], gender: "\(dic.value(forKey: "gender") ?? "Choose Gender")", vehicle_type_id: "\(dic.value(forKeyPath: "vehicle_info.vehicle_type_id") ?? "Nil")"))
            }
            
        }) { (err) in
            print(err)
            //            SingletonClass.shared.stopLoading()
        }
    }
        
    func updateDevice(prams:[String:String]){
        NetworkingService.shared.webservicesPostRequest(baseString: Constants.kSocketUrl + Constants.kGetDriver, parameters: prams, success: { (res) in
            print(res)
        }) { (err) in
            
        }
    }
        
//    //To get CountryDetails
//
//    func getCountryCode(url :[URL, callback :@escaping ([CountryModel]) -> ()) {
//
//        var countryCode = [CountryModel]()
//
//        URLSession.shared.dataTask(with: url) { data, response, error in
//
//            if let data = data{
//
//                let json = try! JSONSerialization.jsonObject(with: data, options: [])
//                let dictionary = json as! JSONDictionary
//
//                let CountryDictionaries = dictionary["data"] as! [JSONDictionary]
//
//                countryCode = CountryDictionaries.compactMap { dictionary in
//                    return CountryModel(dictionary :dictionary)
//                }
//            }
//
//            DispatchQueue.main.async {
//                callback(countryCode)
//            }
//
//            }.resume()
//
//    }
}








