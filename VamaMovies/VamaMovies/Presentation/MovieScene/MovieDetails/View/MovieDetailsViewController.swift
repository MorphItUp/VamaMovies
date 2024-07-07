//
//  MovieDetailsViewController.swift
//  VamaMovies
//
//  Created by Mohamed Elgedawy on 07/07/2024.
//

import UIKit
import Combine

class MovieDetailsViewController: UIViewController, StoryboardInstantiable {
    
    private var movie: MovieDetailsModel!
    private var viewModel: MovieDetailsViewModel!
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let posterContainerView = UIView()
    private let posterImageView = UIImageView()
    private let titleLabel = UILabel()
    private let genreLabel = UILabel()
    private let runtimeLabel = UILabel()
    private let aboutTheMovieLabel = UILabel()
    private let descriptionView = UIView()
    private let separatorLine = UIView()
    private let descriptionLabel = UILabel()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Lifecycle
    
    static func create(with viewModel: MovieDetailsViewModel) -> MovieDetailsViewController {
        let view = MovieDetailsViewController.instantiateViewController()
        view.viewModel = viewModel
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        setupScrollView()
        setupPosterImageView()
        setupPosterContainerView()
        setupTitleLabel()
        setupGenreLabel()
        setupRuntimeLabel()
        setupSeparatorLine()
        setupAboutTheMovieLabel()
        setupDescriptionView()
        setupDescriptionLabel()
        setupActivityIndicator()
        layoutUI()
        
        composeState()
        fetchMovieDetails()
    }
    
    // MARK: - Fetch MovieDetails
    
    private func fetchMovieDetails() {
        Task {
            await viewModel.configure()
        }
    }
    
    private func composeState() {
        viewModel.$state.sink { state in
            switch state {
            case .content(let movieModel):
                self.movie = movieModel
                DispatchQueue.main.async {
                    self.configureUI()
                    self.activityIndicator.stopAnimating()
                }
            case .loading:
                DispatchQueue.main.async {
                    self.activityIndicator.startAnimating()
                }
            default:
                break
            }
        }
        .store(in: &subscriptions)
    }
    
    // MARK: - Setup UI
    
    private func configureUI() {
        titleLabel.text = movie.title
        descriptionLabel.text = movie.overview
        genreLabel.text = movie.genres.compactMap { genre in
            genre.name
        }.joined(separator: ", ")
        runtimeLabel.text = "\(movie.runtime.toMovieRuntime())"
        
        guard let url = URL(string: "\(NetworkConstants.imageUrlOriginal.rawValue + movie.posterPath)") else { return }
        posterImageView.load(url: url)
    }
    
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func setupPosterContainerView() {
        posterContainerView.layer.shadowColor = UIColor.black.cgColor
        posterContainerView.layer.shadowOpacity = 0.5
        posterContainerView.layer.shadowOffset = CGSize(width: 0, height: 12)
        posterContainerView.layer.shadowRadius = 14
        posterContainerView.layer.cornerRadius = 12
        posterContainerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(posterContainerView)
    }
    
    private func setupPosterImageView() {
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
        posterImageView.layer.cornerRadius = 12
        
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        posterContainerView.addSubview(posterImageView)
    }
    
    private func setupTitleLabel() {
        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .heavy, width: .standard)
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionView.addSubview(titleLabel)
    }
    
    private func setupGenreLabel() {
        genreLabel.font = UIFont.systemFont(ofSize: 14, weight: .light, width: .standard)
        genreLabel.textColor = .darkGray
        genreLabel.numberOfLines = 0
        genreLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionView.addSubview(genreLabel)
    }
    
    private func setupRuntimeLabel() {
        runtimeLabel.font = UIFont.systemFont(ofSize: 14, weight: .light, width: .standard)
        runtimeLabel.textColor = .darkGray
        runtimeLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionView.addSubview(runtimeLabel)
    }
    
    private func setupSeparatorLine() {
        separatorLine.backgroundColor = .systemGray3
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        descriptionView.addSubview(separatorLine)
    }
    
    private func setupAboutTheMovieLabel() {
        aboutTheMovieLabel.text = "About the movie"
        aboutTheMovieLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold, width: .standard)
        aboutTheMovieLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionView.addSubview(aboutTheMovieLabel)
    }
    
    private func setupDescriptionView() {
        descriptionView.backgroundColor = .white
        descriptionView.layer.shadowColor = UIColor.black.cgColor
        descriptionView.layer.shadowOpacity = 0.1
        descriptionView.layer.shadowOffset = CGSize(width: 5, height: 4)
        descriptionView.layer.shadowRadius = 4
        descriptionView.layer.cornerRadius = 8
        descriptionView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(descriptionView)
    }
    
    private func setupDescriptionLabel() {
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.textColor = .darkGray
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionView.addSubview(descriptionLabel)
    }
    
    private func setupActivityIndicator() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func layoutUI() {
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            posterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            posterImageView.heightAnchor.constraint(equalToConstant: 500),
            
            descriptionView.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 32),
            descriptionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            descriptionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            titleLabel.topAnchor.constraint(equalTo: descriptionView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: descriptionView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: descriptionView.trailingAnchor, constant: -16),
            
            genreLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            genreLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            genreLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            runtimeLabel.topAnchor.constraint(equalTo: genreLabel.bottomAnchor, constant: 4),
            runtimeLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            runtimeLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            separatorLine.topAnchor.constraint(equalTo: runtimeLabel.bottomAnchor, constant: 16),
            separatorLine.leadingAnchor.constraint(equalTo: descriptionView.leadingAnchor, constant: 16),
            separatorLine.trailingAnchor.constraint(equalTo: descriptionView.trailingAnchor, constant: -16),
            separatorLine.heightAnchor.constraint(equalToConstant: 1),
            
            aboutTheMovieLabel.topAnchor.constraint(equalTo: separatorLine.bottomAnchor, constant: 16),
            aboutTheMovieLabel.leadingAnchor.constraint(equalTo: descriptionView.leadingAnchor, constant: 16),
            aboutTheMovieLabel.trailingAnchor.constraint(equalTo: descriptionView.trailingAnchor, constant: -16),
            
            descriptionLabel.topAnchor.constraint(equalTo: aboutTheMovieLabel.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: descriptionView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: descriptionView.trailingAnchor, constant: -16),
            descriptionLabel.bottomAnchor.constraint(equalTo: descriptionView.bottomAnchor, constant: -16)
        ])
    }
}

