//
//  Dictionary+Extansions.swift
//  MyGif
//
//  Created by Sergey Kovalchyk on 03.04.17.
//  Copyright © 2017 Sergey Kovalchyk. All rights reserved.
//

import Foundation
import UIKit

extension NSDictionary {
    //pase dictionaru for get error sting from server.
    func generateErrorString() -> String {
        var result : String = "";
        for key in self.allKeys {
            if let dict = self[key] as? NSDictionary {
                if let errorsArray = dict["errors"] as? NSArray {
                    result = result.appending(key as! String + ":\n");
                    result = result.appending(errorsArray.componentsJoined(by: "\n"));
                }
            }
        }
        return result as String;
    }
}

