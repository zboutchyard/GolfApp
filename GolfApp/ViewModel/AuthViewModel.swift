//
//  AuthViewModel.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 11/4/23.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import SwiftUI
import PhotosUI
import FirebaseStorage
import FirebaseMessaging
import FirebaseCore

class AuthViewModel: ObservableObject {
    @Published var otherUsers: [OtherUser]?
    @Published var friends: [OtherUser]?
    @Published var postOtherUsers: [String: OtherUser]? = [:]
    @Published var friend: OtherUser?
    @Published var friendId: String?
    @Published var friendsList: [OtherUser]?
    @Published var posts: [Post]?
    @Published var post: Post?
    @Published var userPosts: [Post] = []
    @Published var isUserLoggedIn: Bool = false
    @Published var user: User?
    @Published var state: AppState = .loading
    @Published var otherUserPendingRequest: [OtherUser] = []
    @Published var otherUserNotifications: [String: OtherUser] = [:]
    @Published var shouldLoad: Bool = false
    @Published private(set) var imageState: ImageState = .empty
    @Published var profileImage: ProfileImage?
    @Published var adPositions: [Int] = []
    @Published var imageSelection: PhotosPickerItem? {
        didSet {
            if let imageSelection {
                let progress = loadTransferable(from: imageSelection)
                imageState = .loading(progress)
            } else {
                imageState = .empty
            }
        }
    }

    init() {
        FirebaseApp.configure()
        if Auth.auth().currentUser != nil {
            self.isUserLoggedIn = true
            Task {
                await fetchAllDataForLandingView()
            }
        } else {
            self.isUserLoggedIn = false
        }
    }
    
    enum ImageState {
        case empty
        case loading(Progress)
        case success(Image)
        case failure(Error)
    }
    
    enum AppState {
        case loading
        case loaded
        case error
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.isUserLoggedIn = false            
        } catch {
            print("error signing out")
        }
    }
    
    func setupRandomAdPositions(for postCount: Int) {
        adPositions.removeAll()
        var potentialPositions = Set(1..<postCount) // Start from 1 to avoid the first position
        
        while adPositions.count < postCount / 4 { // Adjust the division factor as needed
            guard let randomPosition = potentialPositions.randomElement() else { break }
            adPositions.append(randomPosition)
            // Remove nearby positions to avoid consecutive ads
            potentialPositions.remove(randomPosition)
            potentialPositions.remove(randomPosition + 1)
            potentialPositions.remove(randomPosition - 1)
        }
    }
    
    @MainActor
    func fetchUserDataFromFirebase(completion: @escaping (User?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(nil)
            state = .error
            return
        }
        let database = Firestore.firestore()
        let usersRef = database.collection("Users").document(uid)
        usersRef.getDocument { (document, _) in
            if let document = document, document.exists {
                if let data = document.data(),
                   let firstName = data["firstName"] as? String,
                   let lastName = data["lastName"] as? String,
                   let email = data["email"] as? String {
                    // Optional fields with default values
                    let profilePic = data["profilePic"] as? String ?? ""
                    let chats = data["chats"] as? [String] ?? []
                    let friendsList = data["friendsList"] as? [String] ?? []
                    let bio = data["bio"] as? String ?? ""
                    let handicap = data["handicap"] as? Int ?? 0
                    let interests = data["interests"] as? String ?? ""
                    let homeCourse = data["homeCourse"] as? String ?? ""
                    let notificationsData = data["notifications"] as? [[String: Any]] ?? []
                    let posts = data["posts"] as? [String] ?? []
                    let sentRequestsData = data["sentRequests"] as? [[String: Any]] ?? []
                    let receivedRequestsData = data["receivedRequests"] as? [[String: Any]] ?? []
                    let fcmToken = data["fcmToken"] as? String
                    let sentRequests = sentRequestsData.compactMap { requestData in
                        if let user = requestData["user"] as? String {
                            return Request(user: user)
                        } 
                        return nil
                    }
                    let receivedRequests = receivedRequestsData.compactMap { requestData in
                        if let user = requestData["user"] as? String {
                            return Request(user: user)
                        }
                        return nil
                    }
                    // Convert notificationsData into an array of Notification objects
                    let notifications = notificationsData.compactMap { notificationData in
                        if let text = notificationData["text"] as? String,
                           let id = notificationData["id"] as? String,
                           let hasBeenRead = notificationData["hasBeenRead"] as? Bool,
                           let timeStamp = notificationData["timeStamp"] as? Timestamp,
                           let userCommenting = notificationData["userCommenting"] as? String,
                            let postId = notificationData["postId"] as? String {
                            let timeStamp = timeStamp.dateValue()
                            return Notification(
                                id: id,
                                hasBeenRead: hasBeenRead,
                                text: text,
                                timeStamp: timeStamp,
                                userCommenting: userCommenting,
                                postId: postId)
                        }
                        return nil
                    }
                    if !profilePic.isEmpty {
                        self.fetchPhotoData(photoId: profilePic) { fetchedPhoto in
                            let userModel = User(
                                firstName: firstName,
                                lastName: lastName,
                                email: email,
                                profilePicData: fetchedPhoto,
                                chats: chats,
                                friendsList: friendsList,
                                bio: bio,
                                interests: interests,
                                handicap: handicap,
                                homeCourse: homeCourse,
                                posts: posts,
                                sentRequests: sentRequests,
                                receivedRequests: receivedRequests,
                                notifications: notifications,
                                fcmToken: fcmToken)
                            self.user = userModel
                            completion(userModel)
                        }
                    } else {
                        let userModel = User(
                            firstName: firstName,
                            lastName: lastName,
                            email: email,
                            chats: chats,
                            friendsList: friendsList,
                            bio: bio,
                            interests: interests,
                            handicap: handicap,
                            homeCourse: homeCourse,
                            posts: posts,
                            sentRequests: sentRequests,
                            receivedRequests: receivedRequests,
                            notifications: notifications,
                            fcmToken: fcmToken)
                        self.user = userModel
                        completion(userModel)
                    }
                } else {
                    self.state = .error
                    completion(nil)
                }
            } else {
                self.state = .error
                completion(nil)
            }
        }
    }
    
    @MainActor
    func fetchOtherUserFromFirebase(id: String, completion: @escaping (OtherUser?) -> Void) {
        let database  = Firestore.firestore()
        let usersRef = database.collection("Users").document(id)
        usersRef.getDocument { [self] (document, error) in
            if let document = document, document.exists {
                if let data = document.data() ?? nil,
                   let firstName = data["firstName"] as? String,
                   let lastName = data["lastName"] as? String {
                    let profilePic = data["profilePic"] as? String
                    let bio = data["bio"] as? String ?? ""
                    let interests = data["interests"] as? String ?? ""
                    let handicap = data["handicap"] as? Int ?? 0
                    let homeCourse = data["homeCourse"] as? String ?? ""
                    let posts = data["posts"] as? [String] ?? []
                    if profilePic != nil {
                        fetchPhotoData(photoId: profilePic ?? "") { fetchedPhoto in
                            let otherUserModel = OtherUser(
                                id: id,
                                firstName: firstName,
                                profilePicData: fetchedPhoto,
                                lastName: lastName,
                                bio: bio,
                                interests: interests,
                                handicap: handicap,
                                homeCourse: homeCourse,
                                posts: posts)
                            self.postOtherUsers?[id] = otherUserModel
                            completion(otherUserModel)
                        }
                    } else {
                        let otherUserModel = OtherUser(
                            id: id,
                            firstName: firstName,
                            lastName: lastName,
                            bio: bio,
                            interests: interests,
                            handicap: handicap,
                            homeCourse: homeCourse,
                            posts: posts)
                        self.postOtherUsers?[id] = otherUserModel
                        completion(otherUserModel)
                    }
                } else {
                    print(error?.localizedDescription ?? "")
                    completion(nil)
                }
            } else {
                print(error?.localizedDescription ?? "")
                completion(nil)
            }
        }
    }
    
    @MainActor
    func fetchFriendsFromFirebase(ids: [String]) {
        let database = Firestore.firestore()
        var otherUsers = [OtherUser]()
        for id in ids {
            let usersRef = database.collection("Users").document(id)
            usersRef.getDocument { [self] (document, error) in
                if let document = document, document.exists {
                    if let data = document.data() ?? nil,
                       let firstName = data["firstName"] as? String,
                       let lastName = data["lastName"] as? String {
                        let profilePic = data["profilePic"] as? String
                        let bio = data["bio"] as? String ?? ""
                        let interests = data["interests"] as? String ?? ""
                        let handicap = data["handicap"] as? Int ?? 0
                        let homeCourse = data["homeCourse"] as? String ?? ""
                        let posts = data["posts"] as? [String] ?? []
                        if profilePic != nil {
                            fetchPhotoData(photoId: profilePic ?? "") { fetchedPhoto in
                                let otherUserModel = OtherUser(
                                    id: id, 
                                    firstName: firstName,
                                    profilePicData: fetchedPhoto,
                                    lastName: lastName,
                                    bio: bio,
                                    interests: interests,
                                    handicap: handicap,
                                    homeCourse: homeCourse,
                                    posts: posts)
                                otherUsers.append(otherUserModel)
                                self.friendsList = otherUsers
                            }
                        } else {
                            let otherUserModel = OtherUser(
                                id: id, 
                                firstName: firstName,
                                lastName: lastName,
                                bio: bio, 
                                interests: interests,
                                handicap: handicap,
                                homeCourse: homeCourse,
                                posts: posts)
                            otherUsers.append(otherUserModel)
                            self.friendsList = otherUsers
                        }
                    } else {
                        print(error?.localizedDescription ?? "")
                    }
                } else {
                    print(error?.localizedDescription ?? "")
                }
            }
        }
    }
    
    @MainActor
    func fetchAllOtherUsersFromFirebase() {
        let database  = Firestore.firestore()
        let usersRef = database.collection("Users")
        usersRef.getDocuments { (documents, error) in
            if let documents = documents {
                var otherUsers = [OtherUser]()
                for document in documents.documents {
                        let data = document.data()
                        if let firstName = data["firstName"] as? String,
                        let lastName = data["lastName"] as? String {
                         let profilePic = data["profilePic"] as? String
                         let bio = data["bio"] as? String ?? ""
                         let interests = data["interests"] as? String ?? ""
                         let handicap = data["handicap"] as? Int ?? 0
                         let homeCourse = data["homeCourse"] as? String ?? ""
                         let posts = data["posts"] as? [String] ?? []
                         if profilePic != nil {
                             self.fetchPhotoData(photoId: profilePic ?? "") { fetchedPhoto in
                                 let otherUserModel = OtherUser(
                                     id: document.documentID,
                                     firstName: firstName,
                                     profilePicData: fetchedPhoto,
                                     lastName: lastName,
                                     bio: bio,
                                     interests: interests,
                                     handicap: handicap,
                                     homeCourse: homeCourse,
                                     posts: posts)
                                 if otherUserModel.id != Auth.auth().currentUser?.uid {
                                     otherUsers.append(otherUserModel)
                                 }
                                 self.otherUsers = otherUsers
                             }
                         } else {
                             let otherUserModel = OtherUser(
                                 id: document.documentID,
                                 firstName: firstName,
                                 lastName: lastName,
                                 bio: bio,
                                 interests: interests,
                                 handicap: handicap,
                                 homeCourse: homeCourse,
                                 posts: posts)
                             if otherUserModel.id != Auth.auth().currentUser?.uid {
                                 otherUsers.append(otherUserModel)
                             }
                             self.otherUsers = otherUsers
                         }
                     }
                }
            } else {
                print(error?.localizedDescription ?? "")
            }
        }
    }

    func registerUserWithFirebase(user: User, password: String, profilePic: String?, completion: @escaping (Error?) -> Void) {
        Auth.auth().createUser(withEmail: user.email, password: password) { result, error in
            if let error = error {
                completion(error)
                return
            }
            guard let uid = result?.user.uid else {
                completion(NSError(domain: "AppDomain", code: 0, userInfo: [NSLocalizedDescriptionKey: "User ID not available"]))
                return
            }
            self.createFirestoreUserDocument(uid: uid, user: user, profilePic: profilePic, completion: completion)
        }
    }
    
    func createFirestoreUserDocument(uid: String, user: User, profilePic: String?, completion: @escaping (Error?) -> Void) {
        let database = Firestore.firestore()
        let usersCollection = database.collection("Users")
        
        var userData: [String: Any] = [
            "email": user.email,
            "firstName": user.firstName,
            "lastName": user.lastName
        ]
        
        // Add optional fields if provided
        if let profilePic = profilePic {
            userData["profilePic"] = profilePic
        }
        if let bio = user.bio {
            userData["bio"] = bio
        }
        if let interests = user.interests {
            userData["interests"] = interests
        }
        if let handicap = user.handicap {
            userData["handicap"] = handicap
        }
        if let homeCourse = user.homeCourse {
            userData["homeCourse"] = homeCourse
        }
        if let fcmToken = Messaging.messaging().fcmToken {
            userData["fcmToken"] = fcmToken
        }
        usersCollection.document(uid).setData(userData) { error in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    func updateFcmToken() async {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            return
        }
        
        guard let token = Messaging.messaging().fcmToken else {
            return
        }
        
        let database = Firestore.firestore()
        let userDoc = database.collection("Users").document(currentUserID)
        
        await withCheckedContinuation { continuation in
            userDoc.updateData(["fcmToken": token]) { _ in
                continuation.resume(returning: ())
            }
        }
    }
    
    func uploadPhoto(uiImage: UIImage ) {
        // make sure that the selected image is not nil
        guard profileImage != nil else {
            print("profile image is nil")
            return
        }
        // create the storage reference
        let storageRef = Storage.storage().reference()
        
        // turn our image into data
        let imageData = uiImage.jpegData(compressionQuality: 0.3)
        
        print("image data \(String(describing: imageData))")
        
        guard imageData != nil else {
            return
        }
        
        // specify the file path and name
        let fileRef = storageRef.child("images/\(UUID().uuidString).jpg")
        
        // upload that data
        let _ = fileRef.putData(imageData!, metadata: nil) { metadata, error in
            if error == nil && metadata != nil {
                // save the reference to the file in firestore db
            }
        }
    }
}

extension AuthViewModel {
    enum TransferError: Error {
        case importFailed
    }

    struct ProfileImage: Transferable {
        let image: Image
        static var transferRepresentation: some TransferRepresentation {
            DataRepresentation(importedContentType: .image) { data in
#if canImport(AppKit)
                guard let nsImage = NSImage(data: data) else {
                    throw TransferError.importFailed
                }
                let image = Image(nsImage: nsImage)
                return ProfileImage(image: image)
#elseif canImport(UIKit)
                guard let uiImage = UIImage(data: data) else {
                    throw TransferError.importFailed
                }
                let image = Image(uiImage: uiImage)
                return ProfileImage(image: image)
#else
                throw TransferError.importFailed
#endif
            }
        }
    }
    
    private func loadTransferable(from imageSelection: PhotosPickerItem) -> Progress {
        return imageSelection.loadTransferable(type: ProfileImage.self) { result in
            DispatchQueue.main.async {
                guard imageSelection == self.imageSelection else {
                    print("Failed to get the selected item.")
                    return
                }
                switch result {
                case .success(let profileImage?):
                    self.imageState = .success(profileImage.image)
                case .success(nil):
                    self.imageState = .empty
                case .failure(let error):
                    self.imageState = .failure(error)
                }
            }
        }
    }
    
    @MainActor
    func fetchPhotoData(photoId: String, completion: @escaping (Data?) -> Void) {
        let photoRef = Storage.storage().reference().child("\(photoId)")
        photoRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
            if error != nil {
                completion(nil)
            } else {
                completion(data)
            }
        }
    }
}

extension AuthViewModel {
    @MainActor
    func fetchAllPostsInUserObject(postIds: [String]) async {
        userPosts = []
        for postId in postIds {
            fetchPostFromFirebase(postId: postId) { fetchedPost in
                print(fetchedPost ?? "no fetched post")
                if let userPost = fetchedPost {
                    self.userPosts.append(userPost)
                }
            }
        }
    }
    
    @MainActor
    func fetchPostFromFirebase(postId: String) async -> Post? {
        await withCheckedContinuation { continuation in
            fetchPostFromFirebase(postId: postId) { post in
                    continuation.resume(returning: post)
            }
        }
    }
    
    @MainActor
    func fetchPostFromFirebase(postId: String, completion: @escaping (Post?) -> Void) {
        guard Auth.auth().currentUser != nil else {
            completion(nil)
            return
        }

        let database = Firestore.firestore()
        let postRef = database.collection("Posts").document(postId)

        postRef.getDocument { [weak self] (document, error) in
            if let document = document, document.exists {
                do {
                    var post = try document.data(as: Post.self)
                    post.id = document.documentID

                    // Check for an image reference
                    if let imageRef = post.imageRef {
                        self?.fetchPhotoData(photoId: imageRef) { imageData in
                            post.imageData = imageData
                            self?.post = post
                            completion(post)
                        }
                    } else {
                        self?.post = post
                        completion(post)
                    }
                } catch {
                    print("Error decoding document:", error.localizedDescription)
                    completion(nil)
                }
            } else {
                print(error?.localizedDescription ?? "Document does not exist")
                completion(nil)
            }
        }
    }
    
    func addPost(text: String, imageRef: String?, completion: @escaping (Error?) -> Void) {
        let database = Firestore.firestore()
        var newPost: [String: Any] = [:]
        
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("Current user not found")
            return
        }
        
        if imageRef != nil {
            newPost = [
                "text": text,
                "timeStamp": Date.now,
                "user": currentUserID,
                "imageRef": imageRef as Any
            ]
        } else {
            newPost = [
                "text": text,
                "timeStamp": Date.now,
                "user": currentUserID
            ]
        }
        
        let postRef = database.collection("Posts")
        let userRef = database.collection("Users").document(currentUserID)
        
        // Add new post to the "Posts" collection
        let addedPostRef = postRef.addDocument(data: newPost) { error in
            if let error = error {
                completion(error)
            }
        }
        
        // Use the documentID of the added post in the user's document
        let newPostID = addedPostRef.documentID
        userRef.getDocument { userDocument, userError in
            if let userError = userError {
                completion(userError)
            } else if let userDocument = userDocument, userDocument.exists {
                var currentPosts = userDocument["posts"] as? [String] ?? []
                currentPosts.append(newPostID)
                
                userRef.updateData(["posts": currentPosts]) { updateError in
                    completion(updateError)
                }
            }
        }
    }
    
    func fetchAllPostsFromFirebase(completion: @escaping ([Post]) -> Void) {
        Firestore.firestore().collection("Posts").getDocuments { [weak self] (snapshot, error) in
            guard let snapshot = snapshot, error == nil else {
                print("Error fetching posts:", error?.localizedDescription ?? "Unknown error")
                completion([])
                return
            }

            let group = DispatchGroup()
            var tempPosts: [Post] = []

            for document in snapshot.documents {
                group.enter()
                do {
                    var post = try document.data(as: Post.self)
                    post.id = document.documentID

                    if let imageRef = post.imageRef {
                        Task {
                            await self?.fetchPhotoData(photoId: imageRef) { data in
                                post.imageData = data
                                tempPosts.append(post)
                                group.leave()
                            }
                        }
                       
                    } else {
                        tempPosts.append(post)
                        group.leave()
                    }
                } catch {
                    print("Error decoding document:", error.localizedDescription)
                    group.leave()
                }
            }

            group.notify(queue: .main) {
                self?.posts = tempPosts.sorted(by: { $0.timeStamp > $1.timeStamp })
                print("Fetched posts successfully")
                completion(tempPosts)
            }
        }
    }
}

extension AuthViewModel {
    func updateNotificationToRead(notificationId: String) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let userRef = Firestore.firestore().collection("Users").document(uid)

        userRef.getDocument { (document, error) in
            guard let document = document, document.exists,
                  var notifications = document.data()?["notifications"] as? [[String: Any]] else {
                print("Document does not exist or notifications field is missing")
                return
            }

            // Step 2: Find the notification by ID and update hasBeenRead
            for index in 0..<notifications.count {
                if notifications[index]["id"] as? String == notificationId {
                    notifications[index]["hasBeenRead"] = true
                    self.user?.notifications?[index].hasBeenRead = true
                    break
                }
            }

            // Step 3: Write the updated array back to Firestore
            userRef.updateData([
                "notifications": notifications
            ]) { error in
                if let error = error {
                    print("Error updating notification: \(error)")
                } else {
                    print("Notification updated successfully.")
                }
            }
        }
    }

    
    func addComment(postId: String, text: String, postOwner: String) {
        let postRef = Firestore.firestore().collection("Posts").document(postId)
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let commentData: [String: Any] = [
            "text": text,
            "timeStamp": Date.now,
            "userCommenting": uid
        ]
        
        let notificationData: [String: Any] = [
            "id": UUID().uuidString,
            "hasBeenRead": false,
            "text": text,
            "timeStamp": Date.now,
            "userCommenting": uid,
            "postId": postId
        ]
        
        let notificationRef = Firestore.firestore().collection("Users").document(postOwner)
        if uid != postOwner {
            notificationRef.updateData([
                "notifications": FieldValue.arrayUnion([notificationData])
            ]) { error in
                if let error = error {
                    print("Error adding notification: \(error.localizedDescription)")
                } else {
                    print("notification added successfully")
                }
            }
        }
       
        postRef.updateData([
            "comments": FieldValue.arrayUnion([commentData])
        ]) { error in
            if let error = error {
                print("Error adding comment: \(error.localizedDescription)")
            } else {
                print("Comment added successfully")
            }
        }
    }

    func addUserIdToLikes(postId: String, completion: @escaping (Post?) -> Void) {
        let postRef = Firestore.firestore().collection("Posts").document(postId)
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(nil)
            return
        }
        postRef.updateData([
            "likes": FieldValue.arrayUnion([uid])
        ]) { error in
            if let error = error {
                print("Error adding user ID to likes array: \(error.localizedDescription)")
                completion(nil)
            } else {
                print("User ID added to likes array successfully.")
                completion(nil)
            }
        }
    }
    
    func removeUserIdFromLikes(postId: String, completion: @escaping (Post?) -> Void) {
        let postRef = Firestore.firestore().collection("Posts").document(postId)
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(nil)
            return
        }
        
        postRef.updateData([
            "likes": FieldValue.arrayRemove([uid])
        ]) { error in
            if let error = error {
                completion(nil)
                
                print("Error removing user ID from likes array: \(error.localizedDescription)")
            } else {
                completion(nil)
                
                print("User ID removed from likes array successfully.")
                
            }
        }
    }
}
