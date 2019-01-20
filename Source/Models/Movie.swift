//
//  Movies.swift
//  MovieInformation
//
//  Created by Apple on 2018. 12. 15..
//  Copyright © 2018년 Nowstring. All rights reserved.
//

import Foundation

struct MovieResult: Codable{
    
    let orderType: Int
    let movies : [Movie]
    
    enum CodingKeys: String, CodingKey{
        case movies
        case orderType = "order_type"
    }
    
}

struct Movie: Codable {
    
    let grade: Int
    let thumb: String
    let reservationGrade: Int
    let title: String
    let reservationRate: Double
    let userRating: Double
    let date: String
    let id: String
    
    enum CodingKeys: String, CodingKey{
        case grade, thumb, title, date, id
        case reservationGrade = "reservation_grade"
        case reservationRate = "reservation_rate"
        case userRating = "user_rating"
    }

}


