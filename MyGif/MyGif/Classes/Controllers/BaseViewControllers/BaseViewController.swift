//
//  BaseViewController.swift
//  MyGif
//
//  Created by Sergey Kovalchyk on 03.04.17.
//  Copyright © 2017 Sergey Kovalchyk. All rights reserved.
//

import UIKit
import TSMessages

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    //show error popup view from TOP
    internal func showError(error: Error, completion: ((Void) -> Void)? = nil)
    {
        TSMessage.setDefaultViewController(self)
        TSMessage.showNotification(in: self,
                                   title: "Error",
                                   subtitle: error.localizedDescription,
                                   image: nil,
                                   type: .error,
                                   duration: 4,
                                   callback: nil,
                                   buttonTitle: nil,
                                   buttonCallback: nil,
                                   at: .top,
                                   canBeDismissedByUser: true)
    }

    internal func showStringError(error: String, completion: ((Void) -> Void)? = nil)
    {
        TSMessage.setDefaultViewController(self)
        TSMessage.showNotification(in: self,
                                   title: "Error",
                                   subtitle: error,
                                   image: nil,
                                   type: .error,
                                   duration: 4,
                                   callback: nil,
                                   buttonTitle: nil,
                                   buttonCallback: nil,
                                   at: .top,
                                   canBeDismissedByUser: true)
    }

}
