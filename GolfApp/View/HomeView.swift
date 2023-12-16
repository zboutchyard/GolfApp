//
//  HomeView.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 11/4/23.
//

import SwiftUI
import AlertToast

struct HomeView: View {
    @ObservedObject var authViewModel: AuthViewModel = AuthViewModel()
    @State private var postSubmissionText: String = ""
    @State var user: User?
    @State var isAddPostClicked: Bool = false
    @State var isPostSubmitted: Bool = false
    @State var isLoading: Bool = true
    @State var isDoneProcessingImage = false
    @State var image: UIImage?
    
    var body: some View {
        ScrollView {
            if !isLoading {
                VStack {
                    HStack {
                        HStack {
                            if let image = image {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                                    .background {
                                        Circle().fill(Color("AppGray"))
                                    }
                                    .foregroundStyle(.whiteOrDark)
                            } else {
                                Image(systemName: "person.fill")
                                    .scaledToFill()
                                    .clipShape(Circle())
                                    .frame(width: 50, height: 50)
                                    .background {
                                        Circle().fill(Color("AppGray"))
                                    }
                                    .foregroundStyle(.whiteOrDark)
                            }
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
                        ForEach(authViewModel.posts.sorted(by: { $0.timeStamp > $1.timeStamp}), id: \.self) { post in
                            if let user = user {
                                PostView(user: user, post: post)
                            }
                        }
                        
                        
                    }
                }
                .sheet(isPresented: $isAddPostClicked, content: {
                    if let user = user {
                        NewPostView(user: user, onPostSubmitted: {
                            authViewModel.fetchAllPostsFromFirebase()
                            isPostSubmitted = true
                        })
                    }
                })
            } else {
                LoadingView()
            }
        }
        .frame(maxHeight: .infinity)
        .background(Color.blackOrGray)
        .toast(isPresenting: $isPostSubmitted, alert: {
            AlertToast(displayMode: .alert, type: .systemImage("checkmark", .mint), title: "Post submitted")
        })
        .onAppear() {
            Task {
                await fetchUser()
                await fetchAllPosts()
            }
        }
    }
    func fetchUser() async {
        authViewModel.fetchUserDataFromFirebase() { fetchedUser in
            user = fetchedUser
            if let profilePic = user?.profilePic {
                getProfilePic(photoId: profilePic)
                isLoading = false
            } else {
                isLoading = false
            }
        }
    }
    func fetchAllPosts() async {
        authViewModel.fetchAllPostsFromFirebase()
    }
    func getProfilePic(photoId: String) {
        authViewModel.fetchPhotoData(photoId: photoId) { fetchedData in
            if let data = fetchedData {
                print("Downloaded photo data:", data)
                image = UIImage(data: data)
            } else {
                print("Failed to download photo data")
            }
        }
    }
}

#Preview {
    HomeView()
}
