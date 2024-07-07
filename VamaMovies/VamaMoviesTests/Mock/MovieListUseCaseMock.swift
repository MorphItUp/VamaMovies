//
//  MovieListUseCaseMock.swift
//  VamaMoviesTests
//
//  Created by Mohamed Elgedawy on 07/07/2024.
//

import Foundation
import Combine
@testable import VamaMovies

final class MovieListUseCaseMock: MovieListUseCaseProtocol {
    
    var error: Error?
    var model: [MovieModel]?
    var searchedModel: [MovieModel]?
    
    func getMovieList() async throws -> [VamaMovies.MovieModel]? {
        if let error {
            throw(error)
        }
        return model
    }
    
    func searchMovie(with query: String) async throws -> [VamaMovies.MovieModel]? {
        if let error {
            throw(error)
        }
        return searchedModel
    }
}


