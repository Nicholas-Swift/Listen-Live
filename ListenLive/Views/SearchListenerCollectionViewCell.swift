//
//  SearchListenerCollectionViewCell.swift
//  ListenLive
//
//  Created by Nicholas Swift on 2/24/17.
//  Copyright © 2017 Nicholas Swift. All rights reserved.
//

import UIKit

class SearchListenerCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Subviews
    @IBOutlet weak var profilePictureImageView: UIImageView!
    
    // MARK: - View Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        profilePictureImageView.layer.cornerRadius = profilePictureImageView.bounds.width / 2
        profilePictureImageView.clipsToBounds = true
    }
    
}
