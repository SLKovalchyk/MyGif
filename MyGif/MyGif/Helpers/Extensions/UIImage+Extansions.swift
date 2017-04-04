//
//  UIIMage+Extansions.swift
//  MyGif
//
//  Created by Sergey Kovalchyk on 03.04.17.
//  Copyright © 2017 Sergey Kovalchyk. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    //check if two image is equal. 
    func isEqualToImage(image: UIImage) -> Bool {
        let data1: NSData = UIImagePNGRepresentation(self)! as NSData
        let data2: NSData = UIImagePNGRepresentation(image)! as NSData
        return data1.isEqual(data2)
    }
}
