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
    private let genreLabel = UILabel()
    
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
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        imageContainerView.addSubview(titleLabel)
    }
    
    private func setupYearLabel() {
        yearLabel.font = UIFont.systemFont(ofSize: 12)
        yearLabel.textColor = .black
        yearLabel.translatesAutoresizingMaskIntoConstraints = false
        imageContainerView.addSubview(yearLabel)
    }
   
    private func setupGenreLabel() {
        genreLabel.font = UIFont.systemFont(ofSize: 10)
        genreLabel.textColor = .black
        genreLabel.numberOfLines = 0
        genreLabel.translatesAutoresizingMaskIntoConstraints = false
        imageContainerView.addSubview(genreLabel)
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
            imageView.heightAnchor.constraint(equalTo: imageContainerView.heightAnchor, multiplier: 0.7),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 2),
            titleLabel.leadingAnchor.constraint(equalTo: imageContainerView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: imageContainerView.trailingAnchor, constant: -8),
            
            genreLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            genreLabel.leadingAnchor.constraint(equalTo: imageContainerView.leadingAnchor, constant: 8),
            genreLabel.trailingAnchor.constraint(equalTo: imageContainerView.trailingAnchor, constant: -8),
            
            yearLabel.topAnchor.constraint(equalTo: genreLabel.bottomAnchor, constant: 4),
            yearLabel.leadingAnchor.constraint(equalTo: imageContainerView.leadingAnchor, constant: 8),
            yearLabel.trailingAnchor.constraint(equalTo: imageContainerView.trailingAnchor, constant: -8),
            yearLabel.bottomAnchor.constraint(equalTo: imageContainerView.bottomAnchor, constant: -8)
        ])
    }
    
    
    func configure(with movie: MovieModel) {
        titleLabel.text = movie.title
        yearLabel.text = movie.releaseDate.extractYear()
        genreLabel.text = movie.overview
        guard let url = URL(string: "\(NetworkConstants.imageUrl.rawValue + movie.poster)") else { return }
        imageView.load(url: url)
    }
}
