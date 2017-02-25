//
//  Track.swift
//  ListenLive
//
//  Created by Nicholas Swift on 2/24/17.
//  Copyright © 2017 Nicholas Swift. All rights reserved.
//

import UIKit
import SwiftyJSON

class Track {
    
    // MARK: - Instance Vars
    var songId: String
    var title: String
    var thumbnailURL: URL
    
    // MARK: - Init
    init?(json: JSON) {
        guard
            let title = json[YoutTubeConstants.snippet][YoutTubeConstants.title].string,
            let songId = json[YoutTubeConstants.id][YoutTubeConstants.videoID].string,
            let thumbnailURLString = json[YoutTubeConstants.snippet][YoutTubeConstants.thumbnails][YoutTubeConstants.medium][YoutTubeConstants.url].string,
            let thumbnailURL = URL(string: thumbnailURLString)
        else { return nil }
        
        self.title = title
        self.songId = songId
        self.thumbnailURL = thumbnailURL
    }
    
}
