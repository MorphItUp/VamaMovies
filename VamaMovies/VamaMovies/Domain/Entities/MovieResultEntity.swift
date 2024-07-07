//
//  MovieResultEntity.swift
//  VamaMovies
//
//  Created by Mohamed Elgedawy on 06/07/2024.
//

import Foundation

struct MovieResultEntity: Codable {
    var id: Int
    var backdropPath: String?
    var originalLanguage, originalTitle, overview: String
    var popularity: Double
    var posterPath: String?
    var releaseDate, title: String
    var voteAverage: Double
    var voteCount: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case backdropPath = "backdrop_path"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}
