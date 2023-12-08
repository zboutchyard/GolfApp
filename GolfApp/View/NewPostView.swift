//
//  NewPostView.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 11/28/23.
//

import SwiftUI

struct NewPostView: View {
    @State var postText: String = ""
    @ObservedObject var authViewModel: AuthViewModel = AuthViewModel()
    @State var user: User
    @Environment(\.presentationMode) var presentationMode
    var onPostSubmitted: (() -> Void)?
    
    var body: some View {
        ScrollView {
            HStack {
                Image(systemName: "person.fill")
                    .scaledToFill()
                    .foregroundStyle(.whiteOrDark)
                    .clipShape(Circle())
                    .frame(width: 50, height: 50)
                    .background {
                        Circle().fill(Color("AppGray"))
                    }
                Text("\(user.firstName) \(user.lastName)")
                    .fontWeight(.semibold)
                    .kerning(1.2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Button(action: {
                    authViewModel.addPost(text: postText) {post in
                        onPostSubmitted?()
                        presentationMode.wrappedValue.dismiss()
                    }
                }, label: {
                    Text("Post")
                })                        .buttonStyle(.borderedProminent)
                
                
            }
            .padding()
            TextField("tell me something..", text: $postText, axis: .vertical)
                .lineLimit(12)
        }
    }
}

#Preview {
    NewPostView(user: User(firstName: "Zack", lastName: "Boutchyard", email: "zackboutchyard"))
}
