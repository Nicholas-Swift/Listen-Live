//
//  Double+Format.swift
//  ListenLive
//
//  Created by Brian Hans on 2/24/17.
//  Copyright © 2017 Nicholas Swift. All rights reserved.
//

import Foundation

extension Double {
    func format() {
        let minutes = Int(seconds / 60)
        let justSeconds = Int(seconds.truncatingRemainder(dividingBy: 60))
        return String(format: "%02d:%02d", minutes, justSeconds)
    }
}
