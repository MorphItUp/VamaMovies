//
//  MovieModel.swift
//  VamaMovies
//
//  Created by Mohamed Elgedawy on 06/07/2024.
//

import Foundation

struct MovieModel: Equatable {
    var id: Int
    
    var title: String
    var overview: String
    var poster: String
    var releaseDate: String
    var voteAverage: Double
    var voteCount: Int
}
