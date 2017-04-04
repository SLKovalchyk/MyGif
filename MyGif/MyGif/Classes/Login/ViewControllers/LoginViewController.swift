//
//  LoginViewController.swift
//  MyGif
//
//  Created by Sergey Kovalchyk on 03.04.17.
//  Copyright © 2017 Sergey Kovalchyk. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import SVProgressHUD

class LoginViewController: BaseViewController {

    @IBOutlet weak var emilTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        //add view with UIButton under keybord.
        self.emilTextField.addAccessoryViewWithButtonTitle(title: "Done");
        self.passwordTextField.addAccessoryViewWithButtonTitle(title: "Done");
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationController?.setNavigationBarHidden(true, animated: false);

        /* TEST USER
        emilTextField.text = "w@w.www"
        passwordTextField.text = "qqqqqq"
        self.loginPressed()
         */
    }

    @IBAction func loginPressed() {
        //small validatioin
        if emilTextField.text?.characters.count == 0 {
            self.showStringError(error: "Email field is blank");
        }
        else if passwordTextField.text?.characters.count == 0 {
            self.showStringError(error: "Password field is blank");
        }
        else {
            self.view.endEditing(true);
            SVProgressHUD.show();
            NetworkManager().loginUser(email: emilTextField.text!,
                                       password: passwordTextField.text!,
                                       success: { (response) in
                                        SVProgressHUD.dismiss()
                                        self.performSegue(withIdentifier: "showUserImages", sender: nil)
            }, failure: { (errorString) in
                SVProgressHUD.dismiss()
                self.showStringError(error: errorString);
            });
        }
    }
}


extension LoginViewController {

}
