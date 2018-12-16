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
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
