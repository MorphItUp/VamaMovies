//
//  MovieDetailsRepository.swift
//  VamaMovies
//
//  Created by Mohamed Elgedawy on 06/07/2024.
//

import Combine

protocol MovieDetailsRepositoryProtocol {
    func getMovieDetails(withId movieId: Int) -> AnyPublisher<MovieDetailsModel?, Error>
}
