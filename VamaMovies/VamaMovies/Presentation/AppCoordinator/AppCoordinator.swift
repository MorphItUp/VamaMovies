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
        let view = movieViewFactory.makeMovieList()
        navigationController.pushViewController(view, animated: true)
    }
    
}
