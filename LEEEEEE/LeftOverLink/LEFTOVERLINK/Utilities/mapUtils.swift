//
//  mapUtils.swift
//  MapMonitoring
//
//  Created by Tabassum Akter Nusrat on 25/7/25.
//

import Foundation
import CoreLocation

struct NominatimPlace : Decodable, Hashable {
    let place_id: Int
    let display_name: String
    let lat: String
    let lon: String
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: Double(lat) ?? 0, longitude: Double(lon) ?? 0)
    }
}

/*
 sends a GET request to the Nominatim API with the search query and gets a list of places matching that query.
 */

func nominatimSearch(query: String) async throws -> [NominatimPlace] {
    // Prepare URL with query and JSON format
    let escapedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "" //prepares a user’s search input
    let urlString = "https://nominatim.openstreetmap.org/search?q=\(escapedQuery)&format=json&addressdetails=1&limit=10" //return search result in JSon
    
    guard let url = URL(string: urlString) else {
        return []
    }
    
    // Create request with custom User-Agent as required by Nominatim's usage policy
    var request = URLRequest(url: url)
    request.setValue("MapMonitoring - nusratjahan6169@gmail.com", forHTTPHeaderField: "User-Agent")
    
    let (data, _) = try await URLSession.shared.data(for: request)
    let places = try JSONDecoder().decode([NominatimPlace].self, from: data)
    return places
}

