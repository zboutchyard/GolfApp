//
//  PostDetailView.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 11/30/23.
//

import SwiftUI
import FirebaseAuth

struct PostDetailView: View {
    @State var post: Post?
    @State var userClicked: Bool = false
    @State var otherUsers: [String: OtherUser] = [:]
    @StateObject var authViewModel: AuthViewModel
    @StateObject var notificationViewModel: NotificationViewModel
    @StateObject var msgViewModel: MessageViewModel
    @FocusState var isTextFieldFocused: Bool
    @State var isLoading: Bool = false
    @State var user: User?
    @State var otherUser: OtherUser?
    @State var selectedTab: Int?
    
    var body: some View {
        ScrollView {
            if let post = post {
                PostView(
                    authViewModel: authViewModel,
                    notificationViewModel: notificationViewModel,
                    msgViewModel: msgViewModel,
                    user: user,
                    post: post,
                    isPostDetailView: true,
                    isTextFieldFocused: _isTextFieldFocused,
                    otherUser: otherUser)
                Divider()
                if let comments = post.comments {
                    ScrollViewReader { _ in
                        ScrollView {
                            ForEach(comments, id: \.self) { comment in
                                HStack {
                                    if let otherUser = otherUsers[comment.userCommenting] {
                                        
                                        if let data = otherUser.profilePicData, let uiImage = UIImage(data: data) {
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

                                    }
                                    VStack {
                                        if let otherUser = otherUsers[comment.userCommenting] {
                                            Text("\(otherUser.firstName) \(otherUser.lastName)")
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                            Text(comment.text)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                        } else {
                                            ProgressView()
                                        }
                                    }
                                    .onAppear {
                                        fetchOtherUserById(id: comment.userCommenting)
                                    }

                                }
                                .padding()
                                Divider()
                            }
                        }
                    }
                    
                }
            }
               
        }
        .onTapGesture {
            isTextFieldFocused = false
        }
        .background(.whiteOrDark)
        if let post = post {
            MessageToolbar(post: post, isTextFieldFocused: _isTextFieldFocused, authViewModel: authViewModel) {
                authViewModel.fetchPostFromFirebase(postId: post.id ?? "") { fetchedPost in
                    self.post = fetchedPost
                }
            }
        }
        
    }
    
    struct MessageToolbar: View {
        @State var post: Post
        @State private var comment: String = ""
        @FocusState var isTextFieldFocused: Bool
        @StateObject var authViewModel: AuthViewModel
        var onCommentAdded: () -> Void
        
        var body: some View {
                HStack {
                    CustomTextField(
                        placeholder: Text("...type something")
                            .foregroundStyle(.black),
                        text: $comment,
                        isTextFieldFocused: _isTextFieldFocused)
                    Button(action: {
                        authViewModel.addComment(postId: post.id ?? "", text: comment, postOwner: post.user)
                        comment = ""
                        onCommentAdded()
                    }, label: {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.white)
                            .padding(5)
                            .background(Color("Green"))
                            .cornerRadius(50)
                    })
                }
                .foregroundStyle(.black)
                .padding(.horizontal)
                .padding(.vertical, 6)
                .background(Color("AppGray"))
                .cornerRadius(50)
                .padding()
            
        }
    }
    
    struct CustomTextField: View {
        var placeholder: Text
        @Binding var text: String
        var editingChanged: (Bool) -> Void = {_ in}
        var commit: () -> Void = {}
        @FocusState var isTextFieldFocused: Bool
        
        var body: some View {
            ZStack(alignment: .leading) {
                if text.isEmpty {
                    placeholder
                        .opacity(0.5)
                }
                TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit)
                    .focused($isTextFieldFocused)
            }
        }
    }
    
    func fetchOtherUserById(id: String) {
        if otherUsers[id] == nil {
            authViewModel.fetchOtherUserFromFirebase(id: id) { fetchedUser in
                otherUsers[id] = fetchedUser
            }
        }
    }
}
