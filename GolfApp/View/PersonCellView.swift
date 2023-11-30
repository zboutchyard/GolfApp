//
//  PersonCellView.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 11/24/23.
//

import SwiftUI

struct PersonCellView: View {
    @State var otherUser: OtherUser?
    @ObservedObject var authViewModel: AuthViewModel = AuthViewModel()
    @State var post: Post?
    @Binding var isPostView: Bool
    var body: some View {
        if isPostView {
            if let post = post {
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
                        if let user = otherUser {
                            Text("\(user.firstName) \(user.lastName)")
                                .fontWeight(.semibold)
                                .kerning(1.2)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text(String(post.timeStamp.formatted(.dateTime.hour().minute())))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.caption)
                        } else {
                            ProgressView()
                        }
                        
                        
                        
                    }
                    
                }
                .onAppear() {
                    getUser(userId: post.user)
                }
                .padding([.leading, .trailing, .top])
            }
            else {
               ProgressView()
           }
        }
        if !isPostView {
            if let user = otherUser {
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
                        if let user = otherUser {
                            Text("\(user.firstName) \(user.lastName)")
                                .fontWeight(.semibold)
                                .kerning(1.2)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        } else {
                            ProgressView()
                        }
                        
                        
                    }
                    }
                    
                }

        }
            
           
    }
    func getUser(userId: String) {
        authViewModel.fetchOtherUserFromFirebase(id: userId) { fetchedUser in
                otherUser = fetchedUser
        }
    }
}

//#Preview {
//    PersonCellView()
//}
