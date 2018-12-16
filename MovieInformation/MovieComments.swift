
//
//  Comment.swift
//  MovieInformation
//
//  Created by Apple on 2018. 12. 17..
//  Copyright © 2018년 Nowstring. All rights reserved.
//

import Foundation

struct MovieComments: Codable {
    let comments: [MovieComment]
}

struct MovieComment: Codable {
    
    let rating: Double
    let timeStamp: Double
    let writer: String
    let movieID: String
    let contents: String
    
    enum CodingKeys: String, CodingKey {
        case rating, writer, contents
        case timeStamp = "timestamp"
        case movieID = "movie_id"
    }
    
}
