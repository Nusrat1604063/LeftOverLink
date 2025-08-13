//
//  Appstate.swift
//  LEFTOVERLINK
//
//  Created by Tabassum Akter Nusrat on 2/7/25.
//

import SwiftUI

enum Route: Hashable {
    case signup
    case login
    case profile
    case welcome
    case donationpost
    case homepage
    case feedaStray
    
}

class Appstate: ObservableObject {
    @Published var routes : [Route] = [] {
        didSet {
            print("Appstate.routes updated:", routes)
        }
    }
}
