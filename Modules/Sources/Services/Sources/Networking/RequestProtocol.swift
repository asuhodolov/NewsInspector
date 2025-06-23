//
//  RequestProtocol.swift
//  NewsViewer
//
//  Created by Alexander Suhodolov on 23/06/2025.
//

import Foundation

public enum RequestType: String {
    case GET
    case POST
}

public protocol RequestProtocol {
    var host: String { get }
    var path: String { get }
    var headers: [String: String] { get }
    var parameters: [String: Any] { get }
    var urlParameters: [String: String?] { get }
    var requestType: RequestType { get }
}

public extension RequestProtocol {
    var path: String {
        ""
    }
    
    var parameters: [String: Any] {
        [:]
    }

    var urlParameters: [String: String?] {
        [:]
    }

    var headers: [String: String] {
        [:]
    }
    
    func makeURLRequest() throws -> URLRequest {
        var components = URLComponents()
        components.scheme = "https"
        components.host = host
        components.path = path
        
        if !urlParameters.isEmpty {
            components.queryItems = urlParameters.map {
                URLQueryItem(name: $0, value: $1)
            }
        }
        
        guard let url = components.url else { throw NetworkError.invalidURL }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = requestType.rawValue

        if !headers.isEmpty {
            urlRequest.allHTTPHeaderFields = headers
        }
        
        headers.forEach { (key, value) in
            urlRequest.setValue(
                value,
                forHTTPHeaderField: key)
        }

        if !parameters.isEmpty {
            urlRequest.httpBody = try JSONSerialization.data(
                withJSONObject: parameters)
        }
        
        return urlRequest
    }
}
