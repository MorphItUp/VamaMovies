//
//  MovieEntity.swift
//  VamaMovies
//
//  Created by Mohamed Elgedawy on 06/07/2024.
//

import Foundation

// MARK: - MovieEntity

struct MovieEntity: Codable {
    let results: [MovieResultEntity]
    let page: Int
    let totalPages: Int
    let totalResults: Int
    
    init(
        results: [MovieResultEntity] = [],
        page: Int = 0,
        totalPages: Int = 0,
        totalResults: Int = 0
    ) {
        self.results = results
        self.page = page
        self.totalPages = totalPages
        self.totalResults = totalResults
    }
    
    enum CodingKeys: String, CodingKey {
        case results
        case page
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

