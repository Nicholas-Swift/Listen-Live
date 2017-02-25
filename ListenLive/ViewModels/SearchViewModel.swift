//
//  SearchViewModel.swift
//  ListenLive
//
//  Created by Nicholas Swift on 2/24/17.
//  Copyright © 2017 Nicholas Swift. All rights reserved.
//

import UIKit

class SearchViewModel {

    // Table View
    let sections = ["Active Friends", "Recent", "Popular", "Saved"]
    
}

// MARK: - Table View Delegate
extension SearchViewModel {
    
    func heightForHeaderIn(section: Int) -> CGFloat {
        return 40
    }
    
    func titleForHeaderIn(section: Int) -> String {
        return sections[section]
    }
    
    func heightForRowAt(indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func heightForRadioTrackTableViewCell() -> CGFloat {
        return 70
    }
    
}

// MARK: - Table View Delegate
extension SearchViewModel {
    
    func numberOfSections() -> Int {
        return sections.count
    }
    
    func numberOfRows() -> Int {
        return 5
    }
    
}

