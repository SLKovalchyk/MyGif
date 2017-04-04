//
//  ImageModel.swift
//  MyGif
//
//  Created by Sergey Kovalchyk on 03.04.17.
//  Copyright © 2017 Sergey Kovalchyk. All rights reserved.
//

import UIKit

class ImageModel: NSObject {
    var latitude : Float = 0;
    var longitude : Float = 0;
    var image : UIImage? = nil;
    var imageDescription: String = "";
    var hashtag : String = "";
    var imageURL : String = "";
    var imageAddress : String = "";

    //parse ImageModel params form dictionry response from serever.
   public func imageModelFromDictionary(dict : NSDictionary) -> ImageModel {
        let imageModel = ImageModel();
        let params = dict["parameters"] as! NSDictionary

        if let long = params["longitude"] {
             imageModel.longitude = long as! Float
        }

        if let lat = params["latitude"] {
            imageModel.longitude = lat as! Float
        }

        if let address = params["address"] {
            imageModel.imageAddress = address as! String
        }

        if let hash = dict["hashtag"]{
            imageModel.hashtag = hash as! String;
        }

        if let desc = dict["description"] {
            imageModel.hashtag = desc as! String;
        }

        if let ulrPath = dict["bigImagePath"] {
            imageModel.imageURL = ulrPath as! String;
        }
        return imageModel;
    }
}
