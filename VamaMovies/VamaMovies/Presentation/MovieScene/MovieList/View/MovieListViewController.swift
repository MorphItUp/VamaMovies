//
//  MovieListViewController.swift
//  VamaMovies
//
//  Created by Mohamed Elgedawy on 06/07/2024.
//

import UIKit
import Combine

class MovieListViewController: UIViewController, StoryboardInstantiable, UISearchBarDelegate {
    
    private var viewModel: MovieListViewModel!
    
    var collectionView: UICollectionView!
    var searchBar: UISearchBar!
    var activityIndicator: UIActivityIndicatorView!
    var isSearching = false
    
    var movies: [MovieModel] = []
    
    var filteredMovies: [MovieModel] = []
    
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Lifecycle
    
    static func create(with viewModel: MovieListViewModel) -> MovieListViewController {
        let view = MovieListViewController.instantiateViewController()
        view.viewModel = viewModel
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        viewModel.$state.sink { state in
            switch state {
            case .content(let movieModel):
                self.movies = movieModel
                self.collectionView.reloadData()
            default:
                break
            }
        }
        .store(in: &subscriptions)
        
        viewModel.configure()
        
        setupSearchBar()
        setupCollectionView()
        setupActivityIndicator()
    }
    
    
    // MARK: - Setup UI
    
    func setupSearchBar() {
        searchBar = UISearchBar()
        searchBar.placeholder = "Search Movies"
        searchBar.delegate = self
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBar)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width / 2 - 16, height: view.frame.width / 2 * 1.5)
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.reuseIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
           if searchText.isEmpty {
               isSearching = false
               filteredMovies.removeAll()
               collectionView.reloadData()
           } else {
               isSearching = true
               filteredMovies = movies.filter { $0.title.lowercased().contains(searchText.lowercased()) }
               collectionView.reloadData()
           }
       }
}

extension MovieListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isSearching ? filteredMovies.count : movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.reuseIdentifier, for: indexPath) as! MovieCell
        let movie = isSearching ? filteredMovies[indexPath.item] : movies[indexPath.item]
        cell.configure(with: movie)
        return cell
    }
}

extension MovieListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = isSearching ? filteredMovies[indexPath.item] : movies[indexPath.item]
        
        viewModel.selectedMovieHandler(movie.id)
        // Navigate to detailed movie page
        // let detailVC = MovieDetailViewController(movie: movie)
        // navigationController?.pushViewController(detailVC, animated: true)
    }
}
