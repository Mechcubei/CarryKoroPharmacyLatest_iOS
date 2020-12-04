//
//  Extentions.swift
//  TugForceDriverEnd
//
//  Created by osx on 11/07/19.
//  Copyright © 2019 osx. All rights reserved.
//

import Foundation
import UIKit



extension UIButton {

func pulsate(){
    let pulse = CASpringAnimation(keyPath: "transform.scale")
    pulse.duration = 0.6
    pulse.fromValue = 0.95
    pulse.toValue = 1
    pulse.autoreverses = true
    pulse.repeatCount = 2
    pulse.initialVelocity = 0.5
    pulse.damping = 1.0
    layer.add(pulse, forKey: nil)
}

}
extension UIView {

// OUTPUT 1
func dropShadow(scale: Bool = true) {
  layer.masksToBounds = false
  layer.shadowColor = UIColor.darkGray.cgColor
  layer.shadowOpacity = 0.5
  layer.shadowOffset = CGSize(width: -1, height: 1)
  layer.shadowRadius = 1

  layer.shadowPath = UIBezierPath(rect: bounds).cgPath
  layer.shouldRasterize = true
  layer.rasterizationScale = scale ? UIScreen.main.scale : 1
}
}

extension UIViewController{
    
    func setUpBackButtonNav() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "arrow"), style: .plain, target: self, action: #selector(leftBarTap))
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @objc func leftBarTap() {
        self.navigationController?.popViewController(animated: true)
    }
}
