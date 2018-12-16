//
//  AppData.swift
//  MovieInformation
//
//  Created by Apple on 2018. 12. 15..
//  Copyright © 2018년 Nowstring. All rights reserved.
//

import Foundation



class UserPreference {
    
    public static var shared: UserPreference = UserPreference()
    
    enum Sorting: Int {
        case reservationRate = 0
        case curation = 1
        case date = 2
    }
    
    var sortingOption: Sorting = Sorting.reservationRate
    
    
    
}
