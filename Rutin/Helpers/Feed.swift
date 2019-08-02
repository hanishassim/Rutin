//
//  Feed.swift
//  Rutin
//
//  Created by H on 09/07/2019.
//  Copyright © 2019 H. All rights reserved.
//

import Foundation

// MARK: Basic models

// We do not model the `userComment` field because it is not supposed to be used by
// machines. We do not model extensions because they should be ignored unless
// supported anyway.
struct Feed {
    var version = Version.jsonFeed("1")
    var title: String
    var homePageURL: URL?
    var feedURL: URL?
    var description: String?
    // var userComment: String?
    var nextURL: URL?
    var icon: URL?
    var favicon: URL?
    var author: Author?
    var expired = false
    var hubs: [Hub]?
    var items: [Item] = []
    
    enum Version {
        case jsonFeed(String)
    }
    
    struct Author: Codable {
        var url: URL?
        var name: String?
        var avatar: URL?
    }
    
    struct Item {
        var id: String
        var url: URL?
        var externalURL: URL?
        var title: String?
        var contentText: String?
        var contentHTML: String?
        var summary: String?
        var image: URL?
        var bannerImage: URL?
        var datePublished: Date?
        var dateModified: Date?
        var author: Feed.Author?
        var tags: [String]?
        var attachments: [Attachment]?
        
        struct Attachment: Codable {
            var url: URL
            var mimeType: String
            var title: String?
            var sizeInBytes: Int?
            var durationInSeconds: Double?
            
            // Note: This is not derivable because of the custom names.
            enum JSONCodingKeys: String, CodingKey {
                case url
                case mimeType = "mime_type"
                case title
                case sizeInBytes = "size_in_bytes"
                case durationInSeconds = "duration_in_seconds"
            }
        }
    }
    
    struct Hub: Decodable {
        var type: String
        var url: URL
    }
}

// MARK: Custom Decodable conformances
extension Feed: Codable {
    enum CodingError: Error {
        case unrecognizedVersion(String, Swift.DecodingError.Context)
        case contentMissing(Swift.DecodingError.Context)
    }
    
    // Note: This is not derivable because of the custom names.
    enum JSONCodingKeys: String, CodingKey {
        case version
        case title
        case homePageURL = "home_page_url"
        case feedURL = "feed_url"
        case description
        // case userComment = "user_comment"
        case nextURL = "next_url"
        case icon
        case favicon
        case author
        case expired
        case hubs
        case items
    }
    
    // Note: This is not derivable because of the default value for `expired`.
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: JSONCodingKeys.self)
        
        version = try container.decode(Version.self, forKey: .version)
        title = try container.decode(String.self, forKey: .title)
        homePageURL = try container.decodeIfPresent(URL.self, forKey: .homePageURL)
        feedURL = try container.decodeIfPresent(URL.self, forKey: .feedURL)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        //userComment = try container.decodeIfPresent(String.self, forKey: .userComment)
        nextURL = try container.decodeIfPresent(URL.self, forKey: .nextURL)
        icon = try container.decodeIfPresent(URL.self, forKey: .icon)
        favicon = try container.decodeIfPresent(URL.self, forKey: .favicon)
        author = try container.decodeIfPresent(Author.self, forKey: .author)
        expired = try container.decodeIfPresent(Bool.self, forKey: .expired) ?? false
        hubs = try container.decodeIfPresent([Hub].self, forKey: .hubs)
        items = try container.decode([Item].self, forKey: .items)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: JSONCodingKeys.self)
        
        try container.encode(version, forKey: .version)
        try container.encode(title, forKey: .title)
        try container.encode(homePageURL, forKey: .homePageURL)
        try container.encode(description, forKey: .description)
        try container.encode(feedURL, forKey: .feedURL)
        //try container.encode(uerComment, forKey: .userComment)
        try container.encode(nextURL, forKey: .nextURL)
        try container.encode(icon, forKey: .icon)
        try container.encode(favicon, forKey: .favicon)
        try container.encode(author, forKey: .author)
        try container.encode(expired ? true : nil, forKey: .expired)
//        try container.encode(hubs, forKey: .hubs)
        try container.encode(items, forKey: .items)
    }
}

extension Feed.Version: Codable {
    private static let jsonFeedPrefix = "https://jsonfeed.org/version/"
    
    // Note: This is not derivable because it uses a single value container.
    init(from decoder: Decoder) throws {
        let versionString = try decoder.singleValueContainer().decode(String.self)
        guard let v = versionString.droppingPrefix(Feed.Version.jsonFeedPrefix) else {
            throw Feed.CodingError.unrecognizedVersion(versionString, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Unrecognized version"))
        }
        self = .jsonFeed(String(v))
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .jsonFeed(let version):
            try container.encode(Feed.Version.jsonFeedPrefix + version)
        }
    }
}

extension Feed.Item: Codable {
    // Note: This is not derivable because of the custom names.
    enum JSONCodingKeys: String, CodingKey {
        case id
        case url
        case externalURL = "external_url"
        case title
        case contentText = "content_text"
        case contentHTML = "content_html"
        case summary
        case image
        case bannerImage = "banner_image"
        case datePublished = "date_published"
        case dateModified = "date_modified"
        case author
        case tags
        case attachments
    }
    
    // Note: This is not derivable because of the contentMissing error.
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: JSONCodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        url = try container.decodeIfPresent(URL.self, forKey: .url)
        externalURL = try container.decodeIfPresent(URL.self, forKey: .externalURL)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        contentText = try container.decodeIfPresent(String.self, forKey: .contentText)
        contentHTML = try container.decodeIfPresent(String.self, forKey: .contentHTML)
        summary = try container.decodeIfPresent(String.self, forKey: .summary)
        image = try container.decodeIfPresent(URL.self, forKey: .image)
        bannerImage = try container.decodeIfPresent(URL.self, forKey: .bannerImage)
        datePublished = try container.decodeIfPresent(Date.self, forKey: .datePublished)
        dateModified = try container.decodeIfPresent(Date.self, forKey: .dateModified)
        author = try container.decodeIfPresent(Feed.Author.self, forKey: .author)
        tags = try container.decodeIfPresent([String].self, forKey: .tags)
        attachments = try container.decodeIfPresent([Attachment].self, forKey: .attachments)
        
        if contentText == nil && contentHTML == nil {
            throw Feed.CodingError.contentMissing(Swift.DecodingError.Context(codingPath: container.codingPath, debugDescription: "Item has no content"))
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: JSONCodingKeys.self)
        
        if contentText == nil && contentHTML == nil {
            throw Feed.CodingError.contentMissing(Swift.DecodingError.Context(codingPath: container.codingPath, debugDescription: "Item has no content"))
        }
        
        try container.encode(id, forKey: .id)
        try container.encode(url, forKey: .url)
        try container.encode(externalURL, forKey: .externalURL)
        try container.encode(title, forKey: .title)
        try container.encode(contentText, forKey: .contentText)
        try container.encode(contentHTML, forKey: .contentHTML)
        try container.encode(summary, forKey: .summary)
        try container.encode(image, forKey: .image)
        try container.encode(bannerImage, forKey: .bannerImage)
        try container.encode(datePublished, forKey: .datePublished)
        try container.encode(dateModified, forKey: .dateModified)
        try container.encode(author, forKey: .author)
        try container.encode(tags, forKey: .tags)
        try container.encode(attachments, forKey: .attachments)
    }
}

// MARK: Convenience members
extension Feed {
    fileprivate static var rfc3339: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssXXXXX"
        return formatter
    }()
    
    init(data: Data) throws {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(Feed.rfc3339)
        self = try decoder.decode(Feed.self, from: data)
    }
    
    init(contentsOf url: URL) throws {
        let data = try Data(contentsOf: url)
        try self.init(data: data)
    }
}

extension Data {
    init(_ feed: Feed, formatting: JSONEncoder.OutputFormatting = .prettyPrinted) throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = formatting
        encoder.dateEncodingStrategy = .formatted(Feed.rfc3339)
        self = try encoder.encode(feed)
    }
}

// MARK: Support code
extension StringProtocol {
    func droppingPrefix(_ prefix: String) -> SubSequence? {
        guard starts(with: prefix) else {
            return nil
        }
        
        return dropFirst(prefix.count)
    }
}
