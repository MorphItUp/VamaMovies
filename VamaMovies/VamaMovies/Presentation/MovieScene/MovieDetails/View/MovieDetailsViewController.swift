//
//  MovieDetailsViewController.swift
//  VamaMovies
//
//  Created by Mohamed Elgedawy on 07/07/2024.
//

import UIKit
import Combine

class MovieDetailsViewController: UIViewController, StoryboardInstantiable {

    var movie: MovieDetailsModel!
    
    private var viewModel: MovieDetailsViewModel!
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    let posterContainerView = UIView()
    let posterImageView = UIImageView()
    let titleLabel = UILabel()
    let descriptionView = UIView()
    let descriptionLabel = UILabel()
    
    private var subscriptions = Set<AnyCancellable>()
    
//    init(movie: MovieDetailsModel) {
//        self.movie = movie
//        super.init(nibName: nil, bundle: nil)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
    // MARK: - Lifecycle
    
    static func create(with viewModel: MovieDetailsViewModel) -> MovieDetailsViewController {
        let view = MovieDetailsViewController.instantiateViewController()
        view.viewModel = viewModel
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGray6
        
        viewModel.$state.sink { state in
            switch state {
            case .content(let movieModel):
                self.movie = movieModel
                self.configureUI()
            default:
                break
            }
        }
        .store(in: &subscriptions)
        
        
        viewModel.configure()
        
        setupScrollView()
        setupPosterImageView()
        setupPosterContainerView()
        setupTitleLabel()
        setupDescriptionView()
        setupDescriptionLabel()
        
        layoutUI()
        addGradientToPosterImageView()
//        configureUI()
    }
    
    func setupScrollView() {
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
    
    func setupPosterContainerView() {
        posterContainerView.layer.shadowColor = UIColor.black.cgColor
        posterContainerView.layer.shadowOpacity = 0.5
        posterContainerView.layer.shadowOffset = CGSize(width: 0, height: 12)
        posterContainerView.layer.shadowRadius = 14
        posterContainerView.layer.cornerRadius = 12
        posterContainerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(posterContainerView)
    }
    
    func setupPosterImageView() {
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
        posterImageView.layer.cornerRadius = 12
        
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        posterContainerView.addSubview(posterImageView)
    }
    
    func setupTitleLabel() {
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
    }
    
    func setupDescriptionView() {
        descriptionView.backgroundColor = .white
        descriptionView.layer.shadowColor = UIColor.black.cgColor
        descriptionView.layer.shadowOpacity = 0.1
        descriptionView.layer.shadowOffset = CGSize(width: 5, height: 4)
        descriptionView.layer.shadowRadius = 4
        descriptionView.layer.cornerRadius = 8
        descriptionView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(descriptionView)
    }
    
    func setupDescriptionLabel() {
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionView.addSubview(descriptionLabel)
    }
    
    func layoutUI() {
        NSLayoutConstraint.activate([
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            posterImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            posterImageView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            posterImageView.heightAnchor.constraint(equalToConstant: 450),
           
            descriptionView.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 32),
            descriptionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            descriptionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            descriptionLabel.topAnchor.constraint(equalTo: descriptionView.topAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: descriptionView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: descriptionView.trailingAnchor, constant: -16),
            descriptionLabel.bottomAnchor.constraint(equalTo: descriptionView.bottomAnchor, constant: -16)
        ])
    }
    
    func configureUI() {
        titleLabel.text = movie.title
        descriptionLabel.text = movie.overview
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(movie.posterPath)") else { return }
        posterImageView.load(url: url)
    }
    
    private func addGradientToPosterImageView() {
           let gradientLayer = CAGradientLayer()
           gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.7).cgColor]
           gradientLayer.locations = [0.7, 1.0]
           gradientLayer.frame = posterImageView.bounds
           gradientLayer.cornerRadius = posterImageView.layer.cornerRadius
           gradientLayer.masksToBounds = true
           
           posterImageView.layer.addSublayer(gradientLayer)
       }
       
       override func viewDidLayoutSubviews() {
           super.viewDidLayoutSubviews()
           // Ensure the gradient layer resizes with the image view
           posterImageView.layer.sublayers?.first { $0 is CAGradientLayer }?.frame = posterImageView.bounds
       }
}

