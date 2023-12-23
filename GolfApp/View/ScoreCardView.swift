//
//  TeeTimeView.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 11/22/23.
//

import SwiftUI

struct ScoreCardView: View {
    @State var user: User?
    @State var courseName: String = ""
    @State private var selectedHoles: Int? // Add this state to track selected holes
    @State var isShareRoundSelected: Bool = false
    @State var isPopoverActivated: Bool = false
    @State private var isExpanded: Bool = false
    @State var postText: String = ""
    
    var body: some View {
        VStack {
            VStack {
                VStack {
                    ScrollView {
                        //TODO: implement course name
                        VStack {
                            TextField("Course name", text: $courseName, prompt: Text("Where are you playing?"))
                                .font(.title2)
                                .fontWeight(.medium)
                                .kerning(1.2)
                                .padding(20)
                                .cornerRadius(50, corners: .allCorners)
                        }
                        .padding(.top, 10)
                        .background(.whiteOrDark)
                        VStack {
                            HStack {
                                Text("How many holes?")
                                    .font(.title2)
                                    .fontWeight(.medium)
                                    .kerning(1.2)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding()
                                    .cornerRadius(50, corners: .allCorners)
                                
                                ZStack {
                                    HStack(spacing: 1) {
                                        RoundedCorner(radius: 20, corners: [.topLeft, .bottomLeft])
                                            .fill(selectedHoles == 9 ? Color.blue : Color.gray.opacity(0.2))
                                            .frame(height: 50)
                                            .overlay {
                                                Button {
                                                    selectedHoles = 9
                                                } label: {
                                                    Text("9")
                                                }
                                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                                .foregroundColor(selectedHoles == 9 ? .white : .blue)
                                            }
                                        RoundedCorner(radius: 20, corners: [.topRight, .bottomRight])
                                            .fill(selectedHoles == 18 ? Color.blue : Color.gray.opacity(0.2))
                                            .frame(height: 50)
                                            .overlay {
                                                Button {
                                                    selectedHoles = 18
                                                } label: {
                                                    Text("18")
                                                }
                                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                                .foregroundColor(selectedHoles == 18 ? .white : .blue)
                                            }
                                    }
                                }
                                .frame(height: 50)
                                .cornerRadius(20)
                                .padding()
                            }
                        }
                        .background(.whiteOrDark)
                        VStack {
                            HStack {
                                Button {
                                    isPopoverActivated = true
                                } label: {
                                    Image(systemName: "questionmark.circle.fill")
                                }
                                
                                Toggle(
                                    "Start live round",
                                    isOn: $isShareRoundSelected
                                )
                                .onChange(of: isShareRoundSelected) {
                                    withAnimation {
                                        isExpanded.toggle()
                                    }
                                }
                            }
                            .padding()
                            if isExpanded {
                                Divider()
                                VStack {
                                    TextField("...What do you want to say?", text: $postText)
                                        .scrollContentBackground(.hidden)
                                        .frame(height: 400, alignment: .top)
                                        .background(Color.whiteOrDark)
                                        .transition(.slide)
                                        .animation(.easeInOut, value: isExpanded)
                                }
                                .background(.whiteOrDark)
                            }
                            
                        }
                        .background(.whiteOrDark)
                    }
                }
            }
            Spacer()
            VStack {
                RoundedCorner(radius: 50, corners: .allCorners)
                    .fill(.green)
                    .frame(height: 50)
                    .overlay {
                        Button {
                            //
                        } label: {
                            Text("Start round")
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .foregroundStyle(.white)
                        
                    }
            }
            .padding(.bottom)
            .frame(alignment: .bottom)
            .popover(isPresented: $isPopoverActivated ,
                     attachmentAnchor: .point(.center),
                     arrowEdge: .top,
                     content: {
                PopoverScoreCardView()
                    .padding()
                    .presentationCompactAdaptation(.automatic)
            })
            
            
        }
    


        
       
    }
    
}

#Preview {
    ScoreCardView()
}
