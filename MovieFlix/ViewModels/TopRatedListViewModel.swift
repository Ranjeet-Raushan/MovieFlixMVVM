//  TopRatedListViewModel.swift
//  MovieFlix
//  Created by Ranjeet Raushan on 22/06/2020.
//  Copyright © 2020 Ranjeet Raushan. All rights reserved.

import UIKit

class TopRatedListViewModel {
    
    var topRatedMoviesViewModel: [Movie]?
    
    var searchedMovies: [Movie]?
    
}

extension TopRatedListViewModel {
    func getTopRatedMovies(completion: @escaping (ApiResponse) -> ()) {
        NetworkManager.getTopRatedList { (response) in
            guard let response = response else { return }
            completion(response)
        }
    }
}
