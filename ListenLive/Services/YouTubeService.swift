//
//  YouTubeService.swift
//  ListenLive
//
//  Created by Brian Hans on 2/24/17.
//  Copyright © 2017 Nicholas Swift. All rights reserved.
//

import Alamofire
import AlamofireImage
import SwiftyJSON

class YouTubeService {
    
    static func search(term: String, amount: Int = 5, completionHandler: @escaping ([Track], Error?) -> Void) {
        Alamofire.request(YoutubeRouter.search(term: term, amount: amount)).responseJSON { (response) in
            switch response.result {
            case let .success(value):
                let tracks = parseTracks(json: JSON(value: value))
                completionHandler(tracks, nil)
            case let .failure(error):
                completionHandler([], error)
            }
        }
    }
    
    static func getPopular(amount: Int = 5, completionHandler: @escaping ([Track], Error?) -> Void) {
        Alamofire.request(YoutubeRouter.popular(amount: amount)).responseJSON { (response) in
            switch response.result {
            case let .success(value):
                let tracks = parseTracks(json: JSON(value: value))
                completionHandler(tracks, nil)
            case let .failure(error):
                completionHandler([], error)
            }
        }
    }
    
    static func getTrack(id: String, completionHandler: @escaping (Track?, Error?) -> Void) {
        Alamofire.request(YoutubeRouter.getTrack(id: id)).responseJSON { (response) in
            switch response.result {
            case let .success(value):
                guard let json = JSON(value: value)[YoutTubeConstants.items].array else {
                    completionHandler(nil, nil)
                    return
                }
                
                let track = Track(json: json[0])
                completionHandler(track, nil)
            case let .failure(error):
                completionHandler(nil, error)
            }
        }
    }
    
    static private func parseTracks(json: JSON) -> [Track] {
        guard let json = json[YoutTubeConstants.items].array else {
            return []
        }
        
        return json.flatMap(Track.init)
    }
    
    static func downloadImage(url: URL, completionHandler: @escaping (UIImage?, Error?) -> Void) -> Request {
        return Alamofire.request(url).responseImage { (response) in
            switch response.result {
            case let .success(value):
                completionHandler(value, nil)
            case let .failure(error):
                completionHandler(nil, error)
            }
        }
    }
}
