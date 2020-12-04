//
//  ImageStorageClass.swift
//  Pharmacy
//
//  Created by osx on 30/01/20.
//  Copyright © 2020 osx. All rights reserved.
//

import Foundation
import UIKit

enum StorageType {
    case userDefaults
    case fileSystem
}
private func store(image: UIImage, forKey key: String, withStorageType storageType: StorageType) {
    if let pngRepresentation = image.pngData() {
          switch storageType {
          case .fileSystem:
              // Save to disk
            if let filePath = filePath(forKey: key) {
                do  {
                    try pngRepresentation.write(to: filePath,
                                                options: .atomic)
                } catch let err {
                    print("Saving file resulted in error: ", err)
                }
            }
          case .userDefaults:
              // Save to user defaults
          UserDefaults.standard.set(pngRepresentation, forKey: key)
          }
      }
    // Implementation
}
private func retrieveImage(forKey key: String, inStorageType storageType: StorageType)-> UIImage? {
    switch storageType {
    case .fileSystem:
        // Retrieve image from disk
        if let filePath =  filePath(forKey: key){
            let fileData = FileManager.default.contents(atPath: filePath.path)
            let image = UIImage(data: fileData!)
            return image
        }
    case .userDefaults:
        // Retrieve image from user defaults
        if let imageData = UserDefaults.standard.object(forKey: key) as? Data,
                   let image = UIImage(data: imageData) {
                   return image
               }
    }
    return nil
}
private func filePath(forKey key: String) -> URL? {
    let fileManager = FileManager.default
    guard let documentURL = fileManager.urls(for: .documentDirectory,
                                            in: FileManager.SearchPathDomainMask.userDomainMask).first else { return nil }
    
    return documentURL.appendingPathComponent(key + ".png")
}
