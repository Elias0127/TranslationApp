//
//  NetworkManager.swift
//  TranslationApp
//
//  Created by Elias Woldie on 4/5/24.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    
    func translate(text: String, from sourceLanguage: String, to targetLanguage: String, completion: @escaping (String?) -> Void) {
        let sourceLanguageCode = languageCode(for: sourceLanguage)
        let targetLanguageCode = languageCode(for: targetLanguage)
        
        let urlString = "https://api.mymemory.translated.net/get?q=\(text)&langpair=\(sourceLanguageCode)|\(targetLanguageCode)"
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            if let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let responseData = jsonResponse["responseData"] as? [String: Any],
               let translatedText = responseData["translatedText"] as? String {
                DispatchQueue.main.async {
                    completion(translatedText)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }.resume()
    }
    
    func languageCode(for language: String) -> String {
        switch language {
        case "English": return "en"
        case "Spanish": return "es"
        case "Amharic": return "am"
        case "French": return "fr"
        case "German": return "de"
        case "Italian": return "it"
        default: return "en"
        }
    }
}
