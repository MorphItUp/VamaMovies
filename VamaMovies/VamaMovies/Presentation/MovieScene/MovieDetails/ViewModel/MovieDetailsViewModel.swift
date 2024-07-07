//
//  MovieDetailsViewModel.swift
//  VamaMovies
//
//  Created by Mohamed Elgedawy on 07/07/2024.
//

import Combine

enum MovieDetailsState {
    case loading
    case content(MovieDetailsModel)
    case error(Error)
}

protocol MovieDetailsViewModelProtocol {
    func configure() async
    var state: MovieDetailsState? { get }
}

protocol MovieDetailsViewModelRouterProtocol {}

final class MovieDetailsViewModel: MovieDetailsViewModelProtocol, MovieDetailsViewModelRouterProtocol {
    
    // MARK: - Private Properties
    
    private let movieDetailsUseCase: MovieDetailsUseCaseProtocol
    @Published private (set) var state: MovieDetailsState? = .loading
    
    // MARK: - Init
    
    init(
        movieDetailsUseCase: MovieDetailsUseCaseProtocol
    ) {
        self.movieDetailsUseCase = movieDetailsUseCase
    }
    
    // MARK: - Requests
    
    func configure() async {
        do {
            guard let movieDetails = try await movieDetailsUseCase.execute() else { return }
            self.state = .content(movieDetails)
        } catch {
            self.state = .error(error)
        }
    }
}

