//
//  AddImageViewController.swift
//  MyGif
//
//  Created by Sergey Kovalchyk on 04.04.17.
//  Copyright © 2017 Sergey Kovalchyk. All rights reserved.
//

import UIKit
import Photos
import SkyFloatingLabelTextField
import SVProgressHUD

class AddImageViewController: BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var imageModel = ImageModel();

    let imagePickerController = UIImagePickerController();
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var hasgtagtextField: SkyFloatingLabelTextField!
    @IBOutlet weak var descriptionTextField: SkyFloatingLabelTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerController.delegate = self;
    }

    @IBAction func savePressed(_ sender: Any) {
        if (imageView.image?.isEqualToImage(image: #imageLiteral(resourceName: "placeholderImage")))! { //check if user can't select eny image
            self.showStringError(error: "Please, select the profile avatar picture.");
        }
        else {
            SVProgressHUD.show()
            self.view.endEditing(true);
            self.imageModel.imageDescription = descriptionTextField.text!;
            self.imageModel.hashtag = hasgtagtextField.text!;
            NetworkManager().uploadImage(imageModel: self.imageModel,
                                         success: { (response) in
                                            SVProgressHUD.dismiss()
                                            _ = self.navigationController?.popViewController(animated: true);
            }, failure: { (errorString) in
                SVProgressHUD.dismiss()
                self.showStringError(error: errorString);
            })
        }
    }

    @IBAction func addPhotoPressed(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let alertController = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet);

            let cameraAction = UIAlertAction.init(title: "Take photo", style: .default, handler: { (action) in
                self.imagePickerController.sourceType = .camera;
                self.present(self.imagePickerController, animated: true, completion: nil);
            });

            let libraryAction = UIAlertAction.init(title: "Choose from Photo Library", style: .default, handler: { (action) in
                self.imagePickerController.sourceType = .photoLibrary;
                self.present(self.imagePickerController, animated: true, completion: nil);
            });

            let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler:nil);

            alertController.addAction(cameraAction);
            alertController.addAction(libraryAction);
            alertController.addAction(cancelAction);

            if (UI_USER_INTERFACE_IDIOM() == .pad) {
                alertController.popoverPresentationController?.sourceView = self.view;
                alertController.popoverPresentationController?.sourceRect = imageView.frame;
            }
            self.present(alertController, animated: true, completion: nil);
        }
        else {
            self.present(self.imagePickerController, animated: true, completion: nil);
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagePickerController.dismiss(animated: true, completion: {
            self.newImageSelected(imageInfo: info);
        });
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePickerController.dismiss(animated: true, completion: nil);
    }

    func newImageSelected(imageInfo: [String : Any]) {
        let image : UIImage = imageInfo[UIImagePickerControllerOriginalImage] as! UIImage;
        imageView.image = image;
//
//        let metadata = imageInfo[UIImagePickerControllerMediaMetadata] as? NSDictionary

        //take image metadata from PHImageManaged. Make can make it only for photo.
        let assetURL = imageInfo[UIImagePickerControllerReferenceURL] as! NSURL
        let asset = PHAsset.fetchAssets(withALAssetURLs: [assetURL as URL], options: nil)
        guard let result = asset.firstObject, result is PHAsset else {
            return
        }

        let imageManager = PHImageManager.default()
        imageManager.requestImageData(for: result , options: nil, resultHandler:{
            (data, responseString, imageOriet, info) -> Void in
            let imageData: NSData = data! as NSData
            if let imageSource = CGImageSourceCreateWithData(imageData, nil) {
                let imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil)! as NSDictionary
                print(imageProperties)
                if let gps = imageProperties["{GPS}"] as? NSDictionary {
                    self.imageModel.latitude = (gps["Latitude"] as? Float)!;
                    self.imageModel.longitude = (gps["Longitude"] as? Float)!;
                }
            }
        })
        self.imageModel.image = image;
    }
}
