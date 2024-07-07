//
//  MovieDetailsUseCase.swift
//  VamaMovies
//
//  Created by Mohamed Elgedawy on 06/07/2024.
//

// In real life application, this class would contain more business logic
import Combine

// MARK: - MovieDetails UseCases

protocol MovieDetailsUseCaseProtocol {
    func execute() async throws -> MovieDetailsModel?
    var movieId: Int { get set }
}

final class MovieDetailsUseCase: MovieDetailsUseCaseProtocol {
    
    // MARK: - Private Properties
    
    private let movieDetailsRepo: MovieDetailsRepositoryProtocol
    var movieId: Int
    
    // MARK: - Init
    
    init(movieDetailsRepo: MovieDetailsRepositoryProtocol, movieId: Int) {
        self.movieDetailsRepo = movieDetailsRepo
        self.movieId = movieId
    }
    
    // MARK: - Methods
    
    func execute() async throws -> MovieDetailsModel? {
        try await movieDetailsRepo.getMovieDetails(withId: movieId)
    }
}

