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
    
    static let player = Player()
    var unixTimeOffset: TimeInterval?
    var gettingTimeDifference: Bool = false
    
    override init() {
        super.init()
        
        try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: AVAudioSessionCategoryOptions.defaultToSpeaker)
        try? AVAudioSession.sharedInstance().setActive(true)
    }
    
    func play(trackId: String) {
        XCDYouTubeClient.default().getVideoWithIdentifier(trackId) { (video, error) in
            if let error = error {
                print(error)
                return
            }
            
            guard let url = video?.streamURLs[XCDYouTubeVideoQuality.HD720] else {
                return
            }
            
            self.replaceCurrentItem(with: AVPlayerItem(url: url))
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
