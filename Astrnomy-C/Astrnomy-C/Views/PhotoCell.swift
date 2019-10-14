//
//  PhotoCell.swift
//  Astrnomy-C
//
//  Created by Jeffrey Santana on 10/14/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    override func prepareForReuse() {
        imageView.image = #imageLiteral(resourceName: "MarsPlaceholder")
        
        super.prepareForReuse()
    }
    
    @IBOutlet var imageView: UIImageView!
}
