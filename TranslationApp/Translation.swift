//
//  Translation.swift
//  TranslationApp
//
//  Created by Elias Woldie on 4/5/24.
//

import Foundation

struct Translation: Identifiable {
    var id: String = UUID().uuidString
    var originalText: String
    var translatedText: String
    var timestamp: Date = Date()
}
