//
//  LocationViewController.swift
//  Pharmacy
//
//  Created by osx on 06/02/20.
//  Copyright © 2020 osx. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation

class LocationViewController: UIViewController , GMSMapViewDelegate,CLLocationManagerDelegate{
 var locationManager = CLLocationManager()
    
    @IBOutlet var lblAddress: UILabel!
    @IBOutlet var imgOut: UIImageView!
    @IBOutlet var mapView_out: GMSMapView!
    var markerLat = Double()
    var markerLong = Double()
    var getAddressString : String = ""
    var callback : ((String) -> Void)?
    var comingFrom = ""
    override func viewDidLoad() {
          //Handle Google Maps
             comingFrom = "location"
              locationManager.delegate = self
              locationManager.requestWhenInUseAuthorization()
              locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
              locationManager.startUpdatingLocation()
              mapView_out.settings.tiltGestures = true
              mapView_out.settings.myLocationButton = true
              mapView_out.settings.compassButton = true
              mapView_out.delegate = self
    }
   // Function to get the custom marker location
   func mapView(_ mapView: GMSMapView, idleAt cameraPosition: GMSCameraPosition) {
           print("changed position: \(mapView_out.camera.target)")
           markerLat = mapView_out.camera.target.latitude
           markerLong = mapView_out.camera.target.longitude
           self.lblAddress.text = getAddressFromLatLon(pdblLatitude: "\(markerLat)", withLongitude: "\(markerLong)")
    SingletonVariables.sharedInstance.lat = "\(markerLat)"
    SingletonVariables.sharedInstance.long = "\(markerLong)"
   }
     
    
       //MARK: To update User Location in Google Map:
       func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
           if let location = locations.last {
               //let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
               let camera = GMSCameraPosition.camera(withLatitude:CLLocationDegrees(location.coordinate.latitude), longitude: CLLocationDegrees(location.coordinate.longitude), zoom: 16);
               self.mapView_out.camera = camera
               print("Latitude :- \(location.coordinate.latitude)")
               print("Longitude :-\(location.coordinate.longitude)")
               // marker.map = self.mapview
               markerLat = Double(location.coordinate.latitude)
              markerLong = Double(location.coordinate.longitude)
               self.lblAddress.text = getAddressFromLatLon(pdblLatitude: "\(markerLat)", withLongitude: "\(markerLong)")
               mapView_out.isMyLocationEnabled = true
               self.locationManager.stopUpdatingLocation()
                
               // self.setMarker(poistion: center)
           }
       }
    
    //MARK: Use this function to get address from current lat and long:
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) -> String{
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)")!
        //21.228124
        let lon: Double = Double("\(pdblLongitude)")!
        //72.833770
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                guard  let pm :[CLPlacemark] = placemarks   else{
                    //                    self.alert(title: "Error!!", message: "Un-able to get location please try again later")
                    return
                }
                
                if pm.count > 0{
                    let pm = placemarks![0]
                    var addressString : String = ""
                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! + ", "
                    }
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "
                    }
                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + ", "
                    }
                    if pm.country != nil {
                        addressString = addressString + pm.country! + ", "
                    }
                    if pm.postalCode != nil {
                        addressString = addressString + pm.postalCode! + " "
                    }
                    print(addressString)
                    self.lblAddress.text = addressString
                    SingletonVariables.sharedInstance.address = addressString
                    self.callback?(SingletonVariables.sharedInstance.lat)
                    self.callback?(SingletonVariables.sharedInstance.long)
                    self.callback?(SingletonVariables.sharedInstance.address)
                }
        })
        
        return getAddressString
    }
    
    @IBAction func btndataBack(_ sender: UIButton) {
        if comingFrom == "Profile" {
            
        }
        self.navigationController?.popViewController(animated: true)
    }
    
}
