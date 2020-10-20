//
//  AuthenticationService.swift
//  PlantCare
//
//  Created by Alas, Eric on 2020-10-14.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class AuthenticationService: ObservableObject {
    @Published var user: User?

    func signIn() {
        registerStateListener()
        Auth.auth().signInAnonymously()
    }

    private func registerStateListener() {
        Auth.auth().addStateDidChangeListener { (auth, user) in
            print("Sign in state has changed.")
            self.user = user

            if let user = user {
                let db = Firestore.firestore()
                let anonymous = user.isAnonymous ? "anonymously " : ""
                let docRef = db.collection("houses").document(user.uid)

                docRef.getDocument { (document, error) in
                    if let document = document, document.exists {
                        print("user \(user.uid) - house exists")
                    } else {
                        db.collection("houses").document(user.uid).setData([
                            "name": "My House",
                            "ownerEmail": "",
                            "ownerId": user.uid,
                            "id": user.uid,
                        ])
                    }
                }
                print("User signed in \(anonymous)with user ID \(user.uid).")
            }
            else {
                print("User signed out.")
            }
        }
    }

}
