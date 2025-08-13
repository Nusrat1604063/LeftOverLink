//
//  Model.swift
//  LEFTOVERLINK
//
//  Created by Tabassum Akter Nusrat on 1/7/25.
//

import Foundation
import FirebaseAuth

class Model: ObservableObject {
    func updateDisplayName(for user: User, dsiplayName: String) async throws {
        let request = user.createProfileChangeRequest()
        request.displayName = dsiplayName
        try await request.commitChanges()
    }
}
