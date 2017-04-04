//
//  ImageManager.swift
//  MyGif
//
//  Created by Sergey Kovalchyk on 03.04.17.
//  Copyright © 2017 Sergey Kovalchyk. All rights reserved.
//

import UIKit

protocol ImageManagerDelegate {
    func newImageSelected(imageInfo : [String : Any]);
}

class ImageManager: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let imagePickerController = UIImagePickerController();
    var imageManagerDelegate : ImageManagerDelegate!;

    override init() {
        super.init();
        setup();
    }

    func setup() {
        imagePickerController.delegate = self;
    }

    func showSourceActionSheet(viewController : UIViewController, fromFrame : CGRect) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let alertController = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet);

            let cameraAction = UIAlertAction.init(title: "Take photo", style: .default, handler: { (action) in
                self.imagePickerController.sourceType = .camera;
                viewController.present(self.imagePickerController, animated: true, completion: nil);
            });

            let libraryAction = UIAlertAction.init(title: "Choose from Photo Library", style: .default, handler: { (action) in
                self.imagePickerController.sourceType = .photoLibrary;
                viewController.present(self.imagePickerController, animated: true, completion: nil);
            });

            let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler:nil);

            alertController.addAction(cameraAction);
            alertController.addAction(libraryAction);
            alertController.addAction(cancelAction);

            if (UI_USER_INTERFACE_IDIOM() == .pad) {
                alertController.popoverPresentationController?.sourceView = viewController.view;
                alertController.popoverPresentationController?.sourceRect = fromFrame;
            }
            viewController.present(alertController, animated: true, completion: nil);
        }
        else {
            viewController.present(self.imagePickerController, animated: true, completion: nil);
        }
    }

    //MARK : UIIMagePicker methods
    @nonobjc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imagePickerController.dismiss(animated: true, completion: {
            self.imageManagerDelegate?.newImageSelected(imageInfo: info);
        });
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePickerController.dismiss(animated: true, completion: nil);
    }
}
