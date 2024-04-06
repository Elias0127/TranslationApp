//
//  FirestoreManager.swift
//  TranslationApp
//
//  Created by Elias Woldie on 4/5/24.
//

import Firebase
import FirebaseFirestore

class FirestoreManager: ObservableObject {
    private var db = Firestore.firestore()
    
    func addTranslation(_ translation: Translation) {
        var ref: DocumentReference? = nil
        ref = db.collection("translations").addDocument(data: [
            "originalText": translation.originalText,
            "translatedText": translation.translatedText,
            "timestamp": Timestamp(date: translation.timestamp)
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }
    
    func fetchTranslations(completion: @escaping ([Translation]) -> Void) {
        db.collection("translations")
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { (querySnapshot, error) in
                var translations: [Translation] = []
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    for document in querySnapshot!.documents {
                        let data = document.data()
                        let translation = Translation(
                            id: document.documentID,
                            originalText: data["originalText"] as? String ?? "",
                            translatedText: data["translatedText"] as? String ?? "",
                            timestamp: (data["timestamp"] as? Timestamp)?.dateValue() ?? Date()
                        )
                        translations.append(translation)
                    }
                }
                DispatchQueue.main.async {
                    completion(translations)
                }
            }
    }
    
    func deleteTranslation(withId id: String) {
            db.collection("translations").document(id).delete { error in
                if let error = error {
                    print("Error removing translation: \(error.localizedDescription)")
                } else {
                    print("Translation successfully removed")
                }
            }
        }
    
    func deleteAllTranslations() {
            // Fetch all documents in the 'translations' collection
            db.collection("translations").getDocuments { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else if let querySnapshot = querySnapshot {
                    for document in querySnapshot.documents {
                        // Delete each document
                        document.reference.delete()
                    }
                }
            }
        }
    }
