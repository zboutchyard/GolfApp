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
}

