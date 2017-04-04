//
//  RegistrationVC.swift
//  MyGif
//
//  Created by Sergey Kovalchyk on 03.04.17.
//  Copyright © 2017 Sergey Kovalchyk. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import SVProgressHUD

class RegistrationVC: BaseViewController, ImageManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var avatarImageVIew: UIImageView!
    @IBOutlet weak var userNameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField!

    let imagePickerController = UIImagePickerController();

    override func viewDidLoad() {
        super.viewDidLoad()

        imagePickerController.delegate = self;

        //add view with UIButton under keybord.
        userNameTextField.addAccessoryViewWithButtonTitle(title: "Done");
        emailTextField.addAccessoryViewWithButtonTitle(title: "Done");
        passwordTextField.addAccessoryViewWithButtonTitle(title: "Done");
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationController?.setNavigationBarHidden(false, animated: false);

    }

    func newImageSelected(imageInfo: [String : Any]) {
        let image : UIImage = imageInfo[UIImagePickerControllerOriginalImage] as! UIImage;
        avatarImageVIew.image = image;
    }
}

//MAKR: - User Action methods

extension RegistrationVC {
    @IBAction func changeAvatarPressed(_ sender: Any) {
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
                alertController.popoverPresentationController?.sourceRect = avatarImageVIew.frame;
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

    @IBAction func registrationPressed() {
        //small validation for empty fields
        if emailTextField.text?.characters.count == 0 {
            self.showStringError(error: "Email field is blank");
        }
        else if passwordTextField.text?.characters.count == 0 {
            self.showStringError(error: "Password field is blank");
        }

        else if (avatarImageVIew.image?.isEqualToImage(image: #imageLiteral(resourceName: "empty_photo")))! {
            self.showStringError(error: "Please, select the profile avatar picture.");
        }
        else {
            self.view.endEditing(true);
            SVProgressHUD.show();
            NetworkManager().registerUser(email: emailTextField.text,
                                          password: passwordTextField.text,
                                          name: userNameTextField.text,
                                          avatar: avatarImageVIew.image!,
                                          success: { (response) in
                                            SVProgressHUD.dismiss()
                                            self.performSegue(withIdentifier: "registrationComplete", sender: nil);
            }) { (errorString) in
                SVProgressHUD.dismiss()
                self.showStringError(error: errorString);
            }
        }
    }
}

// MARK: - Navigation
extension RegistrationVC {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}
