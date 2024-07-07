//
//  String+Extension.swift
//  VamaMovies
//
//  Created by Mohamed Elgedawy on 07/07/2024.
//

import Foundation

extension String {
    func extractYear() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = dateFormatter.date(from: self) {
            let calendar = Calendar.current
            let year = calendar.component(.year, from: date)
            return "\(year)"
        } else {
            return nil
        }
    }
}
