//
//  File.swift
//  
//
//  Created by Mohamed Elgedawy on 06/07/2024.
//

import Foundation

// MARK: - URLRequestConvertible Protocol

public protocol URLRequestConvertible {
    associatedtype ResponseModel: Decodable
    func asURLRequest() -> URLRequest
}
