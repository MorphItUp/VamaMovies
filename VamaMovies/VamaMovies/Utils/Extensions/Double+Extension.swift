//
//  Double+Extension.swift
//  VamaMovies
//
//  Created by Mohamed Elgedawy on 08/07/2024.
//

import Foundation

extension Double {
    func formatRating() -> String {
        return String(format: "%.1f", self)
    }
}
