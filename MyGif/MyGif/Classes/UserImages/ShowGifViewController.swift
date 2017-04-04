//
//  ShowGifViewController.swift
//  MyGif
//
//  Created by Sergey Kovalchyk on 04.04.17.
//  Copyright © 2017 Sergey Kovalchyk. All rights reserved.
//

import UIKit
import SVProgressHUD
import TSMessages
import SDWebImage

class ShowGifViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.view.isUserInteractionEnabled = true;
        self.showAnimate()
    }

    @IBAction func close(_ sender: Any) {
        self.removeAnimate()
    }
    
    func showAnimate() {
        // show view with animation. Whet animation is finised - upload gif with lib SDWebImage
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }) { (isDone) in
            self.loadGif()
        }
    }

    func loadGif() {
        SVProgressHUD.show();
                NetworkManager().loadGif(success: { (gifURL) in
                    SVProgressHUD.dismiss()
                    let url : URL = URL(string: gifURL)!;
                    self.imageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "placeholderImage"));
                }) { (errorString) in
                    SVProgressHUD.dismiss()
                    TSMessage.setDefaultViewController(self)
                    TSMessage.showNotification(in: self,
                                               title: "Error",
                                               subtitle: errorString,
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

    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished) {
                self.view.removeFromSuperview()
            }
        });
    }
}
