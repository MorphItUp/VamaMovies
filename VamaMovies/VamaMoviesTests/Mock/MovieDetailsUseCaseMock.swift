//
//  MovieDetailsUseCaseMock.swift
//  VamaMoviesTests
//
//  Created by Mohamed Elgedawy on 08/07/2024.
//

import Foundation
@testable import VamaMovies

final class MovieDetailsUseCaseMock: MovieDetailsUseCaseProtocol {
    
    var error: Error?
    var model: MovieDetailsModel?
    
    func execute() async throws -> VamaMovies.MovieDetailsModel? {
        if let error {
            throw(error)
        }
        return model
    }
}
