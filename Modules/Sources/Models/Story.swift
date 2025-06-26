//
//  NewsInspectorApp.swift
//  Article.swift
//
//  Created by Alexander Suhodolov on 23/06/2025.
//

import Foundation

public struct Story: Codable, Identifiable {
    public var id: Int
    public var imageUrlString: String?
    public var text: String?
    public var isLiked: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case text = "name"
        case imageUrlString = "profile_picture_url"
        case isLiked = "is_liked"
    }
    
    public init(id: Int, imageUrlString: String? = nil, text: String? = nil, isLiked: Bool = false) {
        self.id = id
        self.imageUrlString = imageUrlString
        self.text = text
        self.isLiked = isLiked
    }
}
