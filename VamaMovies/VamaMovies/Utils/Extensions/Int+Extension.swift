//
//  Int+Extension.swift
//  VamaMovies
//
//  Created by Mohamed Elgedawy on 08/07/2024.
//

import Foundation

extension Int {
    func toMovieRuntime() -> String {
        let hours = self / 60
        let remainingMinutes = self % 60
        return "\(hours)h \(remainingMinutes)m"
    }
}
