//
//  JSONFileRepository.swift
//  NewsViewer
//
//  Created by Alexander Suhodolov on 23/06/2025.
//

import Foundation

enum ResourceSrotageError: Error {
    case errorSavingToFile
}

public final class JSONFileRepository<Resource: Codable>: ResourceStorable {
    public init() {}
    
    public func save(resource: Resource?, resourceId: String) throws {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        else {
            throw ResourceSrotageError.errorSavingToFile
        }
        
        let fileURL = documentsDirectory.appendingPathComponent(resourceId)
        try JSON.saveToFile(value: resource, at: fileURL)
    }
    
    public func load(resourceId: String) -> Resource? {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        else {
            return nil
        }
        
        let fileURL = documentsDirectory.appendingPathComponent(resourceId)
        do {
            return try JSON.loadFromFile(at: fileURL)
        } catch {
            return nil
        }
    }
}
