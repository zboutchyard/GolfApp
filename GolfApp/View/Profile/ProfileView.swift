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
    @State private var isEditButtonClicked = false
    @State private var isOtherViewClicked = false
    let coverPhotoUrl = URL(string: "https://i.pinimg.com/564x/5e/2c/65/5e2c653bfbf2d681fa39358aa4132f9e.jpg")
    let userPhotoUrl = URL(string: "https://images.unsplash.com/photo-1629747490241-624f07d70e1e?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OHx8cG9ydHJhaXRzfGVufDB8fDB8fHww")
    
    var body: some View {
        NavigationStack {
            ScrollView {
                ProfileHeadingView(isEditButtonClicked: $isEditButtonClicked, isOtherViewTriggered: $isOtherViewClicked)
                if !isEditButtonClicked {
                    VStack {
                        HStack {
                            Button(action: {
                                isOtherViewClicked = false
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
                                isOtherViewClicked = true
                            }, label: {
                                Text("Tee Time")
                            })
                            .buttonStyle(.bordered)
                            .tint(teeTimeBtnSelected ? .blue : nil)
                            Button(action: {
                                teeTimeBtnSelected = false
                                profileBtnSelected = false
                                friendsListBtnSelected = true
                                isOtherViewClicked = true
                            }, label: {
                                Text("Friends")
                            })
                            .buttonStyle(.bordered)
                            .tint(friendsListBtnSelected ? .blue : nil)
                        } .padding(.vertical, 5)
                        
                        if profileBtnSelected {
                            ProfileInfoView()
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
                if isEditButtonClicked {
                    EditProfileView()
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
