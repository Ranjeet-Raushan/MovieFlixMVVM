//  MovieListViewModel.swift
//  MovieFlix
//  Created by Ranjeet Raushan on 22/06/2020.
//  Copyright © 2020 Ranjeet Raushan. All rights reserved.

import UIKit

class MovieListViewModel {
    
    var moviesViewModel: [Movie]?
    
    var searchedMovies: [Movie]?
    
}

extension MovieListViewModel {
    func getMoviesNowPlaying(completion: @escaping (ApiResponse) -> ()) {
        NetworkManager.getNowPlayingList { (response) in
            guard let response = response else { return }
            completion(response)
        }
    }
}
