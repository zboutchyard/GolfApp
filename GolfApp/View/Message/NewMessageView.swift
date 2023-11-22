//
//  NewMessageView.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 11/21/23.
//

import SwiftUI

struct NewMessageView: View {
    @State var user: User
    @StateObject var authViewModel: AuthViewModel = AuthViewModel()
    @StateObject var msgViewModel: MessageViewModel = MessageViewModel()
    @State var otherUsers: [OtherUser] = []
    @Binding var isPresented: Bool
    @State var isUserClicked: Bool = false
    @State var otherUser: OtherUser?

    var body: some View {
        NavigationStack {
            VStack() {
                HStack {
                    Button("Cancel") {
                        isPresented = false
                    }
                    .padding(.leading)
                    Spacer()
                    Text("New Message")
                        .font(.title3).bold()
                        .frame( alignment: .center)
                        .padding()
                    Spacer()
                    Spacer()
                }
                Divider()
                ScrollView {
                        ForEach(otherUsers, id: \.firstName){ friend in
                                HStack {
                                    Circle()
                                        .overlay {
                                            Text(friend.firstName.prefix(1))
                                                .font(.title)
                                                .foregroundStyle(.black)
                                        }
                                        .foregroundStyle(generateRandomAccessibleColor())
                                        .frame(width: 75, height: 75)
                                    VStack {
                                        Text("\(friend.firstName) \(friend.lastName)")
                                            .font(.title3)
                                            .fontWeight(.bold)
                                            .multilineTextAlignment(.leading)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                    Spacer()
                                } .onTapGesture {
                                    otherUser = friend
                                    isUserClicked = true
                                }
                                Divider()
                                
                        }
                }
                .navigationDestination(isPresented: $isUserClicked, destination: {
                    if otherUser != nil {
                        NewChatView(otherUser: otherUser!, isPresented: $isPresented)
                    }
                })
            }
        }
         .onAppear() {
                getOtherUserInfo(friendsList: user.friendsList)
        }
    }
    
    func getOtherUserInfo(friendsList: [String]){
        for friend in friendsList {
            authViewModel.fetchOtherUserFromFirebase(id: friend){ friend in
                if let friend = friend {
                    otherUsers.append(friend)
                }
            }
        }
    }
    
    func generateRandomAccessibleColor() -> Color {
        let minimumLuminance: CGFloat = 0.3
        let maximumLuminance: CGFloat = 0.7

        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0

        repeat {
            red = CGFloat.random(in: 0...1)
            green = CGFloat.random(in: 0...1)
            blue = CGFloat.random(in: 0...1)
        } while !isColorAccessible(red: red, green: green, blue: blue, minimumLuminance: minimumLuminance, maximumLuminance: maximumLuminance)

        return Color(red: red, green: green, blue: blue)
    }
    
    func isColorAccessible(red: CGFloat, green: CGFloat, blue: CGFloat, minimumLuminance: CGFloat, maximumLuminance: CGFloat) -> Bool {
        let luminance = (0.2126 * red) + (0.7152 * green) + (0.0722 * blue)
        return luminance >= minimumLuminance && luminance <= maximumLuminance
    }
}

//#Preview {
//    NewMessageView()
//}
