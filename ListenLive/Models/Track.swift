//
//  Track.swift
//  ListenLive
//
//  Created by Nicholas Swift on 2/24/17.
//  Copyright © 2017 Nicholas Swift. All rights reserved.
//

import UIKit
import SwiftyJSON
import FirebaseDatabase

class Track {
    
    // MARK: - Instance Vars
    var songId: String
    var title: String
    var thumbnailURL: URL
    var thumbnailImage: UIImage?
    
    // MARK: - Init
    init(songId: String, title: String, thumbnailURL: URL) {
        self.songId = songId
        self.title = title
        self.thumbnailURL = thumbnailURL
    }
    
    init?(json: JSON) {
        
        var songId = json[YoutTubeConstants.id].string // Popular
        if songId == nil {
            songId = json[YoutTubeConstants.id][YoutTubeConstants.videoID].string // Search
        }
        if songId == nil {
            return nil
        }
        
        guard
            let title = json[YoutTubeConstants.snippet][YoutTubeConstants.title].string,
            let thumbnailURLString = json[YoutTubeConstants.snippet][YoutTubeConstants.thumbnails][YoutTubeConstants.medium][YoutTubeConstants.url].string,
            let thumbnailURL = URL(string: thumbnailURLString)
        else { return nil }
        
        self.title = title
        self.songId = songId!
        self.thumbnailURL = thumbnailURL
    }
    
    init?(snapshot: [String: Any]) {
        guard
            let title = snapshot[FirebaseConstants.title] as? String,
            let songId = snapshot[FirebaseConstants.songId] as? String,
            let thumbnailURLString = snapshot[FirebaseConstants.thumbnail] as? String,
            let thumbnailURL = URL(string: thumbnailURLString)
        else { return nil }
        
        self.title = title
        self.songId = songId
        self.thumbnailURL = thumbnailURL
    }
    
    
    func toJSON() -> [String: AnyHashable] {
        return [FirebaseConstants.title: title, FirebaseConstants.songId: songId, FirebaseConstants.thumbnail: thumbnailURL.absoluteString]
    }
}
