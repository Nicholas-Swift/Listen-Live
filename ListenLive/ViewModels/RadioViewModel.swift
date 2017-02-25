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
    
    func heightForRowAt(indexPath: IndexPath) -> CGFloat {
        switch(indexPath.row) {
        case 0:
            return 44
        case 1:
            return UITableViewAutomaticDimension
        default:
            return 80
        }
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
    
    func setupRadioControlsTableViewCell(cell: UITableViewCell) {
        // do shit
    }
    
    func setupRadioTrackTableViewCell(cell: UITableViewCell, indexPath: IndexPath) {
        // do shit
    }
    
}
