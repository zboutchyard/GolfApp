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
    @State var image: UIImage?
    
    var body: some View {
        if isPostView {
            if let post = post {
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
                    
                    
                    
                    
                    
                    VStack {
                        if let user = otherUser {
                            Text("\(user.firstName) \(user.lastName)")
                                .fontWeight(.semibold)
                                .kerning(1.2)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text(String(post.timeStamp.formatted(.dateTime.hour().minute())))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.caption)
                        }
                    }
                    
                }
                .onAppear() {
                    Task {
                        await getUser(userId: post.user)
                    }
                    
                }
                .padding([.leading, .trailing, .top])
            }
            else {
                ProgressView()
            }
        }
        if !isPostView {
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
                        .padding(.leading)
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
            .onAppear() {
                    if let user = otherUser {
                        getUser(userId: user.id)
                    }
                
                
            }
        }
        
        
        
    }
    func getUser(userId: String) {
        authViewModel.fetchOtherUserFromFirebase(id: userId) { fetchedUser in
            otherUser = fetchedUser
            if let profilePic = otherUser?.profilePic {
                getProfilePic(photoId: profilePic)
                
            }
        }
    }
    
    func getProfilePic(photoId: String) {
        authViewModel.fetchPhotoData(photoId: photoId) { fetchedData in
            if photoId != "" {
                if let data = fetchedData {
                    print("Downloaded photo data:", data)
                    image = UIImage(data: data)
                } else {
                    image = nil
                }
            } else {
                image = nil
            }
            
        }
    }
}

//#Preview {
//    PersonCellView()
//}
