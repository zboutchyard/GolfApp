//
//  NotificationViewModel.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 12/3/23.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import SwiftUI
import PhotosUI
import FirebaseStorage

class NotificationViewModel: ObservableObject {
    @Published var requestsReceived: [String] = []
    @Published var requestsSent: [String] = []
    let db = Firestore.firestore()

    
    func sendRequest(userId: String) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let sentRequestRef = db.collection("Users").document(userId)
        let requestSentData: [String: Any] = [
            "user": uid
        ]
        let pendingRequestRef = db.collection("Users").document(uid)
        let pendingRequestData: [String: Any] = [
            "user": userId
        ]
        sentRequestRef.updateData([
            "receivedRequests": FieldValue.arrayUnion([requestSentData])
        ]) { error in
            if let error = error {
                print("Error sending request: \(error.localizedDescription)")
            } else {
                print("request sent successfully")
            }
        }
        
        pendingRequestRef.updateData([
            "sentRequests": FieldValue.arrayUnion([pendingRequestData])
        ]) { error in
            if let error = error {
                print("Error adding pending request for current user: \(error.localizedDescription)")
            } else {
                print("request updated successfully")
            }
        }
    }
    
    func addFriend(userId: String) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }

        let otherUserFriendsListRef = db.collection("Users").document(userId)
        let currentUserFriendsListRef = db.collection("Users").document(uid)
        

        // Update friendsList for the user with userId
        otherUserFriendsListRef.updateData(["friendsList": FieldValue.arrayUnion([uid])]) { error in
            if let error = error {
                print("Error updating friendsList for user with userId: \(error.localizedDescription)")
                return
            }

            // Update friendsList for the current user (uid)
            currentUserFriendsListRef.updateData(["friendsList": FieldValue.arrayUnion([userId])]) { error in
                if let error = error {
                    print("Error updating friendsList for current user: \(error.localizedDescription)")
                } else {
                    print("Friend added successfully!")
                }
            }
        }
    }
    func removePendingRequests(userId: String) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        print("here is the userId \(userId)")

        let sentRequestRef = db.collection("Users").document(userId)
        let requestSentData = [
            "user": uid
        ]

        let pendingRequestRef = db.collection("Users").document(uid)
        let pendingRequestData = [
            "user": userId
        ]
        pendingRequestRef.getDocument { document, error in
            print(document?.data())
        }

        sentRequestRef.updateData([
            "sentRequests": FieldValue.arrayRemove([requestSentData])
        ]) { error in
            if let error = error {
                print("Error removing received request: \(error.localizedDescription)")
            } else {
                print("Received request removed successfully")
            }
        }

        pendingRequestRef.updateData([
            "receivedRequests": FieldValue.arrayRemove([pendingRequestData])
        ]) { error in
            if let error = error {
                print("Error removing sent request for current user: \(error.localizedDescription)")
            } else {
                print("Sent request removed successfully")
            }
        }
    }


}

