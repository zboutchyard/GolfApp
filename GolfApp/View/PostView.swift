//
//  PostView.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 11/23/23.
//

import SwiftUI

struct PostView: View {
//    var photoUrl = URL(string: "https://images.unsplash.com/photo-1629747490241-624f07d70e1e?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OHx8cG9ydHJhaXRzfGVufDB8fDB8fHww")
    @State private var likeBtnClicked: Bool = false
    @State private var commentBtnClicked: Bool = false
    @State private var userClicked: Bool = false

    var body: some View {
        RoundedRectangle(cornerRadius: 30).fill(.white).overlay {
            VStack {
                Button(action: {
                    userClicked = true
                }, label: {
                    HStack {
                        Image(systemName: "person.fill")
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(width: 50, height: 50)
                            .background {
                                Circle().fill(Color("Gray"))
                            }
                        VStack {
                            Text("Zack Boutchyard")
                                .fontWeight(.semibold)
                                .kerning(1.2)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("3h")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.caption)
                        }
                    }
                    .padding([.leading, .trailing, .top])
                })
                .buttonStyle(.plain)
                
                Text("Here is some text about a post that might contain something that they want to say or complain about. ")
                    .fontWeight(.medium)
                    .kerning(1.2)
                    .font(.title3)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.leading, .trailing])
                HStack {
                    Image(systemName: "hand.thumbsup.fill")
                        .background(Circle().fill(.blue).frame(width: 20, height: 20))
                        .foregroundStyle(.white)
                        .padding([.leading])
                    Text("2")
                        Spacer()
                    
                }
                .padding(.top, 0.5)
                .padding(.bottom, 0.5)
                Divider()
                    .padding(.bottom, 15)
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
            }
            .background(Color.white)

        }
        .frame(height: 300)
            }
}

#Preview {
    PostView()
}
