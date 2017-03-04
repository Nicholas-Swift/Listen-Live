//
//  RadioViewModel.swift
//  ListenLive
//
//  Created by Nicholas Swift on 2/24/17.
//  Copyright © 2017 Nicholas Swift. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class RadioViewModel {
    var tracks: [Track] = []
}

// MARK: - Tracks
extension RadioViewModel {
    
    // Get track based on indexPath
    func getTrack(at indexPath: IndexPath) -> Track {
        return tracks[indexPath.row]
    }
    
    func saveTrack(track: Track) {
        FirebaseService.saveTrack(track: track)
    }
    
}

// MARK: - Table View Delegate
extension RadioViewModel {
    
    func heightForRowAt(indexPath: IndexPath) -> CGFloat {
        switch(indexPath.row) {
        case 0:
            return 64
        case 1:
            return UITableViewAutomaticDimension
        default:
            return 70
        }
    }
    
}

// MARK: - Table View Delegate
extension RadioViewModel {
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfRows() -> Int {
        return 2 + tracks.count
    }
    
    func setupRadioNavigationTableViewCell(cell: UITableViewCell) {
        guard let cell = cell as? RadioNavigationTableViewCell else {
            return
        }
    }
    
    func setupRadioControlsTableViewCell(cell: UITableViewCell) {
        guard let cell = cell as? RadioControlsTableViewCell else {
            return
        }
        
        cell.setup()
    }
    
    func setupRadioTrackTableViewCell(cell: UITableViewCell, indexPath: IndexPath) {
        guard let cell = cell as? RadioTrackTableViewCell else {
            return
        }
        
        let track = tracks[indexPath.row - 2]
        
        cell.trackTitleLabel.text = track.title
        cell.trackSubtitleLabel.text = track.songId
        cell.thumbnailImageView.af_setImage(withURL: track.thumbnailURL)
    }
    
}
