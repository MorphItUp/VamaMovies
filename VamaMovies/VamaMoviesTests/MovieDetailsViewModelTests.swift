//
//  MovieDetailsViewModelTests.swift
//  VamaMoviesTests
//
//  Created by Mohamed Elgedawy on 08/07/2024.
//

import XCTest
import Combine
@testable import VamaMovies

final class MovieDetailsViewModelTests: XCTestCase {

    var sut: MovieDetailsViewModel!
    var useCaseMock: MovieDetailsUseCaseMock!
    var subscriptions: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        useCaseMock = MovieDetailsUseCaseMock()
        sut = MovieDetailsViewModel(movieDetailsUseCase: useCaseMock)
        subscriptions = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        super.tearDown()
        useCaseMock = nil
        sut = nil
        subscriptions = nil
    }
    
    func test_configure_whenRequestSuccessful_thenShouldReturnMovieDetails() {
        // Given
        let expectedResults: MovieDetailsModel = .placeholder
        useCaseMock.model = .placeholder
        
        sut.$state.sink { state in
            switch state {
            case .content(let model):
                XCTAssertEqual(model, expectedResults)
            default:
                break
            }
        }
        .store(in: &subscriptions)
        
        // When
        Task {
            await sut.configure()
        }
    }
    
    func test_configure_whenRequestFailed_thenShouldReturnError() {
        // Given
        let expectedResults = NSError(domain: "backend", code: 100)
        useCaseMock.error = NSError(domain: "backend", code: 100)
        
        sut.$state.sink { state in
            switch state {
            case .error(let error):
                XCTAssertEqual(expectedResults, error as NSError)
            default:
                break
            }
        }
        .store(in: &subscriptions)
        
        // When
        Task {
            await sut.configure()
        }
    }
    
    func test_configure_whenRequestIsLoading_thenShouldReturnLoadingState() {
        // Given
        var isLoadingExpectedResult = false
        
        sut.$state.sink { state in
            switch state {
            case .loading:
                isLoadingExpectedResult = true
            default:
                break
            }
        }
        .store(in: &subscriptions)
        
        // When
        Task {
            await sut.configure()
        }
        
        // Then
        XCTAssertTrue(isLoadingExpectedResult)
    }
}

extension MovieDetailsModel {
    fileprivate static var placeholder: MovieDetailsModel {
        .init(id: 10,
              budget: 1,
              genres: [],
              overview: "TestOverview",
              posterPath: "TestPoster",
              revenue: 123,
              runtime: 123,
              title: "TestTitle",
              voteAverage: 6.6,
              voteCount: 123
        )
    }
}

