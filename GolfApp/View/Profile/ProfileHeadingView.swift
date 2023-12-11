//
//  ProfileHeadingView.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 11/23/23.
//

import SwiftUI

struct ProfileHeadingView: View {
    @State var user: User
    @Binding var isEditButtonClicked: Bool
    @Binding var isOtherViewTriggered: Bool
    @ObservedObject var authViewModel: AuthViewModel = AuthViewModel()
    @State var image: UIImage?

    var body: some View {
        VStack (spacing: 0){
            VStack {
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 125, height: 125)
                        .clipShape(Circle())
                        .background {
                            Circle().fill(Color("AppGray"))
                        }
                        .padding(22)
                }else {
                    ProfileImage(imageState: .empty)
                        .scaledToFill()
                        .clipShape(Circle())
                        .frame(width: 125, height: 125)
                        .background {
                            Circle().fill(Color("AppGray"))
                        }
                        .padding(22)
                }
            }
            .frame(maxWidth: .infinity)
            .background(Image("golf-background").resizable().ignoresSafeArea())
            HStack {
                Text("\(user.firstName) \(user.lastName)")
                    .fontWeight(.light)
                    .kerning(1.2)
                    .padding(.leading)
                    .padding()
                    .lineLimit(1)
                Spacer()
                if !isEditButtonClicked && !isOtherViewTriggered {
                    Button(action: {
                        isEditButtonClicked.toggle()
                    }, label: {
                        Text("Update profile")
                        
                    })
                    .padding(.trailing)
                    .padding()
                    .buttonStyle(.borderedProminent)
                }
                if isEditButtonClicked {
                    Button(action: {
                        isEditButtonClicked.toggle()
                    }, label: {
                        Text("Submit")
                        
                    })
                    .padding(.trailing)
                    .padding()
                    .buttonStyle(.borderedProminent)
                }
                
            }
            .background(.gray)
        }
        .onAppear() {
            if let profilePic = user.profilePic {
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
//    ProfileHeadingView(isEditButtonClicked: .constant(false), isOtherViewTriggered: .constant(false))
//}
