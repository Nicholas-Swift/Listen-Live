//
//  SmallPlayerView.swift
//  ListenLive
//
//  Created by Nicholas Swift on 2/25/17.
//  Copyright © 2017 Nicholas Swift. All rights reserved.
//

import UIKit

protocol SmallPlayerViewDelegate {
    func playButtonPressed()
}

class SmallPlayerView: UIView {
    
    // MARK: - Instance Vars
    var delegate: SmallPlayerViewDelegate?
    
    // MARK: - Subviews
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var trackTitleLabel: UILabel!
    @IBOutlet weak var trackSubtitleLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    // MARK: - Subview Actions
    @IBAction func playAction(_ sender: Any) {
        delegate?.playButtonPressed()
    }
    
    
    // MARK: - View Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        thumbnailImageView.layer.cornerRadius = 3
        thumbnailImageView.clipsToBounds = true
    }
    
}
