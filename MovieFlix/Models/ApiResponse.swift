//  ApiResponse.swift
//  MovieFlix
//  Created by Ranjeet Raushan on 22/06/2020.
//  Copyright © 2020 Ranjeet Raushan. All rights reserved.

import Foundation

struct ApiResponse {
    
    var page: Int?
    var totalResults: Int?
    var result: [[String: Any]]?
    var dates: [String: Any]?
    var totalPages: Int?
    var message: String?
    
    init(_ json: [String: Any]) {
        self.page = json["page"] as? Int
        self.result = json["results"] as? [[String: Any]]
        self.totalPages = json["total_pages"] as? Int
        self.dates = json["dates"] as? [String: Any]
    }
    
    init(message: String? = nil) {
        self.message = message
    }
}

struct Movie: Codable {
    var popularity: Double?
    var voteCount: Int?
    var video: Bool?
    var posterPath: String?
    var id: Int?
    var adult: Bool?
    var backdropPath: String?
    var originalLanguage: String?
    var originalTitle: String?
    var genreIds: [Int]?
    var title: String?
    var voteAverage: Float?
    var overview: String?
    var releaseDate: String?
    
    static func toModel(_ json: [[String: Any]]?) -> [Movie]? {
        guard let json = json else { return nil }
        guard let data = try? JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted) else { return nil }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let model = try? decoder.decode([Movie].self, from: data) else { return nil }
        return model
    }
}
