//
//  Utilities.swift
//  Tugforce
//
//  Created by osx on 05/06/19.
//  Copyright © 2019 osx. All rights reserved.
//

import UIKit
import Foundation
 
import NVActivityIndicatorView
import AVFoundation
@available(iOS 11.0, *)
@available(iOS 13.0, *)

class Utilities: NSObject,NVActivityIndicatorViewable,UINavigationBarDelegate {
    
     var car_id:String!
    
    // MARK: Singleton Object Creation
    static let sharedInstance: Utilities = {
        
        let singletonObject = Utilities()
        return singletonObject
        
    }()
    
    //MARK: Navigation Title Image...
    class func navigationTitleImage() {
        
    }
    
 
    //MARK: AttachSideMenuController...
//    class func AttachSideMenuController(){
//        let mainstoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let leftViewController = mainstoryBoard.instantiateViewController(withIdentifier: "SideMenuController") as! SideMenuController
//        let leftsidenav = UINavigationController(rootViewController: leftViewController)
//        let appdeg:AppDelegate = UIApplication.shared.delegate as! AppDelegate
//        appdeg.centerContainer.leftDrawerViewController = leftsidenav
//    }
    class func AttachRightSideMenuController(){
//        let mainstoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let leftViewController = mainstoryBoard.instantiateViewController(withIdentifier: "FilterViewController") as! FilterViewController
//        let leftsidenav = UINavigationController(rootViewController: leftViewController)
//        let appdeg:AppDelegate = UIApplication.shared.delegate as! AppDelegate
//        appdeg.centerContainer.rightDrawerViewController = leftsidenav
    }
    //MARK: HideLeftSideMenu...
 
    //    MARK: ShowAlertView...
    class func ShowAlertView(title: String, message: String, viewController: UIViewController) {
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Continue", style: UIAlertAction.Style.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
    //    MARK: ShowAlertView...
    class func ShowAlertView2(title: String, message: String, viewController: UIViewController) {
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        // add the actions (buttons)
        //alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.default, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
    
     class func show(alert title:String , message:String ,buttonText: String , buttonOk: @escaping () -> ()  ){
            
            let alertController = UIAlertController(title: title, message: message , preferredStyle: UIAlertController.Style.alert)
    //
            
            alertController.addAction(UIAlertAction(title: buttonText , style: UIAlertAction.Style.default, handler: {  (action) in
                buttonOk()
            }))
            
            UIApplication.getTopViewController()?.present(alertController, animated: true, completion: nil)
        }
        
    
    
    
    
    //    MARK: Show FlashAnimation on click...
    class func flash(buttonName:UIButton) {
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.5
        flash.fromValue = 1
        flash.toValue = 0.1
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = 1
        buttonName.layer.add(flash, forKey: nil)
    }
    
    //MARK: Open Image with zooming view with Animation
    //    class func openImage(onTap imageName: String, view: UIViewController) {
    //        // Create image info
    //        let imageInfo = JTSImageInfo()
    //        imageInfo.imageURL = URL(string: imageName)
    //
    //        let imageViewer = JTSImageViewController(imageInfo: imageInfo, mode: JTSImageViewControllerMode.image, backgroundStyle : JTSImageViewControllerBackgroundOptions(rawValue: Int(JTSImageViewController_DefaultAlphaForBackgroundDimmingOverlay)))
    //
    //        imageViewer?.show(from: view, transition: JTSImageViewControllerTransition(rawValue: Int(JTSImageViewController_DefaultAlphaForBackgroundDimmingOverlay))!)
    //    }
    
    //MARK: show share options
    class func share(Name: String,image:UIImage, UIView: UIView, viewController: UIViewController) {
        let activityVC = UIActivityViewController(activityItems: [Name,image,""], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = UIView
        viewController.present(activityVC, animated: true, completion: nil)
    }
    //MARK: Open Image with zooming view
    //    class func openImage(onTap imageName: String, view: UIViewController) {
    //        // Create image info
    //        let imageInfo = JTSImageInfo()
    //        imageInfo.imageURL = URL(string: imageName)
    //
    //        let imageViewer = JTSImageViewController(imageInfo: imageInfo, mode: JTSImageViewControllerMode.image, backgroundStyle : JTSImageViewControllerBackgroundOptions(rawValue: Int(JTSImageViewController_DefaultAlphaForBackgroundDimmingOverlay)))
    //
    //        imageViewer?.show(from: view, transition: JTSImageViewControllerTransition(rawValue: Int(JTSImageViewController_DefaultAlphaForBackgroundDimmingOverlay))!)
    //    }
    //
    //
    //MARK: Get Thumbnail from Video URL
    //   class func generateThumbImage(url : URL) -> UIImage{
    //    let asset = AVAsset(url: url as URL)
    //    let assetImgGenerate : AVAssetImageGenerator = AVAssetImageGenerator(asset: asset)
    //    assetImgGenerate.appliesPreferredTrackTransform = true
    //    let time = CMTimeMake(1, 2)
    //    let img = try? assetImgGenerate.copyCGImage(at: time, actualTime: nil)
    //    if img != nil {
    //        let frameImg  = UIImage(cgImage: img!)
    //        DispatchQueue.main.async(execute: {
    //            // assign your image to UIImageView
    //        })
    //        return frameImg
    //    }
    //    return #imageLiteral(resourceName: "dummyimage")
    //    }
    
}
