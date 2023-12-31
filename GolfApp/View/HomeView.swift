//
//  HomeView.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 11/4/23.
//

import SwiftUI
import AlertToast

struct HomeView: View {
    @StateObject var authViewModel: AuthViewModel = AuthViewModel()
    @State private var postSubmissionText: String = ""
    @State var isAddPostClicked: Bool = false
    @State var isPostSubmitted: Bool = false
    @State var isLoading: Bool = false
    var onBack: () -> Void
    @State private var adPositions: [Int] = []
    @State private var postCounter = 0



    
    var body: some View {
        ScrollView {
            if isLoading {
                LoadingView()
            } else {
                VStack {
                    HStack {
                        HStack {
                            if let data = authViewModel.user?.profilePicData, let uiImage = UIImage(data: data) {
                                Image(uiImage: uiImage)
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
                    .background(.whiteOrDark)
                    Spacer().frame(height: 8)
                    VStack {
                        if let posts = authViewModel.posts {
                                            ForEach(Array(posts.enumerated()), id: \.element.id) { index, post in
                                                if let user = authViewModel.user, let otherUser = authViewModel.postOtherUsers {
                                                    PostView(authViewModel: authViewModel, user: user, post: post, otherUser: otherUser[post.user], onBack: onBack)

                                                    // Display ad based on randomized positions
                                                    if adPositions.contains(index) {
                                                        Section {
                                                            NativeAdViewControllerWrapper()
                                                                .frame(height: 400)
                                                                .padding()
                                                                            .background(Color.whiteOrDark)
                                                        }
                                                        
                                                    }
                                                }
                                            }
                                        } else {
                            LoadingView()
                        }
                        
                        
                        
                    }
                    .onAppear {
                        setupRandomAdPositions(for: authViewModel.posts?.count ?? 0)
                                }
                }
                .sheet(isPresented: $isAddPostClicked, content: {
                    if let user = authViewModel.user {
                        NewPostView(authViewModel: authViewModel, user: user, onPostSubmitted: {
                            isLoading = true
                            authViewModel.fetchAllPostsFromFirebase() { fetchedPosts in
                                isLoading = false
                            }
                            isPostSubmitted = true
                        })
                    }
                })
            }    
        }
        .frame(maxHeight: .infinity)
        .background(Color.blackOrGray)
        .toast(isPresenting: $isPostSubmitted, alert: {
            AlertToast(displayMode: .alert, type: .systemImage("checkmark", .mint), title: "Post submitted")
        })
    }
    private func setupRandomAdPositions(for postCount: Int) {
            adPositions.removeAll()
            var potentialPositions = Set(1..<postCount) // Start from 1 to avoid the first position

            while adPositions.count < postCount / 4 { // Adjust the division factor as needed
                guard let randomPosition = potentialPositions.randomElement() else { break }
                adPositions.append(randomPosition)
                // Remove nearby positions to avoid consecutive ads
                potentialPositions.remove(randomPosition)
                potentialPositions.remove(randomPosition + 1)
                potentialPositions.remove(randomPosition - 1)
            }
        }
}

//#Preview {
//    HomeView()
//}
