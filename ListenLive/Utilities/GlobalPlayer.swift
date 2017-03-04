//
//  GlobalPlayer.swift
//  ListenLive
//
//  Created by Nicholas Swift on 3/2/17.
//  Copyright © 2017 Nicholas Swift. All rights reserved.
//

import Foundation

struct PlayerNotifications {
    static let currentTrackChanged = Notification.Name(rawValue: "com.nicholas-swift.ListenLive.CurrentTrackChanged")
    static let currentQueueChanged = Notification.Name(rawValue: "com.nicholas-swift.ListenLive.CurrentQueueChanged")
}

class GlobalPlayer {
    static var currentTrack: Track? { didSet { currentTrackChanged() } }
    static var currentQueue: [Track] = [] { didSet { currentQueueChanged() } }
}

// MARK: - Notifications
extension GlobalPlayer {
    
    // Current Track Changed
    static func currentTrackChanged() {
        let notification = Notification(name: PlayerNotifications.currentTrackChanged, object: currentTrack, userInfo: nil)
        NotificationCenter.default.post(notification)
    }
    
    // Current Queue Changed
    static func currentQueueChanged() {
        let notification = Notification(name: PlayerNotifications.currentQueueChanged, object: currentQueue, userInfo: nil)
        NotificationCenter.default.post(notification)
    }
    
}
