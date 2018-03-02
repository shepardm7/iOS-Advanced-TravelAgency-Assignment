//
//  Country.swift
//  TravelAgency
//
//  Created by Sateek Roy on 2017-07-11.
//  Copyright © 2017 SateekLambton. All rights reserved.
//

import Foundation

class Country {
    public private(set) var countryName    : String
    public private(set) var latitude       : Double
    public private(set) var longitude      : Double
    
    init(name: String, latitude: Double, longitude: Double){
        self.countryName = name
        self.latitude = latitude
        self.longitude = longitude
    }
    
    func getCountryName() -> String{
        return self.countryName
    }
    
    func getLatitude() -> Double {
        return self.latitude
    }
    
    func getLongitude() -> Double {
        return self.longitude
    }
    
}
