//
//  File.swift
//  
//
//  Created by Aung Ko Min on 18/7/23.
//

import Foundation

public enum AttachentType: String, Codable, CaseIterable, Sendable {
    case photo, video
}

public struct Attachment: Hashable, Codable, Identifiable, Sendable {
    public var id: String { url }
    public var url: String
    public var type: AttachentType
    public var _url: URL? { URL(string: url) }
    public var identifier: String? = nil
    
    public init(url: String, type: AttachentType, identifier: String? = nil) {
        self.url = url
        self.type = type
        self.identifier = identifier
    }
    
    public var isLocalURL: Bool { URL(string: url)?.isFileURL == true }
}
