//
//  WebApiManager.swift
//  NewsViewer
//
//  Created by Alexander Suhodolov on 23/06/2025.
//

import Foundation

public protocol WebAPIManagerProtocol {
    func perform(_ request: RequestProtocol) async throws -> Data
    func perform<T: Decodable>(
        _ request: RequestProtocol,
        parser: DataParserProtocol
    ) async throws -> T
}

public protocol DataParserProtocol {
    func parse<T: Decodable>(data: Data) throws -> T
}

public class WebAPIManager: WebAPIManagerProtocol {
    private let urlSession: URLSession
    
    public init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    public func perform(_ request: RequestProtocol) async throws -> Data {
        let (data, response) = try await urlSession.data(for: request.makeURLRequest())
        guard let httpResponse = response as? HTTPURLResponse,
            (200..<300).contains(httpResponse.statusCode)
        else {
            throw NetworkError.invalidServerResponse
        }
        return data
    }
    
    public func perform<T: Decodable>(
        _ request: RequestProtocol,
        parser: DataParserProtocol
    ) async throws -> T {
        let data = try await perform(request)
        let decoded: T = try parser.parse(data: data)
        return decoded
    }
}
