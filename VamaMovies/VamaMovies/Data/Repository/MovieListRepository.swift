//
//  MovieListRepository.swift
//  VamaMovies
//
//  Created by Mohamed Elgedawy on 06/07/2024.
//

import VamaNetworking

protocol MovieListRepositoryProtocol {
    func getMovieList() async throws -> [MovieModel]?
}

final class MovieListRepository: MovieListRepositoryProtocol {
    
    // MARK: - Properties
    
    private let provider: ServiceProtocol
        
    // MARK: - Init
    
    init(provider: ServiceProtocol = Service()) {
        self.provider = provider
    }
    
    // MARK: - Methods
    
    func getMovieList() async throws -> [MovieModel]? {
        let request = MovieListRequest()
        return try await withCheckedThrowingContinuation { continuation in
            self.provider.makeRequest(request: request) { result in
                switch result {
                case .success(let response):
                    let movieModel = response.results.map { MovieModel(
                        id: $0.id,
                        title: $0.title,
                        overview: $0.overview,
                        poster: $0.posterPath,
                        releaseDate: $0.releaseDate,
                        voteAverage: $0.voteAverage,
                        voteCount: $0.voteCount
                    )}
                    continuation.resume(returning: movieModel)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}

