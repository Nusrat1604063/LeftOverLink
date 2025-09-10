//
//  MapSearchViewModel.swift
//  MapMonitoring
//
//  Created by Tabassum Akter Nusrat on 9/8/25.
//

import Foundation
import Observation

@MainActor
@Observable
class MapSearchViewModel : ObservableObject {
    var query: String = "" {
        didSet {
            debounceSearch()
        }
    }
    
    private var debounceTask: Task<Void, Never>? = nil
    
    var rawResults: [NominatimPlace] = []
    
    var filteredResults: [NominatimPlace] {
        rawResults.filter { isValidPlace($0) }
    }
    
    var isSearching = false
    
    func debounceSearch() {
        debounceTask?.cancel()
        
        guard query.count >= 3 else {
            rawResults = []
            return
        }
        
        debounceTask = Task {
            try? await Task.sleep(nanoseconds: 400_000_000) // 0.4 sec debounce
            await performSearch()
        }
    }
    
    func performSearch() async {
        isSearching = true
        do {
            let results = try await nominatimSearch(query: query)
            rawResults = results
        } catch {
            rawResults = []
        }
        isSearching = false
    }
    
    func isValidPlace(_ place: NominatimPlace) -> Bool {
        // Example filter: non-empty display name & valid coordinates
        !place.display_name.isEmpty &&
        place.coordinate.latitude != 0 &&
        place.coordinate.longitude != 0
    }
}


