//
//  NetworkManager.swift
//  TranslationApp
//
//  Created by Elias Woldie on 4/5/24.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    
    func translate(text: String, completion: @escaping (String?) -> Void) {
        let urlString = "https://api.mymemory.translated.net/get?q=\(text)&langpair=en|es" // Replace "en|es" with your desired language pair
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
                completion(translatedText)
            } else {
                completion(nil)
            }
        }.resume()
    }
}
