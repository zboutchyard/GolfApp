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
    @State var isTeeSelectorClicked: Bool = false
    
    var body: some View {
        VStack {
            VStack {
                VStack {
                    ScrollView {
                        HStack {
                            Image(systemName: "person.fill")
                                .scaledToFill()
                                .clipShape(Circle())
                                .frame(width: 50, height: 50)
                                .background {
                                    Circle().fill(Color("AppGray"))
                                }
                                .foregroundStyle(.whiteOrDark)
                            Text("Zack Boutchyard")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.bottom, 3)
                                .fontWeight(.medium)
                                .font(.title2)
                                .kerning(0.8)
                        }
                        .padding(.leading, 5)
                        
                        Button {
                            //add player
                        } label: {
                            HStack {
                                Image(systemName: "person.badge.plus")
                                Text("Add player")
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.bottom)


                        VStack {
                            TextField("Course name", text: $courseName, prompt: Text("Where are you playing?"))
                                .fontWeight(.medium)
                                .font(.title2)
                                .kerning(0.8)
                                .padding(20)
                                .cornerRadius(50, corners: .allCorners)
                        }
                        .background(.whiteOrDark)
                        VStack {
                            Button {
                                isTeeSelectorClicked = true
                            } label: {
                                HStack {
                                    Circle()
                                        .frame(width: 10, height: 10)
                                        .foregroundStyle(.blue)
                                    Text("Blue")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .fontWeight(.medium)
                                        .font(.title2)
                                        .kerning(0.8)
                                }
                                .padding()
                            }
                            .buttonStyle(.plain)

                        }
                        .background(.whiteOrDark)

                        VStack {
                            HStack {
                                Text("How many holes?")
                                    .fontWeight(.medium)
                                    .font(.title2)
                                    .kerning(0.8)
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
                                .fontWeight(.medium)
                                .font(.title2)
                                .kerning(0.8)
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
                                .fontWeight(.medium)
                                .font(.title2)
                                .kerning(0.8)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .foregroundStyle(.white)
                        
                    }
            }
            .padding(.horizontal)
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
        .padding(.top)
        .onTapGesture {
            hideKeyboard()
        }
        .sheet(isPresented: $isTeeSelectorClicked) {
            VStack {
                HStack {
                    Button {
                        //
                    } label: {
                        HStack {
                            Circle()
                                .frame(width: 10, height: 10)
                                .foregroundStyle(.black)
                            Text("Black")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .fontWeight(.medium)
                                .font(.title2)
                                .kerning(0.8)
                        }
                        .padding()
                    }
                    .buttonStyle(.plain)
                }
                .background(.whiteOrDark)
                HStack {
                    Button {
                        //
                    } label: {
                        HStack {
                            Circle()
                                .frame(width: 10, height: 10)
                                .foregroundStyle(.blue)
                            Text("Blue")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .fontWeight(.medium)
                                .font(.title2)
                                .kerning(0.8)
                        }
                        .padding()
                    }
                    .buttonStyle(.plain)
                }
                .background(.whiteOrDark)
                HStack {
                    Button {
                        //
                    } label: {
                        HStack {
                            Circle()
                                .frame(width: 10, height: 10)
                                .foregroundStyle(.white)
                            Text("White")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .fontWeight(.medium)
                                .font(.title2)
                                .kerning(0.8)
                        }
                        .padding()
                    }
                    .buttonStyle(.plain)
                }
                .background(.whiteOrDark)
                HStack {
                    Button {
                        //
                    } label: {
                        HStack {
                            Circle()
                                .frame(width: 10, height: 10)
                                .foregroundStyle(.yellow)
                            Text("Yellow")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .fontWeight(.medium)
                                .font(.title2)
                                .kerning(0.8)
                        }
                        .padding()
                    }
                    .buttonStyle(.plain)
                }
                .background(.whiteOrDark)
                HStack {
                    Button {
                        //
                    } label: {
                        HStack {
                            Circle()
                                .frame(width: 10, height: 10)
                                .foregroundStyle(.red)
                            Text("Red")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .fontWeight(.medium)
                                .font(.title2)
                                .kerning(0.8)
                        }
                        .padding()
                    }
                    .buttonStyle(.plain)
                }
                .background(.whiteOrDark)
            }
            .padding(.top)
            .padding(.horizontal)
            .frame(maxHeight: .infinity, alignment: .top)
            .presentationDetents([.height(400)])
            .presentationDragIndicator(.visible)
        }
    


        
       
    }
    private func hideKeyboard() {
           UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
       }
    
}

#Preview {
    ScoreCardView()
}
