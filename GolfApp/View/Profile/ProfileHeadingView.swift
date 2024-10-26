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
    @ObservedObject var authViewModel: AuthViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            VStack {
                if let data = user.profilePicData, let uiImage = UIImage(data: data) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 125, height: 125)
                            .clipShape(Circle())
                            .background {
                                Circle().fill(Color("AppGray"))
                            }
                            .foregroundStyle(.whiteOrDark)
                    } else {
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
    }
}

// #Preview {
//    ProfileHeadingView(isEditButtonClicked: .constant(false), isOtherViewTriggered: .constant(false))
// }
