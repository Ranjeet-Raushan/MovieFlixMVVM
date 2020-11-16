//  MovieDetailVC.swift
//  MovieFlix
//  Created by Ranjeet Raushan on 22/06/2020.
//  Copyright © 2020 Ranjeet Raushan. All rights reserved.

import UIKit

class MovieDetailVC: UIViewController {
    
    @IBOutlet weak var moviePosterImageView: UIImageView!
    
    @IBOutlet weak var movieTitleLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    var movie: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showData()
        
        self.navigationController?.navigationBar.isHidden = false
    }
    
    private func showData() {
        DispatchQueue.main.async {
            if let imageString = self.movie?.posterPath {
                if let url = URL(string: NetworkManager.moviePoster + imageString) {
                    self.moviePosterImageView.load(url: url)
                }
            }
            self.movieTitleLabel.text = self.movie?.title ?? "N/A"
            self.dateLabel.text = self.movie?.releaseDate ?? "N/A"
            self.descriptionLabel.text = self.movie?.overview ?? "N/A"
        }
    }
    
    class func instantiate(movieDetail: Movie) -> MovieDetailVC {
        let vc = MovieDetailVC.instantiate(fromAppStoryboard: .Main)
        vc.movie = movieDetail
        return vc
    }
}
