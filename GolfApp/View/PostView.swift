//
//  PostView.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 11/23/23.
//

import SwiftUI
import FirebaseAuth

struct PostView: View {
    @State private var likeBtnClicked: Bool = false
    @State private var commentBtnClicked: Bool = false
    @State private var userClicked: Bool = false
    @ObservedObject var authViewModel: AuthViewModel = AuthViewModel()
    @State var user: User?
    @State var post: Post?
    @State var userId: String = Auth.auth().currentUser?.uid ?? ""
    @State var isLoading: Bool = true
    @State var tempPost: Post?
    @State var isPostDetailView: Bool = false
    @FocusState var isTextFieldFocused: Bool
    @State var otherUser: OtherUser?
    @State var otherUserClicked: Bool = false
    var onBack: (() -> Void)?

    
    
    var body: some View {
        VStack {
                Button(action: {
                    if userId != post?.user {
                        otherUserClicked = true
                    } else {
                        userClicked = true
                    }
                }, label: {
                    if let otherUsr = otherUser {
                        if let post = post {
                            HStack {
                                if let data = otherUsr.profilePicData, let uiImage = UIImage(data: data) {
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
                                
                                
                                
                                
                                
                                VStack {
                                    if let user = otherUser {
                                        Text("\(user.firstName) \(user.lastName)")
                                            .fontWeight(.semibold)
                                            .kerning(1.2)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        Text(String(post.timeStamp.formatted(.dateTime.hour().minute())))
                                            .font(.caption)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                
                                
                            }
                            .padding([.leading, .trailing, .top])
                        }

                    } else {
                        if let user = user {
                            if let post = post {
                                HStack {
                                    if let data = user.profilePicData, let uiImage = UIImage(data: data) {
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
                                    
                                    
                                    
                                    
                                    
                                    VStack {
                                            Text("\(user.firstName) \(user.lastName)")
                                                .fontWeight(.semibold)
                                                .kerning(1.2)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                            Text(String(post.timeStamp.formatted(.dateTime.hour().minute())))
                                                .font(.caption)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                        
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    
                                }
                                .padding([.leading, .trailing, .top])
                            }
                        }
                    }
                })
                .buttonStyle(.plain)
            if let text = post?.text {
                Text(text)
                    .fontWeight(.light)
                    .kerning(1.2)
                    .font(.subheadline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.leading, .trailing])
            }
               
                if let imageData = post?.imageData, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.top)
                }
                HStack {
                    if let likes = post?.likes {
                        if likes.count > 0 {
                            Image(systemName: "hand.thumbsup.fill")
                                .background(Circle().fill(.blue).frame(width: 20, height: 20))
                                .foregroundStyle(.whiteOrDark)
                                .padding([.leading])
                            Text(String(likes.count))
                        }
                    }
                    Spacer()
                    if !isPostDetailView {
                        if let comments = post?.comments {
                            Button(action: {
                                commentBtnClicked = true
                            }, label: {
                                Text(comments.count == 1 ? "\(comments.count) comment" : "\(comments.count) comments")
                            })
                            .padding(.trailing)
                            .buttonStyle(.plain)
                            .underline()
                        }
                    }
                }
                .padding(.top, 0.5)
                .padding(.bottom, 0.5)
                Divider()
                    .padding(.bottom, 5)
                HStack {
                    Button(action: {
                        Task {
                            likeBtnClicked.toggle()
                            
                            if likeBtnClicked {
                                if let id = post?.id {
                                    await addLikeToFirebase(postId: id)
                                }
                            } else {
                                if let id = post?.id {
                                    await removeLikeFromFirebase(postId: id)
                                    
                                }
                            }
                            authViewModel.fetchPostFromFirebase(postId: post?.id ?? "") { fetchedPost in
                                if let reloadedPost = fetchedPost {
                                    post = reloadedPost
                                }
                            }
                        }
                    }, label: {
                        HStack {
                            Image(systemName: "hand.thumbsup")
                                .fontWeight(.semibold)
                                .kerning(1.2)
                            Text("Like")
                                .fontWeight(.semibold)
                                .kerning(1.2)
                        }
                    })
                    .buttonStyle(.plain)
                    .foregroundStyle(likeBtnClicked ? .blue : .primary)
                    .padding(.leading, 50)
                    Spacer()
                    Button(action: {
                        if !isPostDetailView {
                            commentBtnClicked = true
                        }
                        if isPostDetailView {
                            isTextFieldFocused = true
                        }
                    }, label: {
                        HStack {
                            Image(systemName: "message")
                                .fontWeight(.semibold)
                                .kerning(1.2)
                            Text("Comment")
                                .fontWeight(.semibold)
                                .kerning(1.2)
                        }
                        .padding(.trailing, 50)
                    })
                    .buttonStyle(.plain)
                }
                .padding(.bottom)
            
        }
        .background(.whiteOrDark)
        .onAppear() {
            if let likes = post?.likes {
                if ((likes.contains(userId))) {
                    likeBtnClicked = true
                }
            }            
        }
        .navigationDestination(isPresented: $commentBtnClicked) {
            PostDetailView(post: post, authViewModel: authViewModel, user: user, otherUser: otherUser, onBack: onBack)
        }
        .navigationDestination(isPresented: $userClicked) {
            if let user = user {
                ProfileView(authViewModel: authViewModel, user: user)
                .background(Color.whiteOrDark)
            }
        }
        .navigationDestination(isPresented: $otherUserClicked) {
            if let otherUser = otherUser {
                if let user = user {
                    OtherUserProfileView(otherUser: otherUser, user: user)
                }
            }
        }
    }
    func addLikeToFirebase(postId: String) async {
        authViewModel.addUserIdToLikes(postId: postId) { addedLike in}
        authViewModel.fetchPostFromFirebase(postId: postId) { fetchedPost in
            tempPost = fetchedPost
        }
    }
    func removeLikeFromFirebase(postId: String) async {
        authViewModel.removeUserIdFromLikes(postId: postId) { removedLike in}
        authViewModel.fetchPostFromFirebase(postId: postId) { fetchedPost in
            tempPost = fetchedPost
        }
    }
    
}

//#Preview {
//    PostView()
//}
