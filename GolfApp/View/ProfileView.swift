//
//  LandingView.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 11/3/23.
//

import SwiftUI
import FirebaseDatabase

struct ProfileView: View {
    @StateObject var authViewModel: AuthViewModel = AuthViewModel()
    @State private var user: User?
    @State private var teeTimeBtnSelected: Bool = false
    @State private var profileBtnSelected: Bool = true
    @State private var friendsListBtnSelected: Bool = false
    @State private var isLoading: Bool = true
    let coverPhotoUrl = URL(string: "https://i.pinimg.com/564x/5e/2c/65/5e2c653bfbf2d681fa39358aa4132f9e.jpg")
    let userPhotoUrl = URL(string: "https://images.unsplash.com/photo-1629747490241-624f07d70e1e?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OHx8cG9ydHJhaXRzfGVufDB8fDB8fHww")
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack (spacing: 0){
                    VStack {
                        ProfileImage(imageState: .empty)
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(width: 125, height: 125)
                            .background {
                                Circle().fill(Color("Gray"))
                            }
                            .padding(22)
                    }
                    .frame(maxWidth: .infinity)
                    .background(Image("golf-background").resizable().ignoresSafeArea())
                    HStack {
                        Text("Zachary Boutchyard")
                            .fontWeight(.light)
                            .kerning(1.2)
                            .padding(.leading)
                            .padding()
                        Spacer()
                        Button(action: {
                            //TODO: handle editing
                        }, label: {
                            Text("Update profile")
                            
                        })
                        .padding(.trailing)
                        .padding()
                        .buttonStyle(.borderedProminent)
                    }
                    .background(.gray)
                }
                VStack {
                    HStack {
                        Button(action: {
                                profileBtnSelected = true
                                teeTimeBtnSelected = false
                            friendsListBtnSelected = false
                        }, label: {
                            Text("Profile")
                        })
                        .buttonStyle(.bordered)
                        .tint(profileBtnSelected ? .blue : nil)
                        Button(action: {
                            teeTimeBtnSelected = true
                            profileBtnSelected = false
                            friendsListBtnSelected = false
                        }, label: {
                            Text("Tee Time")
                        })
                        .buttonStyle(.bordered)
                        .tint(teeTimeBtnSelected ? .blue : nil)
                        Button(action: {
                            teeTimeBtnSelected = false
                            profileBtnSelected = false
                            friendsListBtnSelected = true
                        }, label: {
                            Text("Friends")
                        })
                        .buttonStyle(.bordered)
                        .tint(friendsListBtnSelected ? .blue : nil)
                    } .padding(.vertical, 5)
                    
                    if profileBtnSelected {
                        Divider()
                        Text("Information")
                            .fontWeight(.semibold)
                            .kerning(1.2)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading)
                            .padding()
                        Divider()
                            .padding(.horizontal)
                        Section {
                            HStack {
                                Text("About me:")
                                    .fontWeight(.regular)
                                    .kerning(1.2)
                                    .padding()
                                    .padding(.leading)
                                Spacer()
                                Text("here is a bio written from the user that describes something unique about them, it has to be less than 200 chars")
                                    .fontWeight(.light)
                                    .kerning(1.2)
                                    .padding()
                                    .padding(.trailing)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                    .multilineTextAlignment(.trailing)
                            }
                            HStack {
                                Text("Interests:")
                                    .fontWeight(.regular)
                                    .kerning(1.2)
                                    .padding()
                                    .padding(.leading)
                                Spacer()
                                Text("Volleyball, Tennis, Stuff, Things, Things I like to Do")
                                    .fontWeight(.light)
                                    .kerning(1.2)
                                    .padding()
                                    .padding(.trailing)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                    .multilineTextAlignment(.trailing)
                            }
                            HStack {
                                Text("Handicap:")
                                    .fontWeight(.regular)
                                    .kerning(1.2)
                                    .padding()
                                    .padding(.leading)
                                Spacer()
                                Text("18")
                                    .fontWeight(.light)
                                    .kerning(1.2)
                                    .padding()
                                    .padding(.trailing)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                    .multilineTextAlignment(.trailing)
                            }
                            HStack {
                                Text("Home course:")
                                    .fontWeight(.regular)
                                    .kerning(1.2)
                                    .padding()
                                    .padding(.leading)
                                Spacer()
                                Text("Asheboro Municipal")
                                    .fontWeight(.light)
                                    .kerning(1.2)
                                    .padding()
                                    .padding(.trailing)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                    .multilineTextAlignment(.trailing)
                            }
                        }
                    }
                    if teeTimeBtnSelected {
                        VStack {
                            Text("Some text about tee times...")
                        }
                    }
                    
                    if friendsListBtnSelected {
                        Text("Some text about friends list...")
                    }
                   
                }
            }
        }
        
        
        
        .onAppear(){
            fetchData()
        }
    }
    
    func fetchData() {
        authViewModel.fetchUserDataFromFirebase() { fetchedUser in
            user = fetchedUser
            isLoading = false
        }
    }
}

#Preview {
    ProfileView()
}
