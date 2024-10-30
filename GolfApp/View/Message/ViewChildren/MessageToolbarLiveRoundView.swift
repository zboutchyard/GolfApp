//
//  MessageToolbar.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 10/16/24.
//
import SwiftUI

struct MessageToolbarLiveRoundView: View {
        //        @State var post: Post
        @State private var comment: String = ""
        @FocusState var isTextFieldFocused: Bool
        var body: some View {
            HStack {
                CustomTextFieldWithTextFieldFocused(
                    placeholder: Text("...type something")
                        .foregroundStyle(.black),
                    text: $comment,
                    isTextFieldFocused: _isTextFieldFocused)
                Button(action: {
                    // button action
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
