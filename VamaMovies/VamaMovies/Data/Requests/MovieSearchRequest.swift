//
//  MovieSearchRequest.swift
//  VamaMovies
//
//  Created by Mohamed Elgedawy on 07/07/2024.
//

import Foundation
import VamaNetworking

struct MovieSearchRequest: URLRequestConvertible {
    
    typealias ResponseModel = MovieEntity
    
    // MARK: - Properties
    
    private let httpMethod: HTTPMethod = .get
    private let searchQuery: String
    
    // MARK: - Init
    
    init(searchQuery: String) {
        self.searchQuery = searchQuery
    }
    
    func asURLRequest() -> URLRequest {
        var urlComponents = URLComponents(url: URL(string: NetworkConstants.baseUrl.rawValue + "/search/movie")!, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = [URLQueryItem]()
        
        let parameters = ["language": "en-US",
                          "query": searchQuery]
        
        for(key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))
            urlComponents?.queryItems?.append(queryItem)
        }
        
        var request = URLRequest(url: URL(string: NetworkConstants.baseUrl.rawValue + "/search/movie")!)
        request.url = urlComponents?.url
        request.httpMethod = httpMethod.rawValue
        request.allHTTPHeaderFields = ["Authorization": NetworkConstants.token.rawValue]
        return request
    }
}
