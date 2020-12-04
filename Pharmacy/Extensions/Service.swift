//
//  Service.swift
//  Pharmacy
//
//  Created by osx on 23/01/20.
//  Copyright © 2020 osx. All rights reserved.
//
 
import Foundation
import Alamofire

class Service {
 static let shareInstance = Service()
 
    func webservicesPostRequest(baseString: String, parameters: [String:String],success:@escaping (_ response: NSDictionary)-> Void, failure:@escaping (_ error: Error) -> Void){
    
     let sessionConfiguration = URLSessionConfiguration.default
     let session = URLSession(configuration: sessionConfiguration, delegate: nil, delegateQueue: OperationQueue.main)
     let jsonData = try? JSONSerialization.data(withJSONObject:parameters)
     guard let url = URL(string: baseString) else{
         return
     }
     var request = URLRequest(url: url)
     request.httpMethod = "POST"
     request.httpBody = jsonData
     
     let dataTask = session.dataTask(with: request) {(data: Data?, response: URLResponse?, error: Error?) in
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
    
   func webservicesPostRequest2(baseString: String, parameters: [String:String],success:@escaping (_ response: NSDictionary)-> Void, failure:@escaping (_ error: Error) -> Void){
       let Url = String(format:baseString )
       guard let serviceUrl = URL(string: Url) else { return }
       var request = URLRequest(url: serviceUrl)
       request.httpMethod = "POST"
       request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
       guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
           return
       }
       request.httpBody = httpBody

       let session = URLSession.shared
       session.dataTask(with: request) { (data, response, error) in
           if let response = response {
               print(response)
           }
           if let data = data {
               do {
                   let json = try JSONSerialization.jsonObject(with: data, options: [])
                   print(json)
                    success(json as? NSDictionary ?? NSDictionary())
               } catch {
                   print(error)
                    failure(error)
               }
           }
           }.resume()
    }
    
     
    func webservicesPostRequest3(baseString: String, parameters: [String:String],success:@escaping (_ response: NSDictionary)-> Void, failure:@escaping (_ error: Error) -> Void){
        let Url = String(format:baseString )
       let headers = ["Authorization":  "Bearer " + "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6ImVhZjI0YmMyYmEzOWYyNjU1ZGIxYjJhZDQ2MzE5MWZkNDNjYmYyZmIxMDcwYjE0YjI3NTljYjAxMDhhMjljZGY4ZGFkNGU4ZDBlNjE2NzRhIn0.eyJhdWQiOiIxIiwianRpIjoiZWFmMjRiYzJiYTM5ZjI2NTVkYjFiMmFkNDYzMTkxZmQ0M2NiZjJmYjEwNzBiMTRiMjc1OWNiMDEwOGEyOWNkZjhkYWQ0ZThkMGU2MTY3NGEiLCJpYXQiOjE1ODAxOTk1NjksIm5iZiI6MTU4MDE5OTU2OSwiZXhwIjoxNjExODIxOTY5LCJzdWIiOiI5OCIsInNjb3BlcyI6W119.RmGFpT56mH15TSmN0vCY1ns5P3At8XHXzUtkkn-Plcj_9_EoAm6ukAmOudsG_yvfnnC2bklz_FW0Zq4FQkviDD9TD5aBRdWnE6LZGVZcV6GGpCOcKHZCAZvX5i7sPwCnTLe-Y2ruKekFHGM87QhvZgFL8bTc5NeZpr3azrMIsLe6h8YkxsvpJ_yon0QHse1lZ0oc816pqCAm39OTx_EW7Lc9i5VpxoI2F_r0aSBWZlnye-NdfVVxr6vXUemkTbS3AhkTOdVv_18oG2xpg5cU1J1mYN2xsy3U6wG822YHbh69lJl7vCdScnpHQqL3VjnVINwUUNJif2bWa2oShtonxCLyXBFMbC6KJWnXUrjGf7_SNA1JgAm8JHDsfqH6LDjXKSHLWmJv4vKz_XqLxRoPoteo2MC5ETD2SzUWdTXVRdTuBE5eu0UwHyyM1E2ALHhqqvo8k_ukgt09Yr4BiOFgvegnM7RRmJ6dtc04XzSl4P1mQ_lApkWY2F4k5HkDLBVtdCfzSisPZ9gyOCW17gjaOHEJtEh0CodP9LMNIBArQ5wBu59j-PhtxLV3DVmzlu_B3AHWEO1tk0tYEVIQ3vzdUCKM49qQ6x0f2-tNbfGDPs_dse8U5X2ez_THpX6W2d8EKNn_LKLxIr1f7lVJd9eJypL--4bERrCChRQ3YZheayU"]
     
        guard let serviceUrl = URL(string: Url) else { return }
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.allHTTPHeaderFields = headers
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            return
        }
        request.httpBody = httpBody

        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    //print(json)
                     success(json as? NSDictionary ?? NSDictionary())
                } catch {
                    print(error)
                     failure(error)
                }
            }
            }.resume()
     }
        
       
    
   

}
