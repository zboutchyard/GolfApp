//
//  PostView.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 11/23/23.
//

import SwiftUI

struct PostView: View {
    @State private var likeBtnClicked: Bool = false
    @State private var commentBtnClicked: Bool = false
    @State private var userClicked: Bool = false
    @ObservedObject var authViewModel: AuthViewModel = AuthViewModel()
    @State private var user: User?
    @State var post: Post

    var body: some View {
            VStack {
                Button(action: {
                    userClicked = true
                }, label: {
                    PersonCellView(post: post, isPostView: .constant(true))
                })
                .buttonStyle(.plain)
                
                Text(post.text)
                    .fontWeight(.light)
                    .kerning(1.2)
                    .font(.subheadline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.leading, .trailing])
                HStack {
                    Image(systemName: "hand.thumbsup.fill")
                        .background(Circle().fill(.blue).frame(width: 20, height: 20))
                        .foregroundStyle(.whiteOrDark)
                        .padding([.leading])
                    if post.likes.count > 0 {
                        Text(String(post.likes.count))
                    }
                        Spacer()
                }
                .padding(.top, 0.5)
                .padding(.bottom, 0.5)
                Divider()
                    .padding(.bottom, 5)
                HStack {
                    Button(action: {
                        likeBtnClicked.toggle()
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
                        commentBtnClicked = true
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
            }
    
    
    
//    func fetchData() {
//        authViewModel.fetchUserDataFromFirebase() { fetchedUser in
//            if let posts =
//            user = fetchedUser
//        }
//    }
    
   
}

//#Preview {
//    PostView()
//}
