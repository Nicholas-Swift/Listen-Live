//
//  SearchViewModel.swift
//  ListenLive
//
//  Created by Nicholas Swift on 2/24/17.
//  Copyright © 2017 Nicholas Swift. All rights reserved.
//

import UIKit

class SearchViewModel {

    var isSearching = false
    
    // Normal View
    let sections = ["Live Now", "Recent", "Popular", "Saved"]
    var liveRadios: [Track] = []
    var recentTracks: [Track] = []
    var popularTracks: [Track] = []
    var savedTracks: [Track] = []
    
    // Searching
    var searchedTracks: [Track] = []
}

// MARK: - Tracks
extension SearchViewModel {
    
    // Get track based on indexPath
    func getTrack(at indexPath: IndexPath) -> Track {
        
        // Is searching
        if isSearching == true {
            return searchedTracks[indexPath.row]
        }
        
        // Not searching
        switch(indexPath.section) {
            //        case 0:
        //            break
        case 1:
            return recentTracks[indexPath.row]
        case 2:
            return popularTracks[indexPath.row]
        default:
            return savedTracks[indexPath.row]
        }
        
    }
    
    func saveTrack(track: Track) {
        FirebaseService.saveTrack(track: track)
    }
    
    func removeTrack(track: Track) {
        FirebaseService.removeTrack(track: track)
    }
    
}

// MARK: - Loading Track
extension SearchViewModel {
    
    // Get recent tracks
    func getRecentTracks(completion: @escaping (() -> ())) {
        FirebaseService.getHistory { [weak self] (tracks: [Track], error: Error?) in
            self?.handleTracksResponse(trackArray: &self!.recentTracks, tracks: tracks, error: error)
            completion()
        }
    }
    
    // Get popular tracks
    func getPopularTracks(completion: @escaping (() -> ())) {
        YouTubeService.getPopular { [weak self] (tracks: [Track], error: Error?) in
            self?.handleTracksResponse(trackArray: &self!.popularTracks, tracks: tracks, error: error)
            completion()
        }
    }
    
    // Get saved tracks
    func getSavedTracks(completion: @escaping (() -> ())) {
        FirebaseService.getSavedTracks { [weak self] (tracks: [Track], error: Error?) in
            self?.handleTracksResponse(trackArray: &self!.savedTracks, tracks: tracks, error: error)
            completion()
        }
    }
    
    // Get searched tracks
    func getSearchedTracks(searchTerm: String, completion: @escaping (() -> ())) {
        
        YouTubeService.search(term: searchTerm, amount: 20) { [weak self] (tracks: [Track], error: Error?) in
            self?.handleTracksResponse(trackArray: &self!.searchedTracks, tracks: tracks, error: error)
            completion()
        }
        
    }
    
    // Track networking helper
    fileprivate func handleTracksResponse(trackArray: inout [Track], tracks: [Track], error: Error?) {
        // Error
        if let error = error {
            print("An error occured when trying to get saved tracks: \(error)")
            return
        }
        
        // Set tracks
        trackArray = tracks
    }
    
}

// MARK: - Playing
extension SearchViewModel {
    
    func playTrack(at indexPath: IndexPath) {
        
        // Get track id
        let track: Track = getTrack(at: indexPath)
        
        // Play
        Player.player.play(track: track)
    }
    
}

// MARK: - Table View Delegate
extension SearchViewModel {
    
    func heightForHeaderIn(section: Int) -> CGFloat {
        return isSearching == true ? CGFloat.leastNonzeroMagnitude : 60
    }
    
    func heightForFooterIn(section: Int) -> CGFloat {
        if isSearching == true { return 90 }
        return section == sections.count - 1 ? 90 : 24
    }
    
    func titleForHeaderIn(section: Int) -> String? {
        return isSearching == true ? nil : sections[section]
    }
    
    func heightForRowAt(indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}

// MARK: - Table View Data Source
extension SearchViewModel {
    
    func numberOfSections() -> Int {
        return isSearching == true ? 1 : sections.count
    }
    
    func numberOfRowsIn(section: Int) -> Int {
        
        // Is searching
        if isSearching == true {
            return searchedTracks.count
        }
        
        switch section {
        case 0:
            return liveRadios.count
        case 1:
            return recentTracks.count
        case 2:
            return popularTracks.count
        default:
            return savedTracks.count
        }
    }
    
    func setupRadioTrackTableViewCell(cell: RadioTrackTableViewCell, at indexPath: IndexPath) {
        
        // Get correct track
        let track: Track = getTrack(at: indexPath)
        
        // Setup cell with that track information
        cell.trackTitleLabel.text = track.title
        cell.trackSubtitleLabel.text = track.songId
        
        // Set up image if there
        if let image = track.thumbnailImage {
            cell.thumbnailImageView.image = image
            return
        }
        
        // Set up image if not there
        cell.request = YouTubeService.downloadImage(url: track.thumbnailURL, completionHandler: { (image, error) in
            if let error = error {
                print(error)
                return
            }
            
            UIView.transition(with: cell.thumbnailImageView, duration: 0.2, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {
                track.thumbnailImage = image
                cell.thumbnailImageView.image = image
            })
        })
    }
    
}

