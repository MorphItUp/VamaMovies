//
//  MovieCell.swift
//  VamaMovies
//
//  Created by Mohamed Elgedawy on 06/07/2024.
//

import UIKit

class MovieCell: UICollectionViewCell {
    static let reuseIdentifier = "MovieCell"
       
       let imageView = UIImageView()
       let titleLabel = UILabel()
       let yearLabel = UILabel()
       let genreLabel = UILabel()
       
       override init(frame: CGRect) {
           super.init(frame: frame)
           
           // Image View
           imageView.contentMode = .scaleAspectFill
           imageView.clipsToBounds = true
           imageView.translatesAutoresizingMaskIntoConstraints = false
           contentView.addSubview(imageView)
           
           // Title Label
           titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
           titleLabel.numberOfLines = 0
           titleLabel.translatesAutoresizingMaskIntoConstraints = false
           contentView.addSubview(titleLabel)
           
           // Year Label
           yearLabel.font = UIFont.systemFont(ofSize: 14)
           yearLabel.textColor = .gray
           yearLabel.translatesAutoresizingMaskIntoConstraints = false
           contentView.addSubview(yearLabel)
           
           // Genre Label
           genreLabel.font = UIFont.systemFont(ofSize: 14)
           genreLabel.textColor = .gray
           genreLabel.translatesAutoresizingMaskIntoConstraints = false
           contentView.addSubview(genreLabel)
           
           // Constraints
           NSLayoutConstraint.activate([
               imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
               imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
               imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
               imageView.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1.5),
               
               titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
               titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
               titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
               
               yearLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
               yearLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
               yearLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
               
               genreLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
               genreLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
               genreLabel.topAnchor.constraint(equalTo: yearLabel.bottomAnchor, constant: 4),
               genreLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
           ])
       }
       
       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
       
       func configure(with movie: MovieModel) {
           titleLabel.text = movie.title
           yearLabel.text = movie.releaseDate
           guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(movie.poster)") else { return }
           imageView.load(url: url)
//           genreLabel.text = movie.genres.compactMap { genreID in
//               genres.first(where: { $0.id == genreID })?.name
//           }.joined(separator: ", ")
       }
}
