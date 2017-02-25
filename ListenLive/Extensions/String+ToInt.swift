//
//  String+ToDouble.swift
//  ListenLive
//
//  Created by Brian Hans on 2/24/17.
//  Copyright © 2017 Nicholas Swift. All rights reserved.
//

import Foundation

extension String {
    func toInt() -> Int {
        //String format is returned as PT1H1M1S
        let timeString = self.substring(from: self.characters.index(self.characters.startIndex, offsetBy: 2))
        var hours = 0
        var minutes = 0
        var seconds = 0
        
        //Holds the value for the time
        var currentString: String = ""
        
        for char in timeString.characters{
            if(char == "H"){
                hours = Int(currentString)!
                currentString = ""
            }else if(char == "M"){
                minutes = Int(currentString)!
                currentString = ""
            }else if(char == "S"){
                seconds = Int(currentString)!
                currentString = ""
            }else{
                currentString.append(char)
            }
        }
        
        return (hours * 60 * 60) + (minutes * 60) + seconds
    }
}
