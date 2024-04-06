//
//  TranslationHistoryView.swift
//  TranslationApp
//
//  Created by Elias Woldie on 4/5/24.
//

import Foundation
import SwiftUI

struct TranslationHistoryView: View {
    @Binding var translationHistory: [Translation]
    var firestoreManager: FirestoreManager
    
    var body: some View {
        VStack {
            Spacer()
            if translationHistory.isEmpty {
                Text("No translations yet.")
                    .foregroundColor(.gray)
                Spacer()
            } else {
                List {
                    ForEach(translationHistory) { translation in
                        VStack(alignment: .leading) {
                            Text(translation.originalText)
                                .fontWeight(.bold)
                            Text(translation.translatedText)
                                .foregroundColor(.gray)
                        }
                    }
                    .onDelete(perform: removeTranslations) 
                }
            }
            Button("Erase All History") {
                firestoreManager.deleteAllTranslations()
                translationHistory.removeAll()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .navigationBarTitle("Translation History", displayMode: .inline)
    }

    // Function to remove translations from the history and Firestore
    private func removeTranslations(at offsets: IndexSet) {
        // Remove from Firestore first
        offsets.forEach { index in
            let translationID = translationHistory[index].id
            firestoreManager.deleteTranslation(withId: translationID)
        }
        // Then remove from local history
        translationHistory.remove(atOffsets: offsets)
    }
}
