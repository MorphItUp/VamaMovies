//
//  MovieViewFactory.swift
//  VamaMovies
//
//  Created by Mohamed Elgedawy on 06/07/2024.
//

import UIKit

protocol MovieViewFactoryProtocol {
    func makeMovieList() -> (UIViewController, MovieListViewModelRouterProtocol)
    func makeMovieDetails(movieId: Int) -> (UIViewController, MovieDetailsViewModelRouterProtocol)
}

class MovieViewFactory: MovieViewFactoryProtocol {
    
    func makeMovieList() -> (UIViewController, MovieListViewModelRouterProtocol) {
        let repo = MovieListRepository()
        let useCase = MovieListUseCase(movieListRepo: repo)
        let viewModel = MovieListViewModel(movieListUseCase: useCase)
        let view = MovieListViewController.create(with: viewModel)
        return (view, viewModel)
    }
    
    func makeMovieDetails(movieId: Int) -> (UIViewController, MovieDetailsViewModelRouterProtocol) {
        let repo = MovieDetailsRepository()
        let useCase = MovieDetailsUseCase(
            movieDetailsRepo: repo,
            movieId: movieId
        )
        let viewModel = MovieDetailsViewModel(movieDetailsUseCase: useCase)
        let view = MovieDetailsViewController.create(with: viewModel)
        return (view, viewModel)
    }
}

