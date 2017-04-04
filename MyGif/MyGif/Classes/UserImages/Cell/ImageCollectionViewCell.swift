//
//  ImageCollectionViewCell.swift
//  MyGif
//
//  Created by Sergey Kovalchyk on 04.04.17.
//  Copyright © 2017 Sergey Kovalchyk. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire

class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    func configureCell(imageModel : ImageModel) {
        //check if we have imade data - we show it, else - we show NONE
        titleLabel.text = imageModel.imageDescription.characters.count > 0 ? imageModel.imageDescription : "none";
        locationLabel.text = imageModel.imageAddress.characters.count > 0 ? imageModel.imageAddress : "none";

        //if imageModel already have image data - we show it, else - we download it
        if imageModel.image == nil {
            NetworkManager().requestImage(path: imageModel.imageURL, completionHandler: {image in
                self.imageView.image = image
                imageModel.image = image;
            })
        }
        else {
            imageView.image = imageModel.image;
        }
    }
}
