//
//  MovieListUseCase.swift
//  VamaMovies
//
//  Created by Mohamed Elgedawy on 06/07/2024.
//

// In real life application, this class would contain more business logic
import Combine

// MARK: - MovieList UseCases
protocol MovieListUseCaseProtocol {
    func getMovieList() async throws -> [MovieModel]?
    func searchMovie(with query: String) async throws -> [MovieModel]?
}

final class MovieListUseCase: MovieListUseCaseProtocol {
    
    // MARK: - Private Properties
    
    private let movieListRepo: MovieListRepositoryProtocol
    
    // MARK: - Init
    
    init(movieListRepo: MovieListRepositoryProtocol) {
        self.movieListRepo = movieListRepo
    }
    
    // MARK: - Methods
    
    func getMovieList() async throws -> [MovieModel]? {
        try await movieListRepo.getMovieList()
    }
    
    func searchMovie(with query: String) async throws -> [MovieModel]? {
        try await movieListRepo.searchMovie(with: query)
    }
    
}
