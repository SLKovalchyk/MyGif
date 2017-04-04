//
//  UITextField+Extansions.swift
//  Eventssion
//
//  Created by Sergey Kovalchyk on 03.04.17.
//  Copyright © 2017 Sergey Kovalchyk. All rights reserved.
//

import Foundation
import UIKit


extension UITextField
{
    //Add button under keybirad when textfield isEditing. Tap on this button close keyboard.
    func addAccessoryViewWithButtonTitle(title : String) {
        let sizeOfScreen : CGSize = UIScreen.main.bounds.size
        let keyboardDoneView : UIView = UIView.init()
        keyboardDoneView.frame = CGRect(x: 0, y: sizeOfScreen.height, width: sizeOfScreen.width, height: 40)
        keyboardDoneView.backgroundColor = UIColor().myGifGreenColor();

        let separatorView : UIView = UIView.init(frame: CGRect(x: 0, y: 39, width: sizeOfScreen.width, height: 1))
        separatorView.backgroundColor = UIColor().myGifGreenColor();
        keyboardDoneView.addSubview(separatorView)

        let button : UIButton = UIButton.init(type: UIButtonType.custom)
        button.addTarget(self, action: #selector(accessoryViewButtonPressed) , for: UIControlEvents.touchUpInside)
        button.setTitle(title, for: UIControlState.normal)
        button.setTitleColor(UIColor.white, for: UIControlState.normal)
        button.frame = CGRect(x: sizeOfScreen.width - 100, y: 0, width: 100, height: 40)
        keyboardDoneView.addSubview(button)

        self.inputAccessoryView = keyboardDoneView
    }

    func accessoryViewButtonPressed() {
        self.resignFirstResponder()
    }
}

