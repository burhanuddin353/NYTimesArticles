//
//  Article.swift
//  NYTimesArticles
//
//  Created by Burhanuddin Sunelwala on 18/12/20.
//

import Foundation

class MediaMetadata: Decodable {

    var url: URL
    var format: String?
}

class Media: Decodable {

    var mediaMetadata: [MediaMetadata]?
    var type: String?

    enum CodingKeys: String, CodingKey {
        case mediaMetadata = "media-metadata"
        case type
    }
}

class Article: Decodable {

    var id: Int
    var url: URL
    var publishedDate: Date?
    var section: String?
    var subsection: String?
    var adxKeywords: String?
    var byline: String?
    var title: String?
    var abstract: String?
    var media: [Media]?
}
