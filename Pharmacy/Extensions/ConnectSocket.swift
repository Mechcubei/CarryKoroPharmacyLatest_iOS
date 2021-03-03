//
//  ConnectSocket.swift
//  Pharmacy
//
//  Created by GT-Mechcubei on 3/30/20.
//  Copyright © 2020 osx. All rights reserved.
//

import Foundation
import SocketIO

enum NetworkError: Error {
    case badURL
}


class ConnectSocket: NSObject {
    static let shared = ConnectSocket()
    private var manager: SocketManager!
    public var socket: SocketIOClient!
    
    //let liveUrl = "http://134.209.157.211:3001"
    let liveUrl =  "http://199.192.16.62:3001"
    
    // let liveUrl = "http://carrykoro.com:3001"
    // local
    let socketObj = SocketManager(socketURL: URL(string: "http://199.192.16.62:3001")!, config: [.connectParams(["userId" : "Bearer " + "\(UserDefaults.standard.value(forKey: Constants.kDeviceID) ?? "")"])])
    // live
    //let socketObj = SocketManager(socketURL: URL(string: "http://199.192.16.62:3001")!, config: [.connectParams(["userId" : "Bearer " + "\(UserDefaults.standard.value(forKey: Constants.kDeviceID) ?? "")"])])
    
    func addHandler() {
        print((UserDefaults.standard.value(forKey: Constants.kDeviceID) ?? ""))
        //manager = SocketManager(socketURL: URL(string: "http://carrykoro.com:3001")!, config: [.reconnects(true)])
        manager = SocketManager(socketURL: URL(string: "http://199.192.16.62:3001")!, config: [.connectParams(["userId" : "Bearer " + "\(UserDefaults.standard.value(forKey: Constants.kDeviceID) ?? "")"])])
        socket = manager.defaultSocket
        socket.on(clientEvent: .connect) { (data, emitter) in
            
            print(data)
        print("Socket connected")
        //self.connectUserToSocket()
    }
        
    self.socket.on("response_user_authenticated") { (data, emitter) in
          print(data)
        }
    }
    
    func connectSocket() {
         socket.connect()
        //socket.disconnect()
    }
    
    func cancelOrder(request_id:Int,cancel_commentid:Int){
        let object = UserDefaults.standard.value(forKey: Constants.kDeviceID)
        let datafield : [String:Any] = ["request_id":request_id,
                                        "cancel_commentid":cancel_commentid,
                                        "token":"Bearer \(object ?? "")"]
        print(datafield)
//        let jsonData = try! JSONSerialization.data(withJSONObject:datafield)
//        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)
//        print(jsonString as Any)
        
    if socket.status == .connected {
        socket.emitWithAck("cancel_order", datafield).timingOut(after: 5.0) { (data) in
            print(data)
            }
        }
    }
    
    func acceptOrder(request_id:Int){
        let object = UserDefaults.standard.value(forKey: Constants.kDeviceID)
        let datafield : [String:Any] = ["request_id":request_id,
                                           "token":"Bearer \(object ?? "")"]
        print(datafield)
        
        if socket.status == .connected {
            socket.emitWithAck("accept_order", datafield).timingOut(after: 5.0) { (data) in
                   print(data)
            }
        }
    }
    
    func connectUserToSocket() {
        let object = [ UserDefaults.standard.value(forKey: Constants.kDeviceID)]
          print(object)
        socket.emit("connect", with: object)
    }
}
    



