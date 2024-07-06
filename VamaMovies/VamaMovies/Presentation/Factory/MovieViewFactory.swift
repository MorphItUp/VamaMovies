//
//  MovieViewFactory.swift
//  VamaMovies
//
//  Created by Mohamed Elgedawy on 06/07/2024.
//

import UIKit

protocol MovieViewFactoryProtocol {
    func makeMovieList() -> UIViewController
    func makeMovieDetails(movieId: Int) -> UIViewController
}

class MovieViewFactory: MovieViewFactoryProtocol {
    
    func makeMovieList() -> UIViewController {
        let repo = MovieListRepository()
        let useCase = MovieListUseCase(movieListRepo: repo)
        let viewModel = MovieListViewModel(movieListUseCase: useCase)
        let view = MovieListViewController.create(with: viewModel)
        return view
    }
    
    func makeMovieDetails(movieId: Int) -> UIViewController {
        UIViewController()
    }
    
    
}
