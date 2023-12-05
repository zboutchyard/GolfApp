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
    @StateObject var authViewModel = AuthViewModel()
    @FocusState var isTextFieldFocused: Bool
    
    var body: some View {
        ScrollView {
            if let post = post {
                PostView(post: post, isPostDetailView: true, isTextFieldFocused: _isTextFieldFocused)
                Divider()
                if let comments = post.comments {
                    ForEach(comments, id: \.self) { comment in
                        HStack {
                            Image(systemName: "person.fill")
                                .scaledToFill()
                                .foregroundStyle(.whiteOrDark)
                                .clipShape(Circle())
                                .frame(width: 50, height: 50)
                                .background {
                                    Circle().fill(Color("Gray"))
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
                    }
                    Divider()
                }
            }
        }
        .onTapGesture {
            isTextFieldFocused = false
        }
        .background(.whiteOrDark)
        .toolbar {
            if let post = post {
                MessageToolbar(post: post ,isTextFieldFocused: _isTextFieldFocused) {
                    authViewModel.fetchPostFromFirebase(postId: post.id ?? "") { fetchedPost in
                        self.post = fetchedPost
                    }
                }
            }
           
        }
    }
    
    struct MessageToolbar: ToolbarContent {
        @State var post: Post
        @State private var comment: String = ""
        @FocusState var isTextFieldFocused: Bool
        var onCommentAdded: () -> Void
        @ObservedObject var authViewModel: AuthViewModel = AuthViewModel()

        
        var body: some ToolbarContent {
            ToolbarItem(placement: .bottomBar) {
                HStack {
                    CustomTextField(placeholder: Text("...type something").foregroundStyle(.black), text: $comment, isTextFieldFocused: _isTextFieldFocused)
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
                .background(Color("Gray"))
                .cornerRadius(50)
                .padding()
            }
        }
    }
    
    struct CustomTextField: View {
        var placeholder: Text
        @Binding var text: String
        var editingChanged: (Bool) -> () = {_ in}
        var commit: () -> () = {}
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


#Preview {
    PostDetailView()
}
