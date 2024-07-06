//
//  AppCoordinator.swift
//  VamaMovies
//
//  Created by Mohamed Elgedawy on 06/07/2024.
//

import UIKit

class AppCoordinator {
    
    // MARK: - Properties
    private let navigationController: UINavigationController
    private let movieViewFactory: MovieViewFactoryProtocol
    
    // MARK: - Init
 
    init(
        navigationController: UINavigationController,
        movieViewFactory: MovieViewFactoryProtocol = MovieViewFactory()
    ) {
        self.navigationController = navigationController
        self.movieViewFactory = movieViewFactory
    }
    
    // MARK: - Methods
    
    func start() {
        var (view, viewModel) = movieViewFactory.makeMovieList()
        viewModel.selectedMovieHandler = { [weak self] movieId in
            guard let self else { return }
            navigateToMovieDetails(withId: movieId)
        }
        navigationController.pushViewController(view, animated: true)
    }
    
    func navigateToMovieDetails(withId movieId: Int) {
        let view = movieViewFactory.makeMovieDetails(movieId: movieId)
        navigationController.pushViewController(view, animated: true)
    }
    
}
