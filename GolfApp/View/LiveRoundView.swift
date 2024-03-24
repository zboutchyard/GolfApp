//
//  LiveRoundView.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 1/9/24.
//

import SwiftUI

struct LiveRoundView: View {
    @State var score: Int = 0
    @FocusState var isTextFieldFocused: Bool
    @State var likeBtnClicked: Bool = false
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    
                    Text("Hole 1")
                        .fontWeight(.medium)
                        .font(.title)
                    
                }
                HStack {
                    Button(action: {}, label: {
                        Image(systemName: "arrow.left.square.fill")
                            .resizable()
                            .frame(maxWidth: 50, maxHeight: 50)
                            .foregroundStyle(Color.green)
                            .padding(.leading)
                    })
                    
                    Spacer()
                    Image(systemName: "person.fill")
                        .resizable()
                        .scaledToFit()
                        .clipShape(Circle())
                        .frame(width: 100, height: 100)
                        .background {
                            Circle().fill(Color("AppGray"))
                        }
                        .foregroundStyle(.whiteOrDark)
                    Spacer()
                    Button(action: {
                        
                    }, label: {
                        Image(systemName: "arrow.right.square.fill")
                            .resizable()
                            .foregroundStyle(Color.green)
                            .frame(maxWidth: 50, maxHeight: 50)
                            .padding(.trailing)
                    })
                    
                }
                Picker(selection: .constant(1), label: Text("Picker")) {
                    Text("Zack Boutchyard").tag(1)
                        .foregroundStyle(.black)
                    Text("Kayla Boutchyard").tag(2)
                }
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.green.opacity(0.3))
                )
                HStack {
                    VStack {
                        Text("Score")
                            .font(.title3)
                            .kerning(1.2)
                            .fontWeight(.semibold)
                        Picker(selection: .constant(1), label: Text("Picker")) {
                            Text("Eagle").tag(1)
                            Text("2").tag(2)
                        }
                        .frame(maxHeight: 125)
                        .pickerStyle(.wheel)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.green.opacity(0.3))
                                .padding(.horizontal, 10)
                        )
                    }
                    VStack {
                        Text("Putts")
                            .font(.title3)
                            .kerning(1.2)
                            .fontWeight(.semibold)
                        Picker(selection: .constant(1), label: Text("Picker")) {
                            Text("Eagle").tag(1)
                            Text("2").tag(2)
                        }
                        .frame(maxHeight: 125)
                        .pickerStyle(.wheel)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.green.opacity(0.3))
                                .padding(.horizontal, 10)
                        )
                        
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
                .padding(.bottom, 40)
                MessageToolbar(isTextFieldFocused: _isTextFieldFocused)
                Divider()
                    .padding(.bottom, 5)
                HStack {
                    
                    
                    
                    Image(systemName: "person.fill")
                        .scaledToFill()
                        .clipShape(Circle())
                        .frame(width: 50, height: 50)
                        .background {
                            Circle().fill(Color("AppGray"))
                        }
                        .foregroundStyle(.whiteOrDark)
                    
                    
                    
                    VStack {
                        
                        Text("Jane Mary")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("Hey there!")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                    }
                    
                    
                }
                .padding()
                Divider()
            }
        }
    }
    struct MessageToolbar: View {
        //        @State var post: Post
        @State private var comment: String = ""
        @FocusState var isTextFieldFocused: Bool
        //        var onCommentAdded: () -> Void
        //        @StateObject var authViewModel: AuthViewModel = AuthViewModel()
        
        
        var body: some View {
            HStack {
                CustomTextField(placeholder: Text("...type something").foregroundStyle(.black), text: $comment, isTextFieldFocused: _isTextFieldFocused)
                Button(action: {
                  //button action
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
}

#Preview {
    LiveRoundView()
}
