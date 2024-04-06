//
//  ContentView.swift
//  TranslationApp
//
//  Created by Elias Woldie on 4/5/24.
//

import SwiftUI

struct ContentView: View {
    @State private var originalText: String = ""
    @State private var translatedText: String = ""
    @State private var translationHistory: [Translation] = []
    @StateObject private var firestoreManager = FirestoreManager()
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Translate Me")
                    .font(.largeTitle)
                    .padding()
                    .bold()


                TextField("Enter text", text: $originalText)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                Button(action: {
                    NetworkManager.shared.translate(text: originalText) { translatedText in
                        DispatchQueue.main.async {
                            self.translatedText = translatedText ?? "Translation failed"
                            let newTranslation = Translation(originalText: self.originalText, translatedText: self.translatedText)
                            self.firestoreManager.addTranslation(newTranslation)
                            self.translationHistory.insert(newTranslation, at: 0)
                        }
                    }
                }) {
                    Text("Translate Me")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.horizontal)

                Text(translatedText)
                    .padding()
                    .frame(maxWidth: .infinity, minHeight: 200)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .padding(.top, 50)

                Spacer()

                NavigationLink(destination: TranslationHistoryView(translationHistory: $translationHistory, firestoreManager: firestoreManager)) {
                    Text("View Saved Translations")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
            }
            .navigationBarHidden(true)
        }
        .onAppear {
            firestoreManager.fetchTranslations { translations in
                self.translationHistory = translations
            }
        }
    }
}





struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
