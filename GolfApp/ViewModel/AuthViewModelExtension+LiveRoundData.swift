//
//  AuthViewModelExtension+LiveRoundData.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 12/12/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

extension AuthViewModel {
    
    @MainActor
    func fetchLiveRoundData(id: String) {
        let database = Firestore.firestore()
        database.collection("LiveRounds").document(id).getDocument { snapshot, error in
                    if let error = error {
                        print("Error fetching document: \(error)")
                        return
                    }
                    guard let snapshot = snapshot, snapshot.exists else {
                        print("Document does not exist")
                        return
                    }
                    do {
                        self.liveRounds.removeAll()
                        self.liveRounds.append(try snapshot.data(as: LiveRoundFirebaseModel.self))
                    } catch let decodingError {
                        print("Error decoding document: \(decodingError)")
                    }
                }
    }
    
    @MainActor
    func getOtherUsersForLiveRound(mainUser: String, otherUser: String? = nil) async {
        let mainUserData: OtherUser = await fetchOtherUserFromFirebase(id: mainUser)
        var otherUserData: OtherUser? = nil
        if let otherUser = otherUser {
            otherUserData = await fetchOtherUserFromFirebase(id: otherUser)
        }
        let liveRoundUsers: LiveRoundFirebaseUsers = .init(mainUser: mainUserData, otherUser: otherUserData)
        self.liveRoundPostUsers = liveRoundUsers
    }
    
    func addUserIdToLikesLiveRound(liveRoundId: String) {
        let postRef = Firestore.firestore().collection("LiveRounds").document(liveRoundId)
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        postRef.updateData([
            "likes": FieldValue.arrayUnion([uid])
        ]) { error in
            if let error = error {
                print("Error adding user ID to likes array: \(error.localizedDescription)")
            } else {
                print("User ID added to likes array successfully.")
            }
        }
    }
    
    func removeUserIdFromLikesLiveRound(liveRoundId: String) {
        let postRef = Firestore.firestore().collection("LiveRounds").document(liveRoundId)
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        postRef.updateData([
            "likes": FieldValue.arrayRemove([uid])
        ]) { error in
            if let error = error {
                print("Error removing user ID from likes array: \(error.localizedDescription)")
            } else {                
                print("User ID removed from likes array successfully.")
                
            }
        }
    }

}
