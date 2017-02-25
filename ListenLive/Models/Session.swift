//
//  Session.swift
//  ListenLive
//
//  Created by Brian Hans on 2/25/17.
//  Copyright © 2017 Nicholas Swift. All rights reserved.
//

import Foundation

class Session {
    
    static var currentSession: Session?
    
    var id: String
    var trackId: String
    var time: TimeInterval
    var timeSetAt: TimeInterval
    var state: PlayerState
    
    init?(snapshot: [String: Any], id: String) {
        guard
            let trackId = snapshot[FirebaseConstants.track] as? String,
            let time = snapshot[FirebaseConstants.time] as? TimeInterval,
            let timeSetAt = snapshot[FirebaseConstants.timeSetAt] as? TimeInterval,
            let state = snapshot[FirebaseConstants.state] as? String
        else { return nil }
    
        self.id = id
        self.trackId = trackId
        self.time = time
        self.timeSetAt = timeSetAt
        self.state = PlayerState(rawValue: state) ?? .playing
    }
}
