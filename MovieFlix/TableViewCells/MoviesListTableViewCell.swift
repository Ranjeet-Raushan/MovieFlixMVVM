//  MoviesListTableViewCell.swift
//  MovieFlix
//  Created by Ranjeet Raushan on 22/06/2020.
//  Copyright © 2020 Ranjeet Raushan. All rights reserved.

import UIKit

class MoviesListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var movieImageView: UIImageView!
    
    @IBOutlet weak var movieDescriptionLabel: UILabel!
    
    @IBOutlet weak var movieTitleLabel: UILabel!
    
    var movie: Movie? {
        didSet {
            DispatchQueue.main.async {
                if let imageString = self.movie?.posterPath {
                    if let url = URL(string: NetworkManager.moviePoster + imageString) {
                        self.movieImageView.load(url: url)
                    }
                }
                
                self.movieTitleLabel.text = self.movie?.title ?? "N/A"
                self.movieDescriptionLabel.text = self.movie?.overview ?? "N/A"
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
