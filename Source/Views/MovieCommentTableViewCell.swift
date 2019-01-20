//
//  MovieCommentTableViewCell.swift
//  MovieInformation
//
//  Created by Apple on 2018. 12. 16..
//  Copyright © 2018년 Nowstring. All rights reserved.
//

import UIKit

class MovieCommentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userIDLabel: UILabel!
    @IBOutlet weak var commentDateLabel: UILabel!
    @IBOutlet weak var commentContentLabel: UILabel!
    @IBOutlet weak var starNumber1: UIImageView!
    @IBOutlet weak var starNumber2: UIImageView!
    @IBOutlet weak var starNumber3: UIImageView!
    @IBOutlet weak var starNumber4: UIImageView!
    @IBOutlet weak var starNumber5: UIImageView!
    @IBOutlet weak var userThumbnailImage: UIImageView!
    
    public var movieComment: MovieComment? {
        didSet {
            guard let movieComment = movieComment else { return }
            
            self.userIDLabel?.text = movieComment.writer
            
            let date = Date(timeIntervalSince1970: movieComment.timeStamp)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let stringDate = dateFormatter.string(from: date)
            
            self.commentDateLabel?.text = stringDate
            self.commentContentLabel?.text = movieComment.contents
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
