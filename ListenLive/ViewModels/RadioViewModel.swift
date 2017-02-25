//
//  RadioViewModel.swift
//  ListenLive
//
//  Created by Nicholas Swift on 2/24/17.
//  Copyright © 2017 Nicholas Swift. All rights reserved.
//

import UIKit

class RadioViewModel {}

// MARK: - Table View Delegate
extension RadioViewModel {
    
    func heightForRadioNavigationTableViewCell() -> CGFloat {
        return 44
    }
    
    func heightForRadioTrackTableViewCell() -> CGFloat {
        return 70
    }
    
}

// MARK: - Table View Delegate
extension RadioViewModel {
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfRows() -> Int {
        return 10
    }
    
    func setupRadioNavigationTableViewCell(cell: UITableViewCell) {
        // do shit
    }
    
    func setupRadioTrackTableViewCell(cell: UITableViewCell, indexPath: IndexPath) {
        // do shit
    }
    
}
