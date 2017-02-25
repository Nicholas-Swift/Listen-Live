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
    
    var parameters: [String: Any] {
        var parametersDict: [String: Any] = [:]
        parametersDict["part"] = "snippet"
        parametersDict["key"] = NetworkingConstants.youtubeAPIKey
        
        switch self {
        case let .search(term, amount):
            parametersDict["q"] = term
            parametersDict["maxResults"] = amount
            parametersDict["type"] = "video"
        case let .popular(amount):
            parametersDict["chart"] = "mostPopular"
            parametersDict["videoCategoryId"] = 10
            parametersDict["maxResults"] = amount
        case let .getTrack(id):
            parametersDict["id"] = id
        }
        
        return parametersDict
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
        
        return try URLEncoding.methodDependent.encode(urlRequest, with: parameters)
    }
}
