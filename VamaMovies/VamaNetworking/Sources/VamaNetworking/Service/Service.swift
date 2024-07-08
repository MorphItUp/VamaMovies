//
//  File 2.swift
//  
//
//  Created by Mohamed Elgedawy on 06/07/2024.
//

import Foundation

public typealias ServiceResult<T: Decodable> = Result<T, ServiceError>
public typealias ServiceCompletion<T: Decodable> = (ServiceResult<T>) -> Void

// MARK: - ServiceProtocol

public protocol ServiceProtocol {
    func makeRequest<Request: URLRequestConvertible>(
        request: Request,
        completion: @escaping ServiceCompletion<Request.ResponseModel>
    )
}

public struct Service: ServiceProtocol {
    
    // MARK: - Properties
    
    var session: URLSessionProtocol
    
    // MARK: - Init
    
    public init(session: URLSessionProtocol) {
        self.session = session
    }
    
    public init() {
        self.session = URLSession.shared
    }
    
    // MARK: - Methods
    
    public func makeRequest<Request: URLRequestConvertible>(
        request: Request,
        completion: @escaping ServiceCompletion<Request.ResponseModel>
    ) {
        
        session.dataTask(with: request) { data, reponse, error in
            let serviceResult: ServiceResult<Request.ResponseModel>
            if let error = error {
                serviceResult = .failure(ServiceError(withError: error))
            } else if let data = data {
                let decoder = JSONDecoder()
                do {
                    let response = try decoder.decode(Request.ResponseModel.self, from: data)
                    serviceResult = .success(response)
                } catch {
                    print(error)
                    serviceResult = .failure(.decoding)
                }
            } else {
                serviceResult = .failure(.unknown)
            }
            DispatchQueue.main.async {
                completion(serviceResult)
            }
        }
        .resumeTask()
    }
    
}
