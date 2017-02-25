//
//  Router.swift
//  ListenLive
//
//  Created by Brian Hans on 2/24/17.
//  Copyright © 2017 Nicholas Swift. All rights reserved.
//

import Alamofire

enum YoutubeRouter: URLRequestConvertible {
    
    case search(term: String, amount: Int)
    case popular(amount: Int)
    case getTrack(id: String)
    
    var path: String {
        switch self {
        case .search:
            return "search"
        case .popular, .getTrack:
            return "videos"
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case let .search(term, amount):
            return ["part": "snippet", "q": term,  "maxResults" : amount, "type" : "video"]
        case let .popular(amount):
            return ["part" : "snippet", "chart": "mostPopular", "videoCategoryId": 10, "maxResults" : amount]
        case let .getTrack(id):
            return ["part": "snippet", "id": id]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .search, .popular, .getTrack:
            return .get
        }
    }

    func asURLRequest() throws -> URLRequest {
        let url = try NetworkingConstants.youtubeURL.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        if var parameters = parameters {
            parameters["key"] = NetworkingConstants.youtubeAPIKey
        }
        
        return try URLEncoding.methodDependent.encode(urlRequest, with: parameters)
    }
}
