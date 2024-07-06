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

protocol MovieDetailsViewModelProtocol: ObservableObject {
    func configure()
    var state: MovieDetailsState? { get }
}

protocol MovieDetailsViewModelRouterProtocol {}

final class MovieDetailsViewModel: MovieDetailsViewModelProtocol, MovieDetailsViewModelRouterProtocol {
    
    // MARK: - Private Properties
    
    private var subscriptions = Set<AnyCancellable>()
    private let movieDetailsUseCase: MovieDetailsUseCaseProtocol
    @Published private (set) var state: MovieDetailsState? = .loading
    
    // MARK: - Init
    
    init(
        movieDetailsUseCase: MovieDetailsUseCaseProtocol
    ) {
        self.movieDetailsUseCase = movieDetailsUseCase
    }
    
    // MARK: - Requests
    
    func configure() {
        movieDetailsUseCase.execute()
            .sink { [weak self] error in
                guard let self else { return }
                switch error {
                case .finished:
                    break
                case .failure(let error):
                    self.state = .error(error)
                }
            } receiveValue: { [weak self] movieDetails in
                guard let self,
                      let movieDetails else { return }
                self.state = .content(movieDetails)
            }
            .store(in: &subscriptions)
    }
}

