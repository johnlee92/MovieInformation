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
    
    public var currentMovie: Movie? {
        didSet {
            guard let currentMovie = currentMovie else { return }
            
            self.movieTitleLabel?.text = currentMovie.title
            
            if currentMovie.grade == 0 {
                self.movieAgeRestrict?.image = UIImage(named: "ic_allages")
            } else {
                self.movieAgeRestrict?.image = UIImage(named: "ic_\(currentMovie.grade)")
            }
            self.movieDataLabel?.text = "\(currentMovie.date) 개봉"
            self.movieReservationRate?.text = "\(currentMovie.reservationGrade)위 \(currentMovie.reservationRate)%"
            self.movieUserRating?.text = "\(currentMovie.userRating)"
        }
    }
    
    public var movieDetail: MovieDetail? {
        didSet {
            guard let movieDetail = movieDetail else { return }
            
            self.genreRunningTimeLabel?.text = "\(movieDetail.genre)/\(movieDetail.duration)분"
            
            let withSeparator: NumberFormatter = {
                let formatter = NumberFormatter()
                formatter.groupingSeparator = ","
                formatter.numberStyle = .decimal
                return formatter
            }()
            
            let audience = withSeparator.string(from: movieDetail.audience as NSNumber)
            self.movieTotalViewer?.text = audience
        }
    }
    
    public var thumbImage: UIImage? {
        didSet {
            self.movieThumbnailImage.setImage(thumbImage, for: UIControl.State.normal)
        }
    }
    
    public var userRating: Double? {
        didSet {
            guard let rating = userRating else { return }
            
            if(rating >= 1){
                self.starNumber1.image = UIImage(named: "ic_star_large_half")
            }
            if(rating >= 2){
                self.starNumber1.image = UIImage(named: "ic_star_large_full")
            }
            if(rating >= 3){
                self.starNumber2.image = UIImage(named: "ic_star_large_half")
            }
            if(rating >= 4){
                self.starNumber2.image = UIImage(named: "ic_star_large_full")
            }
            if(rating >= 5){
                self.starNumber3.image = UIImage(named: "ic_star_large_half")
            }
            if(rating >= 6){
                self.starNumber3.image = UIImage(named: "ic_star_large_full")
            }
            if(rating >= 7){
                self.starNumber4.image = UIImage(named: "ic_star_large_half")
            }
            if(rating >= 8){
                self.starNumber4.image = UIImage(named: "ic_star_large_full")
            }
            if(rating >= 9){
                self.starNumber5.image = UIImage(named: "ic_star_large_half")
            }
            if(rating == 10){
                self.starNumber5.image = UIImage(named: "ic_star_large_full")
            }
        }
    }
   
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    
}
