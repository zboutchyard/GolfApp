//
//  LandingView.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 11/3/23.
//

import SwiftUI
import FirebaseDatabase
import Firebase


//class MockAuthViewModel: ObservableObject {
//    func fetchUserDataFromFirebase(completion: @escaping (User?) -> Void) {
//        // Mock implementation for testing in previews
//        let mockUser = User(firstName: "Zack", lastName: "Boutchyard", email: "Zackboutchyard@gmail.com")
//        completion(mockUser)
//    }
//}

struct AllChatsView: View {
    @StateObject var authViewModel: AuthViewModel = AuthViewModel()
    @StateObject var msgViewModel: MessageViewModel = MessageViewModel()
    @State private var user: User?
    @State private var particps: Participants?
    @State private var msg: [Message]?
    @State private var prts: [String]?
    @State private var isLoading: Bool = true
    @State private var participantArray: [String] = []
    @State private var mockParticipantArray: [String] = ["test123123", "test098098098"]
    let randomColor = Color(UIColor(red: CGFloat.random(in: 0...1),
                                           green: CGFloat.random(in: 0...1),
                                           blue: CGFloat.random(in: 0...1),
                                           alpha: 1.0))
    var body: some View {
        VStack {
            if !isLoading {
                Text("Messages")
                    .font(.largeTitle)
                Divider()
                ScrollView {
                    //change this to actual array when done with UI
                    ForEach(mockParticipantArray, id: \.self){ participant in
                            HStack {
                                Circle()
                                    .overlay {
                                        Text("J")
                                            .font(.title)
                                            .foregroundStyle(.black)
                                    }
                                    .foregroundStyle(generateRandomColor())
                                    .frame(width: 75, height: 75)
                                VStack {
                                    Text("Name of participant")
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .multilineTextAlignment(.leading)
                                            .frame(maxWidth: .infinity, alignment: .leading)
    //                                    Text(participant)
    //                                        .multilineTextAlignment(.leading)
                                        Text("hereh is an example of a message that might be sent")
                                        .lineLimit(1)
                                        .multilineTextAlignment(.leading)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                Text("Sep 22")
                                    .font(.caption)
                                Spacer()
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 12)
                    }
                }
                HStack {
                    Spacer()
                    Button(action: {
                                //action()
                            }) {
                                Image(systemName: "message.circle.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 75, height: 75)
                                    .foregroundColor(.white)
                                    .background(Color.blue)
                                    .clipShape(Circle())
                                    .shadow(radius: 5)
                            }
                            .padding(.bottom, 50)
                            .padding(.trailing, 30)
                    
                }
            }
            if isLoading {
                ProgressView("Fetching your profile information")
                    .progressViewStyle(.circular)
                    .padding()
            }
        } .onAppear(){
            //uncomment this when using actual data when done with UI
//            participantArray.removeAll()
//            fetchUserDataAndGetAllConversations()
            
            //remove this when done with UI
            isLoading = false
        }
    }
    
    func generateRandomColor() -> Color {
        return Color(UIColor(red: CGFloat.random(in: 0...1),
                            green: CGFloat.random(in: 0...1),
                            blue: CGFloat.random(in: 0...1),
                            alpha: 1.0))
    }
    
    func fetchUserDataAndGetAllConversations() {
        authViewModel.fetchUserDataFromFirebase() { fetchedUser in
            user = fetchedUser
            if let userChats = user?.chats {
                let dispatchGroup = DispatchGroup()
                
                for chat in userChats {
                    dispatchGroup.enter()
                    getAllConversations(chatid: chat) {
                        if let currentUserId = Auth.auth().currentUser?.uid,
                           let filteredParticipants = particps?.participants.filter({ $0 != currentUserId }) {
                            participantArray.append(contentsOf: filteredParticipants)
                        } else {
                            // Handle the case where particps or current user ID is nil
                            print("Participants or current user ID is nil.")
                        }
                        dispatchGroup.leave()
                    }
                }
                
                // Wait for all asynchronous calls to complete
                dispatchGroup.notify(queue: .main) {
                    isLoading = false
                }
            } else {
                print("Error in fetching user")
            }
        }
    }
    
    func getAllConversations(chatid: String, completion: @escaping () -> Void) {
        msgViewModel.getChatParticipants(chatId: chatid) { participants in
            particps = participants
            completion()
        }
    }
    
}

#Preview {
    AllChatsView()
}
