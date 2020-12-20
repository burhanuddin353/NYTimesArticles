//
//  Network.swift
//  NYTimesArticles
//
//  Created by Burhanuddin Sunelwala on 18/12/20.
//

import Foundation
import Alamofire

enum NetworkError: Error {

    case invalidURL
    case serverDown
    case invalidResponse
    case invalidParameters
}

extension NetworkError: LocalizedError {

    public var errorDescription: String? {
        switch self {

        case .invalidURL:
            return NSLocalizedString("Bad Error", comment: "My error")

        case .serverDown:
            return NSLocalizedString("Server is down. Please try again.", comment: "My error")

        case .invalidResponse:
            return NSLocalizedString("Server is down. Please try again.", comment: "My error")

        case .invalidParameters:
            return NSLocalizedString("BadError", comment: "My error")
        }
    }
}

class Network {

    static let shared = Network()
    private init() {}

    func getMostViewedArticles(for section: String, period: Int, completionHandler: @escaping (Result<[Article]>) -> ()) {

        request(URL.mostViewed(for: section, period: period)).responseJSON { (response) in

            response.result.ifSuccess {

                if let value = response.value as? [String: Any],
                   let results = value["results"] as? [[String: Any]],
                   let data = try? JSONSerialization.data(withJSONObject: results, options: []) {

                    let decoder = JSONDecoder()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    decoder.dateDecodingStrategy = .formatted(dateFormatter)
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    if let articles = try? decoder.decode([Article].self, from: data) {
                        completionHandler(.success(articles))
                    } else {
                        completionHandler(.failure(NetworkError.invalidResponse))
                    }

                } else {
                    completionHandler(.failure(NetworkError.invalidResponse))
                }
            }

            response.result.ifFailure {
                completionHandler(.failure(response.result.error!))
            }
        }
    }

}

