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
    func configure() async
    var state: MovieListState? { get }
}

protocol MovieListViewModelRouterProtocol {
    var selectedMovieHandler: (Int) -> Void { get set }
}

final class MovieListViewModel: MovieListViewModelProtocol, MovieListViewModelRouterProtocol {
    
    // MARK: - Private Properties
    
    private let movieListUseCase: MovieListUseCaseProtocol
    internal var selectedMovieHandler: (Int) -> Void = { _ in }
    @Published private (set) var state: MovieListState? = .loading

    // MARK: - Init
    
    init(movieListUseCase: MovieListUseCaseProtocol) {
        self.movieListUseCase = movieListUseCase
    }
    
    // MARK: - Requests
    
    func configure() async {
        do {
            guard let movieList = try await movieListUseCase.execute() else { return }
            self.state = .content(movieList)
        } catch {
            self.state = .error(error)
        }
    }
}
