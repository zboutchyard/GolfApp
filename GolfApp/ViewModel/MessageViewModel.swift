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
    @Published var messages: [Message] = []
    @Published private(set) var lastMessage = ""
    let db = Firestore.firestore()
    
    func fetchChat(chatId: String, completion: @escaping (Chat?) -> Void?) {
        db.collection("Chats").document(chatId).addSnapshotListener { querySnapshot, error in
            guard let document = querySnapshot else {
                print("error fetching document \(String(describing: error))")
                return
            }
            do {
                let chat = try document.data(as: Chat.self)
                self.messages = chat.messages ?? []
                if let text = self.messages.last?.text {
                    self.lastMessage = text
                }
                completion(chat)
            } catch {
                print("error decoding document into chat \(error)")
                return 
            }
        }
    }
    
    func sendMessage(chatId: String, text: String) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
                print("Current user not found")
                return
            }
        
        let newMessage = ["sender": currentUserID, "text": text, "timestamp": Date()] as [String : Any]
        //if the
        let chatRef = db.collection("Chats").document(chatId)

            // Update the messages array using arrayUnion
            chatRef.updateData([
                "messages": FieldValue.arrayUnion([newMessage])
            ]) { error in
                if let error = error {
                    print("Error updating document: \(error.localizedDescription)")
                } else {
                    print("Message sent successfully!")
                }
            }
    }


    
//    func getChatParticipants(chatId: String, completion: @escaping (Participants?)-> Void) {
//        let messagesCollectionRef = Firestore.firestore().collection("Chats").document(chatId)
//        print("chat id: \(chatId)")
//        
//        messagesCollectionRef.getDocument { (document, error) in
//            if let document = document, document.exists {
//                if let data = document.data(),
//                   let participantData = data["participants"] as? [String] {
//                    let participantsModel = Participants(participants: participantData)
//                    print("Participants Data: \(participantData)")
//                    completion(participantsModel)
//                } else {
//                    print("Participants field missing or not an array of strings.")
//                    completion(nil)
//                }
//            } else {
//                print("Document does not exist or there was an error: \(error?.localizedDescription ?? "Unknown Error")")
//                completion(nil)
//            }
//        }
//    }
}
