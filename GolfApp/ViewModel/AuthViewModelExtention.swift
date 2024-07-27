//
//  AuthViewModelExtention.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 3/24/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseMessaging

extension AuthViewModel {
    
    @MainActor
    func fetchAllDataForLandingView() async {
        state = .loading
        guard let fetchedUser = await fetchUserDataFromFirebase() else {
            state = .error // Assuming you have an error state
            return
        }
        do {
            let token = Messaging.messaging().fcmToken
            if token != fetchedUser.fcmToken {
                await self.updateFcmToken()
            }
            await fetchAllPostsAndUserData()
            
            if fetchedUser.receivedRequests != nil {
                await self.fetchOtherUsersByRequest()
            }
            await fetchUserInfo(user: fetchedUser)
            if let friends = fetchedUser.friendsList {
                await fetchFriendsFromFirebase(ids: friends)
            }
            await self.fetchAllOtherUsersFromFirebase()
            if let userPosts = self.user?.posts {
                await self.fetchAllPostsInUserObject(postIds: userPosts)
            }
            self.state = .loaded
        }
    }
    
    func fetchUserInfo(user: User) async {
        if let notifications = user.notifications {
            for notification in notifications {
                await fetchUserInfoById(userId: notification.userCommenting)
            }
        }
    }
    
    func fetchOtherUsersByRequest() async {
        if let user = user {
            if let receivedRequests = user.receivedRequests {
                for request in receivedRequests {
                    await fetchOtherUserFromFirebase(id: request.user) { fetchedOtherUser in
                        // Check if the fetched user is not already in the array
                        if !self.otherUserPendingRequest.contains(where: { user in
                            return user.id == fetchedOtherUser?.id // Update with the actual property used for comparison
                        }) {
                            // Append the fetched user to the array
                            if let fetchedUser = fetchedOtherUser {
                                self.otherUserPendingRequest.append(fetchedUser)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func fetchUserDataFromFirebase() async -> User? {
        await withCheckedContinuation { continuation in
            Task { @MainActor in
                fetchUserDataFromFirebase { fetchedUser in
                    continuation.resume(returning: fetchedUser)
                }
            }
        }
    }
    
    func fetchAllPostsFromFirebase() async -> [Post]? {
        await withCheckedContinuation { continuation in
            fetchAllPostsFromFirebase { fetchedPost in
                continuation.resume(returning: fetchedPost)
            }
        }
    }
    
    func fetchOtherUserFromFirebase(id: String) async -> OtherUser? {
        await withCheckedContinuation { continuation in
            Task { @MainActor in
                self.fetchOtherUserFromFirebase(id: id) { fetchedUser in
                    continuation.resume(returning: fetchedUser)
                }
            }
        }
    }
    
    func fetchAllPostsAndUserData() async {
        
        let fetchedPosts = await fetchAllPostsFromFirebase()
        await withTaskGroup(of: Void.self) { group in
            for post in fetchedPosts ?? [] {
                group.addTask {
                    _ = await self.fetchOtherUserFromFirebase(id: post.user)
                }
            }
            await group.waitForAll()
        }
    }
    
    func fetchUserInfoById(userId: String) async {
        await fetchOtherUserFromFirebase(id: userId) { fetchedOtherUser in
            self.otherUserNotifications[userId] = fetchedOtherUser
        }
    }
    
    func saveUserData(user: User, completion: @escaping (Bool, Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(false, nil)
            return
        }
        let database = Firestore.firestore()
        let usersRef = database.collection("Users").document(uid)
        // Prepare the data dictionary
        var data: [String: Any] = [
            "firstName": user.firstName,
            "lastName": user.lastName,
            "email": user.email
        ]
        // Optional fields
        if let bio = user.bio { data["bio"] = bio }
        if let interests = user.interests { data["interests"] = interests }
        if let handicap = user.handicap { data["handicap"] = handicap }
        if let homeCourse = user.homeCourse { data["homeCourse"] = homeCourse }
        usersRef.setData(data, merge: true) { error in
            if let error = error {
                print("Error updating user: \(error)")
                completion(false, error)
            } else {
                print("User successfully updated.")
                completion(true, nil)
            }
        }
    }
}
