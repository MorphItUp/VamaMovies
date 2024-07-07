//
//  MovieCell.swift
//  VamaMovies
//
//  Created by Mohamed Elgedawy on 06/07/2024.
//

import UIKit

class MovieCell: UICollectionViewCell {
    static let reuseIdentifier = "MovieCell"
    
    private let gradientLayer = CAGradientLayer()
    private let imageContainerView = UIView()
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let yearLabel = UILabel()
    private let ratingLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImageContainerView()
        setupContentView()
        setupImageView()
        setupTitleLabel()
        setupYearLabel()
        setupGenreLabel()
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupContentView() {
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.4
        contentView.layer.shadowOffset = CGSize(width: 3, height: 5)
        contentView.layer.shadowRadius = 9
    }
    
    private func setupImageContainerView() {
        imageContainerView.backgroundColor = .systemGray6
        imageContainerView.layer.cornerRadius = 12
        imageContainerView.clipsToBounds = true
        imageContainerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageContainerView)
    }
    
    private func setupImageView() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
      
        imageContainerView.addSubview(imageView)
    }

    private func setupTitleLabel() {
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .heavy, width: .standard)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        imageContainerView.addSubview(titleLabel)
    }
    
    private func setupYearLabel() {
        yearLabel.font = UIFont.systemFont(ofSize: 11, weight: .regular, width: .standard)
        yearLabel.textColor = .black
        yearLabel.translatesAutoresizingMaskIntoConstraints = false
        imageContainerView.addSubview(yearLabel)
    }
   
    private func setupGenreLabel() {
        ratingLabel.font = UIFont.systemFont(ofSize: 11, weight: .regular, width: .standard)
        ratingLabel.textColor = .black
        ratingLabel.numberOfLines = 0
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        imageContainerView.addSubview(ratingLabel)
    }
    
    private func layoutUI() {
        NSLayoutConstraint.activate([
            imageContainerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            imageView.topAnchor.constraint(equalTo: imageContainerView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: imageContainerView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: imageContainerView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: imageContainerView.heightAnchor, multiplier: 0.75),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 2),
            titleLabel.leadingAnchor.constraint(equalTo: imageContainerView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: imageContainerView.trailingAnchor, constant: -8),
            
            ratingLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            ratingLabel.leadingAnchor.constraint(equalTo: imageContainerView.leadingAnchor, constant: 8),
            ratingLabel.trailingAnchor.constraint(equalTo: imageContainerView.trailingAnchor, constant: -8),
            
            yearLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            yearLabel.trailingAnchor.constraint(equalTo: imageContainerView.trailingAnchor, constant: -8),
            yearLabel.bottomAnchor.constraint(equalTo: imageContainerView.bottomAnchor, constant: -8)
        ])
    }
    
    
    func configure(with movie: MovieModel) {
        titleLabel.text = movie.title
        yearLabel.text = movie.releaseDate.extractYear()
        ratingLabel.text = "\(movie.voteAverage.formatRating())/10"
        guard let url = URL(string: "\(NetworkConstants.imageUrl.rawValue + movie.poster)") else { return }
        imageView.load(url: url)
    }
}
