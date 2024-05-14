//
//  XAttachment.swift
//  
//
//  Created by Aung Ko Min on 18/7/23.
//

import Foundation

public struct XAttachment: Hashable, Codable, Identifiable, Sendable {

    public enum XAttachmentKind: String, Codable, CaseIterable, Sendable {
        case photo, video
    }
    public var id: String { url }
    public var url: String
    public var type: XAttachmentKind
    public var _url: URL? { URL(string: url) }
    public var identifier: String? = nil
    
    public init(url: String, type: XAttachmentKind, identifier: String? = nil) {
        self.url = url
        self.type = type
        self.identifier = identifier
    }
    
    public var isLocalURL: Bool { URL(string: url)?.isFileURL == true }
}
