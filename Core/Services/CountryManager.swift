//
//  CountryManager.swift
//  kidzPlayground
//
//  Created by Mohammad_Shehab on 06/08/2023.
//

import Foundation

class CountryManager: ObservableObject {
    
    let countryList: [Country] = [
        Country(id: 1, name: "United Arab Emirates", code: "+971", example: "50 123 4567", size: 9, regexp: "^5[0-9]{8}$"),
        Country(id: 2, name: "Lebanon", code: "+961", example: "71 123 456", size: 8, regexp: "^[0-9]{8}$"),
        // Add more countries as needed
    ]
    
    
    @Published var countries: [Country];
    
    let defaultCountry: Country
    
    init(defaultCountryCode: String) {
        defaultCountry = countryList.first { $0.code == defaultCountryCode } ?? Country(id: 0, name: "", code: "", example: "", size: 0, regexp: "");
        
        self.countries = self.countryList;
    }
    
}

