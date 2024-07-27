//
//  PersonCellView.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 11/24/23.
//

import SwiftUI

struct PersonCellView: View {
    @State var otherUser: OtherUser?
    @StateObject var authViewModel: AuthViewModel
    @State var post: Post?
    @Binding var isPostView: Bool
    
    var body: some View {
        if isPostView {
            if let post = post {
                HStack {
                    if let data = otherUser?.profilePicData, let uiImage = UIImage(data: data) {
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
        }
        if !isPostView {
            HStack {
                if let data = otherUser?.profilePicData, let uiImage = UIImage(data: data) {
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
                if let user = otherUser {
                    Text("\(user.firstName) \(user.lastName)")
                        .fontWeight(.semibold)
                        .kerning(1.2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
            }
            .onAppear {
                if let user = otherUser {
                    getUser(userId: user.id)
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

// #Preview {
//    PersonCellView()
// }
