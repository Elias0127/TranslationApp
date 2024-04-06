//
//  TranslationAppApp.swift
//  TranslationApp
//
//  Created by Elias Woldie on 4/5/24.
//

import SwiftUI
import Firebase

@main
struct TranslationAppApp: App {
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
