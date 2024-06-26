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
    @State private var showSuccess = false
    @State private var selectedSourceLanguage = "English"
    @State private var selectedTargetLanguage = "Spanish"
    let languages = ["English", "Spanish", "Amharic", "French", "German", "Italian"]
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Translate Me")
                    .font(.largeTitle)
                    .padding()
                    .foregroundColor(.blue)
                    .bold()

                TextField("Enter text", text: $originalText)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(Color(.systemGray6))
                    )
                    .padding(.horizontal)


                Picker("Source Language", selection: $selectedSourceLanguage) {
                    ForEach(languages, id: \.self) { language in
                        Text(language).tag(language)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)

                Picker("Target Language", selection: $selectedTargetLanguage) {
                    ForEach(languages, id: \.self) { language in
                        Text(language).tag(language)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)

                Button(action: {
                    // Call translate on NetworkManager with selected languages
                    NetworkManager.shared.translate(text: originalText, from: selectedSourceLanguage, to: selectedTargetLanguage) { translatedText in
                        if let translatedText = translatedText {
                            // Main thread for UI work
                            DispatchQueue.main.async {
                                self.translatedText = translatedText
                                let newTranslation = Translation(originalText: self.originalText, translatedText: self.translatedText)
                                self.firestoreManager.addTranslation(newTranslation)
                                self.translationHistory.insert(newTranslation, at: 0)
                                self.showSuccess = true // Show success indicator
                                
                                // Hide success indicator after 2 seconds
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    self.showSuccess = false
                                }
                            }
                        } else {
                            DispatchQueue.main.async {
                                self.translatedText = "Translation failed"
                            }
                        }
                    }
                }) {
                    Text("Translate Me")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding(.horizontal)
                        .padding(.top, 50)
                }

                if showSuccess {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .transition(.scale)
                }

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
                        .padding(.horizontal)
                }
            }
            .padding()
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
