//
//  File.swift
//  
//
//  Created by Mohamed Elgedawy on 06/07/2024.
//

import Foundation

// MARK: - HTTPMethod

/// Type representing HTTP methods. Raw `String` value is stored
public enum HTTPMethod: String {
    
    /// `OPTIONS` method.
    case options = "OPTIONS"
    
    /// `GET` method.
    case get = "GET"
    
    /// `HEAD` method.
    case head = "HEAD"
    
    /// `POST` method.
    case post = "POST"
    
    /// `PUT` method.
    case put = "PUT"
    
    /// `PATCH` method.
    case patch = "PATCH"
    
    /// `DELETE` method.
    case delete = "DELETE"
    
    /// `TRACE` method.
    case trace = "TRACE"
    
    /// `CONNECT` method.
    case connect = "CONNECT"
}

