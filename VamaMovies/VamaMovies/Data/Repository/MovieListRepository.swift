//
//  MovieListRepository.swift
//  VamaMovies
//
//  Created by Mohamed Elgedawy on 06/07/2024.
//

import Combine

protocol MovieListRepositoryProtocol {
    func getMovieList() -> AnyPublisher<[MovieModel]?, Error>
}
