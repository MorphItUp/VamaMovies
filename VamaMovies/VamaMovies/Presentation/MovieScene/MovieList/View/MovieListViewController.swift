//
//  MovieListViewController.swift
//  VamaMovies
//
//  Created by Mohamed Elgedawy on 06/07/2024.
//

import UIKit
import Combine

class MovieListViewController: UIViewController, StoryboardInstantiable {
    
    private var subscriptions = Set<AnyCancellable>()
    private var collectionView: UICollectionView!
    private var searchBar: UISearchBar!
    private var activityIndicator: UIActivityIndicatorView!
    private var isSearching = false
    private var movies: [MovieModel] = []
    private var filteredMovies: [MovieModel] = []
    private var viewModel: MovieListViewModel!
    
    private var searchQuerySubject = PassthroughSubject<String, Never>()
    
    // MARK: - Lifecycle
    
    static func create(with viewModel: MovieListViewModel) -> MovieListViewController {
        let view = MovieListViewController.instantiateViewController()
        view.viewModel = viewModel
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSearchSubscription()
        setupSearchBar()
        setupCollectionView()
        setupActivityIndicator()
        composeState()
        fetchMovieList()
    }
    
    // MARK: - Fetch MovieList
    
    private func fetchMovieList() {
        Task {
            await viewModel.getMovieList()
        }
    }
    
    private func fetchSearhedMovies(with query: String) {
        Task {
            await viewModel.searchMovie(with: query)
        }
    }
    
    private func setupSearchSubscription() {
           searchQuerySubject
            .debounce(for: .seconds(1.5), scheduler: RunLoop.main)
               .removeDuplicates()
               .sink { [weak self] query in
                   guard let self = self else { return }
                   if query.isEmpty {
                       isSearching = false
                       DispatchQueue.main.async {
                           self.collectionView.reloadData()
                       }
                   } else {
                       fetchSearhedMovies(with: query)
                   }
               }
               .store(in: &subscriptions)
       }
    
    private func composeState() {
        viewModel.$state.sink { state in
            switch state {
            case .content(let movieModel):
                if self.isSearching {
                    self.filteredMovies = movieModel
                } else {
                    self.movies = movieModel
                }
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
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
    
    private func setupSearchBar() {
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
    
    private func setupCollectionView() {
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
    
    private func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

// MARK: - UICollectionView DataSource

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

// MARK: - UICollectionView Delegate

extension MovieListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = isSearching ? filteredMovies[indexPath.item] : movies[indexPath.item]
        viewModel.selectedMovieHandler(movie.id)
    }
}

// MARK: - UISearchBar Delegate

extension MovieListViewController: UISearchBarDelegate {
   func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
       isSearching = !searchText.isEmpty
       searchQuerySubject.send(searchText)
       }
}
