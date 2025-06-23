//
//  JSON+Storage.swift
//  NewsViewer
//
//  Created by Alexander Suhodolov on 23/06/2025.
//

import Foundation

enum JSON {
    static func loadFromFile<T: Decodable>(at fileURL: URL) throws -> T {
        let fileData = try Data(contentsOf: fileURL)
        return try JSONDecoder().decode(T.self, from: fileData)
    }
    
    static func saveToFile<T: Encodable>(value: T, at fileURL: URL) throws {
        let encodedObject = try JSONEncoder().encode(value)
        try encodedObject.write(to: fileURL)
    }
}
