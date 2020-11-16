//  MovieListVC.swift
//  MovieFlix
//  Created by Ranjeet Raushan on 22/06/2020.
//  Copyright © 2020 Ranjeet Raushan. All rights reserved.

import UIKit

class MovieListVC: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchTextField: UITextField!
    
    private var moviesListViewModel: MovieListViewModel? = MovieListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTextField.addTarget(self, action: #selector(MovieListVC.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        searchTextField.delegate = self
        
        configureTableView()
        
        getMovies()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func getMovies() {
        moviesListViewModel?.getMoviesNowPlaying(completion: { (response) in
            let movies = Movie.toModel(response.result)
            self.moviesListViewModel?.moviesViewModel = movies?.compactMap({ $0 })
            self.moviesListViewModel?.searchedMovies = movies?.compactMap({ $0 })
            
            DispatchQueue.main.async {
                self.reloadTableView()
            }
        })
    }
}

extension MovieListVC: UITextFieldDelegate {
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        if let searchText = textField.text, !searchText.isEmpty {
            self.moviesListViewModel?.searchedMovies = moviesListViewModel?.moviesViewModel?.filter {
                ($0.title?.lowercased().contains(searchText.lowercased()) ?? false)
            }
        } else {
            self.moviesListViewModel?.searchedMovies = moviesListViewModel?.moviesViewModel
        }
        
        self.reloadTableView()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension MovieListVC: UITableViewDataSource, UITableViewDelegate {
    func configureTableView() {
        DispatchQueue.main.async {
          
            self.tableView.separatorStyle = .none
            self.tableView.dataSource = self
            self.tableView.delegate = self
            
            self.tableView.register(UINib(nibName: MoviesListTableViewCell.identifier(), bundle: nil), forCellReuseIdentifier: MoviesListTableViewCell.identifier())
            
            self.tableView.rowHeight = UITableView.automaticDimension
            self.tableView.estimatedRowHeight = 150
            
            self.tableView.reloadData()
        }
    }
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func getMoviesTableViewCell(indexPath: IndexPath) -> MoviesListTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String("MoviesListTableViewCell"), for: indexPath) as! MoviesListTableViewCell
        
        let movie = moviesListViewModel?.searchedMovies?[indexPath.row]
        
        cell.movie = movie
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = moviesListViewModel?.searchedMovies?.count ?? 0
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return getMoviesTableViewCell(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let movie = self.moviesListViewModel?.moviesViewModel?[indexPath.row] else { return }
        self.navigationController?.pushViewController(MovieDetailVC.instantiate(movieDetail: movie), animated: true)
    }
}
