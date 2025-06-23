//
//  NewsRequest.swift
//  NewsViewer
//
//  Created by Alexander Suhodolov on 23/06/2025.
//

import Foundation
import Services

//Example request.

enum NewsRequest {
    struct Constants {
        static let apiBaseUrlString = "api.mediacloud.org"
    }
    
    case retrieveNews(offset: Int, limit: Int)
}
 
extension NewsRequest: RequestProtocol {
    var host: String {
        return Constants.apiBaseUrlString
    }
    
    var path: String {
        switch self {
        case .retrieveNews:
            return "/api/v2/sample/stories"
        }
    }
    
    var headers: [String: String] {
        switch self {
        case .retrieveNews:
            return ["Content-Type": "application/json"]
        }
    }
    
    var urlParameters: [String: String?] {
        switch self {
        case .retrieveNews(let offset, let limit):
            [
                "limit": "\(limit)",
                "offset": "\(offset)"
            ]
        }
    }
    
    var requestType: RequestType {
        switch self {
        case .retrieveNews:
            return .GET
        }
    }
}
