//
//  MovieListViewModelTests.swift
//  VamaMoviesTests
//
//  Created by Mohamed Elgedawy on 07/07/2024.
//

import XCTest
import Combine
@testable import VamaMovies

final class MovieListViewModelTests: XCTestCase {
    
    var sut: MovieListViewModel!
    var useCaseMock: MovieListUseCaseMock!
    var subscriptions: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        useCaseMock = MovieListUseCaseMock()
        sut = MovieListViewModel(movieListUseCase: useCaseMock)
        subscriptions = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        super.tearDown()
        useCaseMock = nil
        sut = nil
        subscriptions = nil
    }
    
    func test_getMovieList_whenRequestSuccessful_thenShouldReturnMovieModels() {
        // Given
        let expectedResults: [MovieModel] = [.placeholder, .placeholder2]
        useCaseMock.model = [.placeholder, .placeholder2]
        
        sut.$state.sink { state in
            switch state {
            case .content(let snapshot):
                guard !snapshot.itemIdentifiers.isEmpty else { return }
                XCTAssertEqual(snapshot.itemIdentifiers, expectedResults)
            default:
                break
            }
        }
        .store(in: &subscriptions)
        
        // When
        Task {
            await sut.getMovieList()
        }
    }
    
    func test_getMovieList_whenRequestFailed_thenShouldReturnMovieModels() {
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
            await sut.getMovieList()
        }
    }
    
    
    func test_searchMovie_whenRequestSuccessful_thenShouldReturnMovieModels() {
        // Given
        let expectedResults: [MovieModel] = [.placeholder, .placeholder2]
        useCaseMock.model = [.placeholder, .placeholder2]
        
        sut.$state.sink { state in
            switch state {
            case .content(let snapshot):
                guard !snapshot.itemIdentifiers.isEmpty else { return }
                XCTAssertEqual(snapshot.itemIdentifiers, expectedResults)
            default:
                break
            }
        }
        .store(in: &subscriptions)
        
        // When
        Task {
            await sut.searchMovie(with: "TestTitle")
        }
    }
    
    func test_searchMovie_whenRequestFailed_thenShouldReturnMovieModels() {
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
            await sut.searchMovie(with: "TestTitle")
        }
    }
    
    func test_getMovieList_whenRequestIsLoading_thenShouldReturnLoadingState() {
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
            await sut.searchMovie(with: "TestTitle")
        }
        
        // Then
        XCTAssertTrue(isLoadingExpectedResult)
    }
}

extension MovieModel {
    fileprivate static var placeholder: MovieModel {
        .init(
            id: 10,
            title: "TestTitle",
            overview: "TestOverview",
            poster: "TestPoster",
            releaseDate: "TestReleaseDate",
            voteAverage: 2.0,
            voteCount: 15
        )
    }
    
    fileprivate static var placeholder2: MovieModel {
        .init(
            id: 11,
            title: "TestTitle",
            overview: "TestOverview",
            poster: "TestPoster",
            releaseDate: "TestReleaseDate",
            voteAverage: 2.0,
            voteCount: 15
        )
    }
    
}
