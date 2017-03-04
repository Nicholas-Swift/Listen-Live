//
//  RadioControlsTableViewCell.swift
//  ListenLive
//
//  Created by Nicholas Swift on 2/24/17.
//  Copyright © 2017 Nicholas Swift. All rights reserved.
//

import UIKit
import AVFoundation

protocol RadioControlsTableViewCellDelegate: class {
    func sliderDurationChanged(duration: Float)
    func rewindButtonPressed()
    func playButtonPressed()
    func fastForwardButtonPressed()
}

class RadioControlsTableViewCell: UITableViewCell {
    
    // MARK: - Instance Vars
    weak var delegate: RadioControlsTableViewCellDelegate?
    var playerLayer: AVPlayerLayer?
    
    // MARK: - Subviews
    @IBOutlet weak var videoViewContainer: UIView!
    @IBOutlet weak var trackTitleLabel: UILabel!
    @IBOutlet weak var trackSubtitleLabel: UILabel!
    @IBOutlet weak var durationSlider: UISlider!
    @IBOutlet weak var rewindButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var fastForwardButton: UIButton!
    
    // MARK: - Subview Actions
    @IBAction func durationAction(_ sender: Any) {
        delegate?.sliderDurationChanged(duration: (sender as! UISlider).value)
    }
    @IBAction func rewindAction(_ sender: Any) {
        delegate?.rewindButtonPressed()
    }
    @IBAction func playAction(_ sender: Any) {
        delegate?.playButtonPressed()
    }
    @IBAction func fastForwardAction(_ sender: Any) {
        delegate?.fastForwardButtonPressed()
    }
    
    // MARK: - View Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        durationSlider.isContinuous = false
        rewindButton.isEnabled = false
    }
    
    // MARK: - Setup Video
    func setup() {
        setupVideoLayer()
    }
    
    func setupVideoLayer() {
        playerLayer = AVPlayerLayer(player: Player.player)
        playerLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.layoutIfNeeded()
        videoViewContainer.layer.addSublayer(playerLayer!)
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        
        playerLayer?.frame = CGRect(x: 0, y: 0, width: videoViewContainer.frame.width, height: videoViewContainer.frame.height)
    }
    
    func removeCurrentSong() {
        playerLayer?.removeFromSuperlayer()
        setupVideoLayer()
    }
}
