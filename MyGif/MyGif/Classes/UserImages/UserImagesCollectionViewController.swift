//
//  UserImagesCollectionViewController.swift
//  MyGif
//
//  Created by Sergey Kovalchyk on 03.04.17.
//  Copyright © 2017 Sergey Kovalchyk. All rights reserved.
//

import UIKit
import TSMessages
import SVProgressHUD

class UserImagesCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    fileprivate let itemsPerRow: CGFloat = 2
    var imagesArray : [ImageModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.register(UINib(nibName: "ImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "kImageCellReuseID")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        SVProgressHUD.show();
        NetworkManager().loadUserImages(success: { (array) in
            SVProgressHUD.dismiss()
            self.imagesArray = array.mutableCopy() as! [ImageModel];
            self.collectionView?.reloadData();
        }) { (stringError) in
            SVProgressHUD.dismiss()
            TSMessage.setDefaultViewController(self)
            TSMessage.showNotification(in: self,
                                       title: "Error",
                                       subtitle: stringError,
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

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesArray.count;
    }

    //configure collection view layout
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = 10 * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow

        return CGSize(width: widthPerItem, height: widthPerItem)
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : ImageCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "kImageCellReuseID", for: indexPath) as! ImageCollectionViewCell

        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let imageCell = cell as! ImageCollectionViewCell;
        imageCell.configureCell(imageModel: imagesArray[indexPath.item]);
    }
}

//MARK: - NAvigation methods

extension UserImagesCollectionViewController {
    @IBAction func showGifPressed(_ sender: Any) {
        //show custom ViewController as popover
        let popOverVC = UIStoryboard(name: "User", bundle: nil).instantiateViewController(withIdentifier: "gifVC") as! ShowGifViewController
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = (self.collectionView?.frame)!;
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
    }
}
