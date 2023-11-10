//
//  MessageViewModel.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 11/7/23.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import SwiftUI
import PhotosUI
import FirebaseStorage

class MessageViewModel: ObservableObject {
    func getChatMessages(chatId: String, completion: @escaping (Error?) -> Void) {
        let messagesCollectionRef = Firestore.firestore().collection("Chats").document(chatId).collection("messages")
        
        messagesCollectionRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(error)
            } else {
                var messages: [Message] = []
                for document in querySnapshot!.documents {
                    if let message = try? document.data(as: Message.self) {
                        messages.append(message)
                    }
                }
                completion(nil)
            }
        }
    }
    
    
    
    func getChatParticipants(chatId: String, completion: @escaping (Participants?)-> Void) {
        let messagesCollectionRef = Firestore.firestore().collection("Chats").document(chatId)
        print("chat id: \(chatId)")
        
        messagesCollectionRef.getDocument { (document, error) in
            if let document = document, document.exists {
                if let data = document.data(),
                   let participantData = data["participants"] as? [String] {
                    let participantsModel = Participants(participants: participantData)
                    print("Participants Data: \(participantData)")
                    completion(participantsModel)
                } else {
                    print("Participants field missing or not an array of strings.")
                    completion(nil)
                }
            } else {
                print("Document does not exist or there was an error: \(error?.localizedDescription ?? "Unknown Error")")
                completion(nil)
            }
        }
    }
}
