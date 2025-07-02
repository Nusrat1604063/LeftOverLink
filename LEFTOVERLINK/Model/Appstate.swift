//
//  Appstate.swift
//  LEFTOVERLINK
//
//  Created by Tabassum Akter Nusrat on 2/7/25.
//

import Foundation
enum Route: Hashable {
    case signup
    case login
    case profile
    case welcome
    
}
class Appstate: ObservableObject {
    @Published var routes: [Route] = []
}
