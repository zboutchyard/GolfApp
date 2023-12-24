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
    @Published private(set) var messages: [Message] = []
    @Published var lastMessage: Message?
    @Published var chat: Chat?
    @Published private(set) var chatId = ""
    
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
                if let text = self.messages.last {
                    self.lastMessage = text
                }
                self.chat = chat
                completion(chat)
            } catch {
                print("error decoding document into chat \(error)")
                return
            }
        }
    }
    
    func sendMessage(chatId: String, text: String, otherUser: OtherUser) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("Current user not found")
            return
        }
        
        let otherUserName = otherUser.firstName
        
        let newMessage = ["sender": currentUserID, "text": text, "timestamp": Date(), "senderName": otherUserName] as [String : Any]
        let chatRef = db.collection("Chats").document(chatId)
        
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
    
    func createChatAndSendMessage(text: String, otherUser: OtherUser) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("Current user not found")
            return
        }
        let otherUserRef = db.collection("Users").document(otherUser.id)
        let otherUserName = otherUser.firstName
        let newMessage = ["sender": currentUserID, "text": text, "timestamp": Date(), "senderName": otherUserName] as [String : Any]
        let participants = [currentUserID, otherUser.id]
        let chatRef = db.collection("Chats").addDocument(data: ["messages": FieldValue.arrayUnion([newMessage])]) { error in
            if let error = error {
                print("Error updating document: \(error.localizedDescription)")
            } else {
                print("Message sent successfully!")
            }
        }
        let chatId = chatRef.documentID
        self.chatId = chatId
        let participantsRef = db.collection("Chats").document(chatId)
        participantsRef.updateData(["participants": FieldValue.arrayUnion(participants)])
        let userRef = db.collection("Users").document(currentUserID)
        userRef.updateData(["chats": FieldValue.arrayUnion([chatId])]){ error in
            if let error = error {
                print("Error updating current users data \(error.localizedDescription)")
            } else {
                print("updated successully")
            }
        }
        otherUserRef.updateData(["chats": FieldValue.arrayUnion([chatId])]) { error in
            if let error = error {
                print("Error updating other users data \(error.localizedDescription)")
            } else {
                print("updated successfully")
            }

        }
        fetchChat(chatId: chatRef.documentID) { fetchedChat in
            if let chat = fetchedChat {
                self.messages = (fetchedChat?.messages!)!
            }
        }
    }
    
    func deleteUserChat(chatId: String){
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("Current user not found")
            return
        }
        let userChatRef = db.collection("Users").document(currentUserID)
        userChatRef.updateData([
                "chats": FieldValue.arrayRemove([chatId])
            ]) { error in
                if let error = error {
                    print("Error removing chatId from chats array: \(error.localizedDescription)")
                } else {
                    print("ChatId removed successfully")
                }
            }
    }
}
