//
//  SmallPlayerView.swift
//  ListenLive
//
//  Created by Nicholas Swift on 2/25/17.
//  Copyright © 2017 Nicholas Swift. All rights reserved.
//

import UIKit

class SmallPlayerView: UIView {
    
    // MARK: - Subviews
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var trackTitleLabel: UILabel!
    @IBOutlet weak var trackSubtitleLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    // MARK: - View Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        thumbnailImageView.layer.cornerRadius = 3
        thumbnailImageView.clipsToBounds = true
    }
    
}
