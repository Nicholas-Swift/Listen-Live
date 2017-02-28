//
//  Player.swift
//  ListenLive
//
//  Created by Brian Hans on 2/25/17.
//  Copyright © 2017 Nicholas Swift. All rights reserved.
//

import Foundation
import AVFoundation
import AVKit
import XCDYouTubeKit
import NTPKit

class Player: AVPlayer {
    
    // MARK: - Instance Vars
    static let player = Player()
    var playerLayer: AVPlayerLayer?
    var unixTimeOffset: TimeInterval?
    var gettingTimeDifference: Bool = false
    
    // MARK: - Init
    override init() {
        super.init()
        
        try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: AVAudioSessionCategoryOptions.defaultToSpeaker)
        try? AVAudioSession.sharedInstance().setActive(true)
    }
    
    // MARK: - Helper Functions
    func play(track: Track) {
        
        // Add to history
        FirebaseService.addToHistory(track: track)
        
        FirebaseService.createSession(trackId: track.songId) { (_) in
        }
        
        // Play Video
        XCDYouTubeClient.default().getVideoWithIdentifier(track.songId) { (video, error) in
            
            // Error
            if let error = error {
                print(error)
                return
            }
            
            // Get correct URL
            guard let urls = video?.streamURLs, urls.count > 0 else {
                return
            }
        
            var qualityDict: [UInt: URL] = [:]
            let keys: [UInt] = urls.keys.map{$0 as! UInt}
            let values: [URL] = urls.values.map{$0}
            for i in 0..<keys.count {
                qualityDict[keys[i]] = values[i]
            }
            
            guard let url =
                qualityDict[XCDYouTubeVideoQuality.HD720.rawValue] ??
                qualityDict[XCDYouTubeVideoQuality.medium360.rawValue] ??
                qualityDict[XCDYouTubeVideoQuality.small240.rawValue]
            else { return }
            
            self.replaceCurrentItem(with: AVPlayerItem(url: url))
            self.play()
        }
    }
    
    func seek(to seconds: TimeInterval, startTime: TimeInterval) {
        getCurrentTime { (time) in
            let time = time - startTime + seconds
            self.seek(to: CMTime(seconds: time, preferredTimescale: 1))
        }
    }
    
    func getCurrentTime(completion: @escaping (Double) -> Void) {
        if let unixTimeOffset = unixTimeOffset {
            completion(Date().timeIntervalSince1970 + unixTimeOffset)
        } else {
            if !gettingTimeDifference {
                gettingTimeDifference = true
                DispatchQueue.global().async {
                    let server = NTPServer.default
                    let date = try? server.date()
                    if let date = date {
                        self.unixTimeOffset = date.timeIntervalSince1970 - Date().timeIntervalSince1970
                        completion(Date().timeIntervalSince1970 + self.unixTimeOffset!)
                    } else {
                        self.getCurrentTime(completion: completion)
                    }
                }
            }
        }
    }
}
