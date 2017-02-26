//
//  RadioTrackTableViewCell.swift
//  ListenLive
//
//  Created by Nicholas Swift on 2/24/17.
//  Copyright © 2017 Nicholas Swift. All rights reserved.
//

import UIKit
import Alamofire

class RadioTrackTableViewCell: UITableViewCell {
    
    // MARK: - Subviews
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var trackTitleLabel: UILabel!
    @IBOutlet weak var trackPostedByLabel: UILabel!
    @IBOutlet weak var trackAddButton: UIButton!
    
    var request: Request?
    
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
