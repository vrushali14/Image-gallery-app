//
//  ImageViewCell.swift
//  ImageGallery
//
//  Created by Jadhav, V. A. on 25/09/2020.
//  Copyright © 2020 Vrushali. All rights reserved.
//

import UIKit

class ImageViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView : UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupView() {
        self.imageView.contentMode = .scaleToFill
    
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        self.imageView.layoutIfNeeded()
        self.imageView.layer.cornerRadius = 15.0
        self.imageView.clipsToBounds = true
    }
    
    func setCellImage(image: UIImage?) {
        imageView.image = image
    }
    
}
