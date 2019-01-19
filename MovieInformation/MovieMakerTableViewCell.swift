//
//  MovieMakerTableViewCell.swift
//  MovieInformation
//
//  Created by Apple on 2018. 12. 16..
//  Copyright © 2018년 Nowstring. All rights reserved.
//

import UIKit

class MovieMakerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var movieDirectorLabel: UILabel!
    @IBOutlet weak var movieActorLabel: UILabel!
    
    var movieDetail: MovieDetail? {
        didSet {
            guard let movieDetail = movieDetail else { return }
            
            self.movieDirectorLabel?.text = movieDetail.director
            self.movieActorLabel?.text = movieDetail.actor
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
  
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
