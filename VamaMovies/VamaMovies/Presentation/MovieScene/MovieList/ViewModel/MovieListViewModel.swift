//
//  MovieListViewModel.swift
//  VamaMovies
//
//  Created by Mohamed Elgedawy on 06/07/2024.
//

import Combine

enum MovieListState {
    case loading
    case content([MovieModel])
    case error(Error)
}

protocol MovieListViewModelProtocol: ObservableObject {
    func configure()
    func didSelectedMovie(id: Int)
    var state: MovieListState? { get }
}

protocol MovieListViewModelRouterProtocol {
    var selectedMovieHandler: (Int) -> Void { get set }
}

final class MovieListViewModel: MovieListViewModelProtocol, MovieListViewModelRouterProtocol {
    
    // MARK: - Private Properties
    
    private var subscriptions = Set<AnyCancellable>()
    private let movieListUseCase: MovieListUseCaseProtocol
    internal var selectedMovieHandler: (Int) -> Void = { _ in }
    @Published private (set) var state: MovieListState? = .loading

    // MARK: - Init
    
    init(movieListUseCase: MovieListUseCaseProtocol) {
        self.movieListUseCase = movieListUseCase
    }
    
    // MARK: - Requests
    
    func configure() {
        movieListUseCase.execute()
            .sink { [weak self] error in
                guard let self else { return }
                switch error {
                case .finished:
                    break
                case .failure(let error):
                    self.state = .error(error)
                }
            } receiveValue: { [weak self] movies in
                guard let self,
                      let movies else { return }
                self.state = .content(movies)
            }
            .store(in: &subscriptions)
    }
    
    // MARK: - Methods
    
    func didSelectedMovie(id: Int) {
        selectedMovieHandler(id)
    }
}
