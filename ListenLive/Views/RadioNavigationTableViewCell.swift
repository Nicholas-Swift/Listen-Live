//
//  RadioNavigationTableViewCell.swift
//  ListenLive
//
//  Created by Nicholas Swift on 2/24/17.
//  Copyright © 2017 Nicholas Swift. All rights reserved.
//

import UIKit

protocol RadioNavigationTableViewCellDelegate: class {
    func downButtonPressed()
    func optionsButtonPressed()
}

class RadioNavigationTableViewCell: UITableViewCell {
    
    // MARK: - Instance vars
    weak var delegate: RadioNavigationTableViewCellDelegate?
    
    // MARK: - Subviews
    @IBOutlet weak var downButton: UIButton!
    @IBOutlet weak var radioTitleLabel: UILabel!
    @IBOutlet weak var optionsButton: UIButton!
    
    // MARK: - Subview Actions
    @IBAction func downAction(_ sender: Any) {
        delegate?.downButtonPressed()
    }
    @IBAction func optionsAction(_ sender: Any) {
        delegate?.optionsButtonPressed()
    }
    
    // MARK: - View Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
