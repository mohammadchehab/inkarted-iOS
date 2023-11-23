//
//  CountryPicker.swift
//  kidzPlayground
//
//  Created by Mohammad_Shehab on 05/08/2023.
//

import Foundation
import SwiftUI


struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            TextField("Search", text: $text)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 8)
        }
        .padding(.horizontal)
    }
}


struct CountryPicker: View {
    @Binding var selectedCountry: Country
    @State private var searchText: String = ""
    @Binding var isPresented: Bool
    let countries: [Country] // List of all available countries

    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText)
                List(countries.filter { searchText.isEmpty ? true : $0.name.contains(searchText) }) { country in
                    Button(action: {
                        selectedCountry = country
                        isPresented = false
                    }) {
                        Text("\(country.name) (\(country.code))")
                    }
                }
            }
            .navigationBarItems(trailing: Button("Cancel") { isPresented = false })
            .navigationBarTitle("Choose Country", displayMode: .inline)
        }
    }
}
