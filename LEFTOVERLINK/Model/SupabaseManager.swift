//
//  SupabaseManager.swift
//  LEFTOVERLINK
//
//  Created by Tabassum Akter Nusrat on 11/7/25.
//

import Foundation
import Supabase

import Supabase

class SupabaseManager {
    static let shared = SupabaseManager()

    let client: SupabaseClient

    private init() {
        let supabaseURL = URL(string: "https://dvfdshfhxwomxqazflzw.supabase.co")!
        let supabaseKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImR2ZmRzaGZoeHdvbXhxYXpmbHp3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTIyMzE0OTIsImV4cCI6MjA2NzgwNzQ5Mn0.ezUPYHFMkOU5WrbCLrWvp0wu9xsdyEHEKMUHrgYdrJo"

        self.client = SupabaseClient(
            supabaseURL: supabaseURL,
            supabaseKey: supabaseKey
        )
    }
}

