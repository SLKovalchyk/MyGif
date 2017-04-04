//
//  NetworkManager.swift
//  MyGif
//
//  Created by Sergey Kovalchyk on 03.04.17.
//  Copyright © 2017 Sergey Kovalchyk. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class NetworkManager: NSObject {

    internal static let BaseUrlPath = "http://api.doitserver.in.ua/"
    internal static let LoginURL = NetworkManager.BaseUrlPath + "login"
    internal static let RegistrationURL = NetworkManager.BaseUrlPath + "create"
    internal static let UploadImage = NetworkManager.BaseUrlPath + "image"
    internal static let GetAllImages = NetworkManager.BaseUrlPath + "all"
    internal static let GetGif = NetworkManager.BaseUrlPath + "gif"

    func registerUser(email:String!,
                      password:String!,
                      name:String?,
                      avatar : UIImage,
                      success:@escaping (NSDictionary) -> Void,
                      failure:@escaping (String) -> Void) {
        var params = ["email" : email,
                      "password" : password];
        if name != nil {
            params["name"] = name;
        }

        //changed Image size to 1Mb
        var compression : CGFloat = 0.9;
        let maxCompression : CGFloat = 0.1;
        let maxFileSize = 1024 * 1024

        var imageData : Data = UIImageJPEGRepresentation(avatar, compression)!;
        while (imageData.count > maxFileSize && compression > maxCompression)
        {
            compression -= 0.1;
            imageData = UIImageJPEGRepresentation(avatar, compression)!;
        }

        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData, withName: "avatar", fileName: "avatar.jpg", mimeType: "image/jpg")
            for (key, value) in params {
                     multipartFormData.append((value?.data(using: .utf8))!, withName: key)
            }
        },
                         to:NetworkManager.RegistrationURL)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    let code = response.response?.statusCode
                    if code == 201 {
                        let dict = response.result.value as? NSDictionary;
                        let avatar = dict?["avatar"]
                        UserManager.sharedManager.storeCurrentUser(name: name!, email: email, avatarURL: avatar as! String);
                        UserManager.sharedManager.token = dict?["token"] as! String
                        success(response.result.value as! NSDictionary);
                    }
                    else if code == 400 {
                        let responseDict : NSDictionary = (response.result.value as! NSDictionary).value(forKey: "children") as! NSDictionary;
                        failure(responseDict.generateErrorString());
                    }
                }

            case .failure(let encodingError):
                print(encodingError)
                failure(encodingError.localizedDescription);
            }
        }
    }

    func loginUser(email : String,
                   password : String,
                   success:@escaping (NSDictionary) -> Void,
                   failure:@escaping (String) -> Void) {
        SVProgressHUD.show();
        let params = ["email" : email,
                      "password" : password];
        Alamofire.request(NetworkManager.LoginURL,
                          method: .post,
                          parameters: params,
                          encoding: URLEncoding.default,
                          headers: nil).responseJSON { (response) in
                            let code = response.response?.statusCode
                            if code == 200 {
                                let dict = response.result.value as? NSDictionary;
                                UserManager.sharedManager.token = dict?["token"] as! String
                                success(response.result.value as! NSDictionary);
                            }
                            else if code == 400 {
                                let responseDict : NSDictionary = (response.result.value as! NSDictionary).value(forKey: "children") as! NSDictionary;
                                failure(responseDict.generateErrorString());
                            }
                            else {
                                failure("Server error");
                            }
        }
    }
}

//MARK: - Images methods
extension NetworkManager {
    func loadUserImages(success:@escaping (NSArray) -> Void,
                        failure:@escaping (String) -> Void) {
        Alamofire.request(NetworkManager.GetAllImages,
                          method: .get,
                          parameters: nil,
                          encoding: URLEncoding.default,
                          headers: ["token" : UserManager.sharedManager.token]).responseJSON { (response) in
                            let code = response.response?.statusCode
                            if code == 200 {
                                let dict = response.result.value as? NSDictionary;
                                let array = dict?["images"] as! NSArray;
                                let imagesArray : NSMutableArray = []
                                for dictionary in array {
                                    if dictionary is NSDictionary {
                                    let imageModel = ImageModel().imageModelFromDictionary(dict: dictionary as! NSDictionary);
                                    imagesArray.add(imageModel);
                                    }
                                }
                                success(imagesArray);
                            }
                            else if code == 403 {
                                let responseDict : NSDictionary = (response.result.value as! NSDictionary).value(forKey: "children") as! NSDictionary;
                                failure(responseDict.generateErrorString());
                            }
                            else {
                                failure("Server error");
                            }
        }
    }

    func uploadImage(imageModel : ImageModel,
                     success:@escaping (NSDictionary) -> Void,
                     failure:@escaping (String) -> Void) {
        let params = ["description" : imageModel.imageDescription,
                      "hashtag" : imageModel.hashtag,
                      "latitude" : String(imageModel.latitude),
                      "longitude" : String(imageModel.longitude)];

        //changed image size to 1Mb
        var compression : CGFloat = 0.9;
        let maxCompression : CGFloat = 0.1;
        let maxFileSize = 1024 * 1024

        var imageData : Data = UIImageJPEGRepresentation(imageModel.image!, compression)!;
        while (imageData.count > maxFileSize && compression > maxCompression)
        {
            compression -= 0.1;
            imageData = UIImageJPEGRepresentation(imageModel.image!, compression)!;
        }

        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(imageData, withName: "image", fileName: "image.jpg", mimeType: "image/jpg")
            for (key, value) in params {
                multipartFormData.append((value.data(using: .utf8))!, withName: key)
            }
        },
                         usingThreshold: SessionManager.multipartFormDataEncodingMemoryThreshold,
                         to: NetworkManager.UploadImage,
                         method: .post,
                         headers: ["token" : UserManager.sharedManager.token]) { (result) in
                            switch result {
                            case .success(let upload, _, _):
                                upload.responseJSON { response in
                                    let code = response.response?.statusCode
                                    if code == 201 {
                                        success(response.result.value as! NSDictionary);
                                    }
                                    else if code == 400 || code == 403 {
                                        let responseDict : NSDictionary = (response.result.value as! NSDictionary).value(forKey: "children") as! NSDictionary;
                                        failure(responseDict.generateErrorString());
                                    }
                                }

                            case .failure(let encodingError):
                                print(encodingError)
                                failure(encodingError.localizedDescription);
                            }
        };
    }

    func requestImage(path: String, completionHandler: @escaping (UIImage) -> Void) {
        Alamofire.request("\(path)").responseImage(imageScale: 1.5, inflateResponseImage: false, completionHandler: {response in
            guard let image = response.result.value else{
                print(response.result)
                return
            }
            DispatchQueue.main.async {
                completionHandler(image)
            }
        })
    }

    func loadGif(success:@escaping (String) -> Void,
                 failure:@escaping (String) -> Void) {
        Alamofire.request(NetworkManager.GetGif,
                          method: .get,
                          parameters: nil,
                          encoding: URLEncoding.default,
                          headers: ["token" : UserManager.sharedManager.token]).responseJSON { (response) in
                            let code = response.response?.statusCode
                            if code == 200 {
                                let dict = response.result.value as? NSDictionary;
                                let gifURL = dict?["gif"] as! String;
                                success(gifURL);
                            }
                            else if code == 403 {
                                let responseDict : NSDictionary = (response.result.value as! NSDictionary).value(forKey: "children") as! NSDictionary;
                                failure(responseDict.generateErrorString());
                            }
                            else {
                                failure("Server error");
                            }
        }
    }
}
