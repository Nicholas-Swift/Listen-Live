//
//  SearchViewModel.swift
//  ListenLive
//
//  Created by Nicholas Swift on 2/24/17.
//  Copyright © 2017 Nicholas Swift. All rights reserved.
//

import UIKit

class SearchViewModel {

    // Tracks
    var recentTracks: [Track] = []
    var popularTracks: [Track] = []
    var savedTracks: [Track] = []
    
    // Table View
    let sections = ["Recent", "Popular", "Saved"]
    
}

// MARK: - Tracks
extension SearchViewModel {
    
    // Get recent tracks
    func getRecentTracks(completion: @escaping (() -> ())) {
        FirebaseService.getHistory { [weak self] (tracks: [Track], error: Error?) in
            
            // Error
            if let error = error {
                print("An error occured when trying to get recent tracks: \(error)")
                completion()
                return
            }
            
            // Set tracks
            self?.recentTracks = tracks
            completion()
        }
    }
    
    // Get popular tracks
    func getPopularTracks(completion: @escaping (() -> ())) {
        YouTubeService.getPopular { [weak self] (tracks: [Track], error: Error?) in
            
            // Error
            if let error = error {
                print("An error occured when trying to get popular tracks: \(error)")
                completion()
                return
            }
            
            // Set tracks
            self?.popularTracks = tracks
            completion()
        }
    }
    
    // Get saved tracks
    func getSavedTracks(completion: @escaping (() -> ())) {
        FirebaseService.getSavedTracks { [weak self] (tracks: [Track], error: Error?) in
            
            // Error
            if let error = error {
                print("An error occured when trying to get saved tracks: \(error)")
                completion()
                return
            }
            
            // Set tracks
            self?.savedTracks = tracks
            completion()
        }
    }
    
}

// MARK: - Table View Delegate
extension SearchViewModel {
    
    func heightForHeaderIn(section: Int) -> CGFloat {
        return 60
    }
    
    func heightForFooterIn(section: Int) -> CGFloat {
        return section == sections.count - 1 ? 20 : CGFloat.leastNonzeroMagnitude
    }
    
    func titleForHeaderIn(section: Int) -> String {
        return sections[section]
    }
    
    func heightForRowAt(indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}

// MARK: - Table View Data Source
extension SearchViewModel {
    
    func numberOfSections() -> Int {
        return sections.count
    }
    
    func numberOfRowsIn(section: Int) -> Int {
        switch section {
        case 0:
            return recentTracks.count
        case 1:
            return popularTracks.count
        default:
            return savedTracks.count
        }
    }
    
    func setupRadioTrackTableViewCell(cell: RadioTrackTableViewCell, at indexPath: IndexPath) {
        
        // Get correct track
        let track: Track!
        switch indexPath.section {
        case 0:
            track = recentTracks[indexPath.row]
        case 1:
            track = popularTracks[indexPath.row]
        default:
            track = savedTracks[indexPath.row]
        }
        
        // Setup cell with that track information
        cell.trackTitleLabel.text = track.title
        cell.trackPostedByLabel.text = track.songId
    }
    
}

