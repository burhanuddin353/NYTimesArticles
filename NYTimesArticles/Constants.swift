//
//  Constant.swift
//  NYTimesArticles
//
//  Created by Burhanuddin Sunelwala on 18/12/20.
//

import Foundation

enum Keys {
    static let api = "meJzhqQX9U7ekdsuUJSb8f4VLUcZFu22"
}

extension URL {

    static func mostViewed(for section: String, period: Int) -> URL {
        URL(string: "http://api.nytimes.com/svc/mostpopular/v2/mostviewed/\(section)/\(period).json?api-key=\(Keys.api)")!
    }
}

