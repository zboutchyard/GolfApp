//
//  LandingView.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 11/3/23.
//

import SwiftUI
import FirebaseDatabase


//class MockAuthViewModel: ObservableObject {
//    func fetchUserDataFromFirebase(completion: @escaping (User?) -> Void) {
//        // Mock implementation for testing in previews
//        let mockUser = User(firstName: "Zack", lastName: "Boutchyard", email: "Zackboutchyard@gmail.com")
//        completion(mockUser)
//    }
//}

struct ProfileView: View {
//    @StateObject var authViewModel: AuthViewModel = AuthViewModel()
    @StateObject var authViewModel: AuthViewModel = AuthViewModel()
    @State private var user: User?
    @State private var isLoading: Bool = true
    var body: some View {
        VStack {
            if !isLoading {
                if let user = user {
                    Text("Name: \(user.firstName) \(user.lastName)")
                    Text("Email: \(user.email)")
                } else {
                    Text("User Data not available")
                }
            }
            if isLoading {
                ProgressView("Fetching your profile information")
                    .progressViewStyle(.circular)
                    .padding()
            }
        } .onAppear(){
            fetchData()
            print("here is user in profile view \(user)")
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
