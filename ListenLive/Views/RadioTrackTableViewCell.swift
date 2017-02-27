//
//  RadioTrackTableViewCell.swift
//  ListenLive
//
//  Created by Nicholas Swift on 2/24/17.
//  Copyright © 2017 Nicholas Swift. All rights reserved.
//

import UIKit
import Alamofire

protocol RadioTrackTableViewCellDelegate {
    func moreButtonPressed(sender: RadioTrackTableViewCell)
}

class RadioTrackTableViewCell: UITableViewCell {
    
    // MARK: - Instance Vars
    var delegate: RadioTrackTableViewCellDelegate?
    var request: Request?
    
    // MARK: - Subviews
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var trackTitleLabel: UILabel!
    @IBOutlet weak var trackSubtitleLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    
    // MARK: - Subview Actions
    @IBAction func moreAction(_ sender: Any) {
        delegate?.moreButtonPressed(sender: self)
    }
    
    
    // MARK: - View Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        thumbnailImageView.layer.cornerRadius = 3
        thumbnailImageView.clipsToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        request?.cancel()
        thumbnailImageView.image = nil
    }
    
}
