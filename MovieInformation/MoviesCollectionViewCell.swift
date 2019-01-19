//
//  MoviesCollectionViewCell.swift
//  MovieInformation
//
//  Created by Apple on 2018. 12. 15..
//  Copyright © 2018년 Nowstring. All rights reserved.
//

import UIKit

class MoviesCollectionViewCell: UICollectionViewCell {
    
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
            self.detailLabel?.text = "\(movie.reservationGrade)위(\(movie.userRating)) / \(movie.reservationRate)%"
            self.dateLabel?.text = movie.date
            //cell.thumbnailImage.image = cachedImage[URL(string: movie.thumb)!] ?? UIImage(named: "img_placeholder")
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
        super .awakeFromNib()
    }
    
}
