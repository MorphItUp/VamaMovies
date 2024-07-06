//
//  MovieDetailsModel.swift
//  VamaMovies
//
//  Created by Mohamed Elgedawy on 06/07/2024.
//

import Foundation

struct MovieDetailsModel {
    let id: Int
    let budget: Int
    let genres: [MovieGenreModel]
    let overview: String
    let posterPath: String
    let revenue: Int
    let runtime: Int
    let title: String
    let voteAverage: Float
    let voteCount: Int
    
    init(
        movieDetailsEntity: MovieDetailsEntity
    ) {
        self.id = movieDetailsEntity.id
        self.budget = movieDetailsEntity.budget
        self.genres = movieDetailsEntity.genres.map { MovieGenreModel.init(id: $0.id, name: $0.name) }
        self.overview = movieDetailsEntity.overview
        self.posterPath = movieDetailsEntity.posterPath
        self.revenue = movieDetailsEntity.revenue
        self.runtime = movieDetailsEntity.runtime
        self.title = movieDetailsEntity.title
        self.voteAverage = movieDetailsEntity.voteAverage
        self.voteCount = movieDetailsEntity.voteCount
    }
    
    init(
        id: Int,
        budget: Int,
        genres: [MovieGenreModel],
        overview: String,
        posterPath: String,
        revenue: Int,
        runtime: Int,
        title: String,
        voteAverage: Float,
        voteCount: Int
    ) {
        self.id = id
        self.budget = budget
        self.genres = genres
        self.overview = overview
        self.posterPath = posterPath
        self.revenue = revenue
        self.runtime = runtime
        self.title = title
        self.voteAverage = voteAverage
        self.voteCount = voteCount
    }
}

struct MovieGenreModel {
    let id: Int
    let name: String
}
