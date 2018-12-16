//
//  MovieInfoTableViewCell.swift
//  MovieInformation
//
//  Created by Apple on 2018. 12. 16..
//  Copyright © 2018년 Nowstring. All rights reserved.
//

import UIKit

class MovieInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var movieThumbnailImage: UIButton!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieDataLabel: UILabel!
    @IBOutlet weak var genreRunningTimeLabel: UILabel!
    @IBOutlet weak var movieReservationRate: UILabel!
    @IBOutlet weak var movieUserRating: UILabel!
    @IBOutlet weak var movieTotalViewer: UILabel!
    @IBOutlet weak var movieAgeRestrict: UIImageView!
    
    @IBOutlet weak var starNumber1: UIImageView!
    @IBOutlet weak var starNumber2: UIImageView!
    @IBOutlet weak var starNumber3: UIImageView!
    @IBOutlet weak var starNumber4: UIImageView!
    @IBOutlet weak var starNumber5: UIImageView!
    
   
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    
}
