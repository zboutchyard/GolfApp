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
    @State private var prts: [String]?
    @State private var isLoading: Bool = true
    var body: some View {
        VStack {
                Text("Messages")
                    .font(.title)
                //                Divider()
                ScrollView {
                    if let user = user {
                        ForEach((user.chats), id: \.self){  chat in
                            AllChatCellView(chatId: chat)
                        }
                    }
                }
                HStack {
                    Spacer()
                    Button(action: {
                        //action()
                    }) {
                        Image(systemName: "plus.message.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 60, height: 60)
                            .foregroundColor(Color("Green"))
                            .shadow(radius: 1.5)
                    }
                    .padding(.bottom, 50)
                    .padding(.trailing, 30)
                    
                }
            
        } .onAppear(){
            getUserData()
        }
    }
    func getUserData() {
        authViewModel.fetchUserDataFromFirebase { fetchedUser in
            user = fetchedUser
        }
    }
}

#Preview {
    AllChatsView()
}
