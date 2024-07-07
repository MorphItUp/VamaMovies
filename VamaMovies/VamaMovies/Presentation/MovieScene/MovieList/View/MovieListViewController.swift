//
//  MovieListViewController.swift
//  VamaMovies
//
//  Created by Mohamed Elgedawy on 06/07/2024.
//

import UIKit
import Combine

enum Section {
    case main
}

class MovieListViewController: UIViewController, StoryboardInstantiable {
    
    private var subscriptions = Set<AnyCancellable>()
    private var collectionView: UICollectionView!
    private var searchBar: UISearchBar!
    private var activityIndicator: UIActivityIndicatorView!
    private var isSearching = false
    private var movies: [MovieModel] = []
    private var filteredMovies: [MovieModel] = []
    private var viewModel: MovieListViewModel!
    private var dataSource: UICollectionViewDiffableDataSource<Section, MovieModel>!

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
        setupDataSource()
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
                           self.applySnapshot(animatingDifferences: true)
                       }
                   } else {
                       fetchSearhedMovies(with: query)
                   }
               }
               .store(in: &subscriptions)
       }
    
    private func composeState() {
        
        viewModel.$snapshot.sink { [weak self] snapshot in
            guard let self else { return }
            dataSource.apply(snapshot, animatingDifferences: true)
            
            if isSearching {
                filteredMovies = snapshot.itemIdentifiers
            } else {
                movies = snapshot.itemIdentifiers
            }
          
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
        }
        .store(in: &subscriptions)
        
        viewModel.$state.sink { [weak self] state in
            switch state {
            case .loading:
                DispatchQueue.main.async {
                    self?.activityIndicator.startAnimating()
                }
            default:
                break
            }
        }
        .store(in: &subscriptions)
    }
    
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, MovieModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(self.movies, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    private func applySnapshotWithSearchResults() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, MovieModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(self.filteredMovies, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true)
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
        let layout = createCompositionalLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.reuseIdentifier)
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
    
    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, MovieModel>(collectionView: collectionView) { collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.reuseIdentifier, for: indexPath) as! MovieCell
            cell.configure(with: item)
            return cell
        }
    }
    
    private func applySnapshot(animatingDifferences: Bool) {
           var snapshot = NSDiffableDataSourceSnapshot<Section, MovieModel>()
           snapshot.appendSections([.main])
           
           if isSearching {
               snapshot.appendItems(filteredMovies)
           } else {
               snapshot.appendItems(movies)
           }
           
           dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
       }
      
      private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
          let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
          let item = NSCollectionLayoutItem(layoutSize: itemSize)
          item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
          
          let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.75))
          let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
          
          let section = NSCollectionLayoutSection(group: group)
          
          return UICollectionViewCompositionalLayout(section: section)
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
