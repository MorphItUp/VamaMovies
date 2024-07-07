//
//  MovieListUseCase.swift
//  VamaMovies
//
//  Created by Mohamed Elgedawy on 06/07/2024.
//

// In real life application, this class would contain more business logic
import Combine
import Foundation

// MARK: - MovieList UseCases
 protocol MovieListUseCaseProtocol {
    func execute() async throws -> [MovieModel]?
}

final class MovieListUseCase: MovieListUseCaseProtocol {
    
    // MARK: - Private Properties
    
    private let movieListRepo: MovieListRepositoryProtocol
    
    // MARK: - Init
    
    init(movieListRepo: MovieListRepositoryProtocol) {
        self.movieListRepo = movieListRepo
    }
    
    // MARK: - Methods
    
    func execute() async throws -> [MovieModel]? {
        try await movieListRepo.getMovieList()
    }
    
}
