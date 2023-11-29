//
//  HomeView.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 11/4/23.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var authViewModel: AuthViewModel = AuthViewModel()
    @State private var postSubmissionText: String = ""
    @State var user: User?
    @State var isAddPostClicked: Bool = false
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    HStack {
                        Image(systemName: "person.fill")
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(width: 50, height: 50)
                            .background {
                                Circle().fill(Color("Gray"))
                            }
                            .foregroundStyle(.whiteOrDark)
                        Button(action: {
                            isAddPostClicked = true
                        }, label: {
                            Text("tell me something...")
                        })
                        .buttonStyle(.plain)
                        .opacity(0.3)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.top, .leading, .bottom])
                    Button(action: {}, label: {
                        HStack {
                            Image(systemName: "photo.on.rectangle.angled")
                                .padding(.trailing)
                        }
                    })
                    .buttonStyle(.plain)
                }
                .ignoresSafeArea()
                .background(.whiteOrDark)
                Spacer().frame(height: 8)
                VStack {
                    ForEach(authViewModel.posts, id: \.self) { post in
                            PostView(post: post)
                        }
                }
            }
            .sheet(isPresented: $isAddPostClicked, content: {
                if let user = user {
                    NewPostView(user: user)
                }
            })
        }
        .frame(maxHeight: .infinity)
        .background(Color.blackOrGray)
        .onAppear() {
            fetchUser()
            authViewModel.fetchAllPostsFromFirebase()
        }
    }
    func fetchUser() {
        authViewModel.fetchUserDataFromFirebase() { fetchedUser in
            user = fetchedUser
        }
    }
}

#Preview {
    HomeView()
}
