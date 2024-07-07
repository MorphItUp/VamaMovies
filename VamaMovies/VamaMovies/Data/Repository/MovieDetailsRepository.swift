//
//  MovieDetailsRepository.swift
//  VamaMovies
//
//  Created by Mohamed Elgedawy on 06/07/2024.
//

import VamaNetworking

protocol MovieDetailsRepositoryProtocol {
    func getMovieDetails(withId movieId: Int) async throws -> MovieDetailsModel?
}

final class MovieDetailsRepository: MovieDetailsRepositoryProtocol {
    
    // MARK: - Properties
    
    private let provider: ServiceProtocol
        
    // MARK: - Init
    
    init(provider: ServiceProtocol = Service()) {
        self.provider = provider
    }
    
    // MARK: - Methods
    
    func getMovieDetails(withId movieId: Int) async throws -> MovieDetailsModel? {
        let request = MovieDetailsRequest(movieId: movieId)
        return try await withCheckedThrowingContinuation { continuation in
            self.provider.makeRequest(request: request) { result in
                switch result {
                case .success(let response):
                    let movieDetailsModel = MovieDetailsModel(movieDetailsEntity: response)
                    continuation.resume(returning: movieDetailsModel)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
}
