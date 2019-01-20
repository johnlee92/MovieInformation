//
//  MoviesTableViewCell.swift
//  MovieInformation
//
//  Created by Apple on 2018. 12. 15..
//  Copyright © 2018년 Nowstring. All rights reserved.
//

import UIKit

class MoviesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var ageRestrictImage: UIImageView!
    
    public var movie: Movie? {
        didSet {
            guard let movie = movie else { return }
            
            self.thumbnailImage.image = UIImage(named: "img_placeholder")
            self.titleLabel?.text = movie.title
            self.detailLabel?.text = "평점 : \(movie.userRating) 예매순위 : \(movie.reservationGrade) 예매율 : \(movie.reservationRate)"
            self.dateLabel?.text = "개봉일 : \(movie.date)"
            if movie.grade == 0 {
                self.ageRestrictImage?.image = UIImage(named: "ic_allages")
            } else {
                self.ageRestrictImage?.image = UIImage(named: "ic_\(movie.grade)")
            }
        }
    }
    
    public var thumbImage: UIImage? {
        didSet {
            self.thumbnailImage.image = thumbImage
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
