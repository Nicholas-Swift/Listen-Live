//
//  RadioControlsTableViewCell.swift
//  ListenLive
//
//  Created by Nicholas Swift on 2/24/17.
//  Copyright © 2017 Nicholas Swift. All rights reserved.
//

import UIKit
import AVFoundation

class RadioControlsTableViewCell: UITableViewCell {
    
    // MARK: - Subviews
    @IBOutlet weak var videoViewContainer: UIView!
    var playerLayer: AVPlayerLayer?
    
    
    // MARK: - View Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        playerLayer?.removeFromSuperlayer()
    }
    
    func setup() {
        setupVideoLayer()
    }
    
    func setupVideoLayer() {
        let layer = AVPlayerLayer(player: Player.player)
        layer.videoGravity = AVLayerVideoGravityResizeAspectFill
        playerLayer = layer
        self.layoutIfNeeded()
        videoViewContainer.layer.addSublayer(layer)
    }
    
    override func updateConstraints() {
        super.updateConstraints()
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        
        if let videoViewContainer = videoViewContainer {
            playerLayer?.frame = CGRect(x: 0, y: 0, width: videoViewContainer.frame.width, height: videoViewContainer.frame.height)
        }
    }
}
