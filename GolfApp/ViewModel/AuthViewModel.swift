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

class AuthViewModel: ObservableObject {
    @Published var photo: UIImage?
    @Published var otherUsers: [OtherUser]?
    @Published var friends: [OtherUser]?
    @Published var friend: OtherUser?
    @State var friendId: String?
    @Published var friendsList: [OtherUser]?
    @Published var posts: [Post] = []
    @Published var post: Post?
    @Published var userPosts: [Post] = []
    
    enum ImageState {
        case empty
        case loading(Progress)
        case success(Image)
        case failure(Error)
    }
    
    init() {
        fetchAllOtherUsersFromFirebase() { user in }
    }
    
    
    
    
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
                //instead of adding the photo in 1 register page, we could first create the user within a register page, establish a uid, then proceed to a walkthrugh screen and call uploadPhoto() here when the photo gets updated.
                return ProfileImage(image: image)
#else
                throw TransferError.importFailed
#endif
            }
        }
    }
    
    @Published private(set) var imageState: ImageState = .empty
    @Published var profileImage: ProfileImage? = nil
    
    @Published var imageSelection: PhotosPickerItem? = nil {
        didSet {
            if let imageSelection {
                let progress = loadTransferable(from: imageSelection)
                imageState = .loading(progress)
            } else {
                imageState = .empty
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
    
    
    // ... (other properties and methods)
    
    func fetchUserDataFromFirebase(completion: @escaping (User?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(nil)
            return
        }
        
        let db = Firestore.firestore()
        let usersRef = db.collection("Users").document(uid)
        
        usersRef.getDocument { (document, error) in
            if let document = document, document.exists {
                if let data = document.data(),
                   let firstName = data["firstName"] as? String,
                   let lastName = data["lastName"] as? String,
                   let email = data["email"] as? String
                {
                    // Optional fields with default values
                    let chats = data["chats"] as? [String] ?? []
                    let friendsList = data["friendsList"] as? [String] ?? []
                    let bio = data["bio"] as? String ?? ""
                    let handicap = data["handicap"] as? Int ?? 0
                    let interests = data["interests"] as? String ?? ""
                    let homeCourse = data["homeCourse"] as? String ?? ""
                    let notificationsData = data["notifications"] as? [[String: Any]] ?? []
                    let posts = data["posts"] as? [String] ?? []
                    
                    // Convert notificationsData into an array of Notification objects
                    let notifications = notificationsData.compactMap { notificationData in
                        if let text = notificationData["text"] as? String,
                           let timeStamp = notificationData["timestamp"] as? Timestamp,
                           let userCommenting = notificationData["userCommenting"] as? String
                        {
                            let timeStamp = timeStamp.dateValue()
                            return Notification(text: text, timeStamp: timeStamp, userCommenting: userCommenting)
                        }
                        return nil
                    }
                    
                    let userModel = User(firstName: firstName, lastName: lastName, email: email, chats: chats, friendsList: friendsList, bio: bio, interests: interests, handicap: handicap, homeCourse: homeCourse, posts: posts, notifications: notifications)
                    print("User model created successfully.")
                    completion(userModel)
                } else {
                    print("User data not present or incomplete in Firestore document.")
                    completion(nil)
                }
            } else {
                print("Document doesn't exist in Firestore.")
                completion(nil)
            }
        }
    }
    
    
    
    func fetchOtherUserFromFirebase(id: String, completion: @escaping (OtherUser?) -> Void) {
        let db  = Firestore.firestore()
        let usersRef = db.collection("Users").document(id)
        usersRef.getDocument { [self] (document, error) in
            if let document = document, document.exists {
                if let data = document.data() ?? nil,
                   let firstName = data["firstName"] as? String,
                   let lastName = data["lastName"] as? String {
                    let otherUserModel = OtherUser(id: id, firstName: firstName, lastName: lastName)
                    //                    self.friends?.append(otherUserModel)
                    completion(otherUserModel)
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
    
    func fetchFriendsFromFirebase(ids: [String], completion: @escaping ([OtherUser]?) -> Void) {
        let db = Firestore.firestore()
        var otherUsers = [OtherUser]()
        for id in ids {
            let usersRef = db.collection("Users").document(id)
            usersRef.getDocument { [self] (document, error) in
                if let document = document, document.exists {
                    if let data = document.data() ?? nil,
                       let firstName = data["firstName"] as? String,
                       let lastName = data["lastName"] as? String {
                        let otherUserModel = OtherUser(id: id, firstName: firstName, lastName: lastName)
                        otherUsers.append(otherUserModel)
                        self.friendsList = otherUsers
                        completion(otherUsers)
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
    }
    
    func fetchAllOtherUsersFromFirebase(completion: @escaping ([OtherUser]?) -> Void) {
        let db  = Firestore.firestore()
        let usersRef = db.collection("Users")
        
        usersRef.getDocuments { (documents, error) in
            if let documents = documents {
                var otherUsers = [OtherUser]()
                
                for document in documents.documents {
                    if let data = document.data() ?? nil,
                       let firstName = data["firstName"] as? String,
                       let lastName = data["lastName"] as? String {
                        let otherUserModel = OtherUser(id: document.documentID, firstName: firstName, lastName: lastName)
                        otherUsers.append(otherUserModel)
                    }
                }
                self.otherUsers = otherUsers
                completion(otherUsers)
            } else {
                print(error?.localizedDescription ?? "")
                completion(nil)
            }
        }
    }
    
    func fetchAllPostsInUserObject(postIds: [String]) {
        userPosts = []
        for postId in postIds {
            print("here is postid \(postId)")
            fetchPostFromFirebase(postId: postId) { fetchedPost in
                print(fetchedPost ?? "no fetched post")
                if let userPost = fetchedPost {
                    self.userPosts.append(userPost)
                }
            }
            print(self.userPosts ?? "user posts is nil???")
        }
    }
    
    func fetchPostFromFirebase(postId: String, completion: @escaping (Post?) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(nil)
            return
        }
        
        let db = Firestore.firestore()
        let postRef = db.collection("Posts").document(postId)
        
        postRef.getDocument { (document, error) in
            if let document = document, document.exists {
                do {
                    var documentData = try document.data(as: Post?.self)
                    
                    if var unwrappedDocumentData = documentData {
                        unwrappedDocumentData.id = document.documentID
                        self.post = unwrappedDocumentData
                        completion(unwrappedDocumentData)
                    } else {
                        print("Error decoding document data as Post")
                        completion(nil)
                    }
                } catch {
                    print("Error decoding document:", error.localizedDescription)
                    completion(nil)
                }
            } else {
                print(error?.localizedDescription ?? "")
                completion(nil)
            }
        }
    }
    
    func addComment(postId: String, text: String, userCommenting: String) {
        let postRef = Firestore.firestore().collection("Posts").document(postId)
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let commentData: [String: Any] = [
            "text": text,
            "timeStamp": Date.now,
            "userCommenting": userCommenting
        ]
        
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
    
    
    
    
    func fetchAllPostsFromFirebase() {
        guard let user = Auth.auth().currentUser else {
            return
        }
        
        Firestore.firestore().collection("Posts").getDocuments { (snapshot, error) in
            guard let snapshot = snapshot, error == nil else {
                print("Error fetching posts:", error?.localizedDescription ?? "Unknown error")
                return
            }
            self.posts = snapshot.documents.compactMap { documentSnapshot -> Post? in
                do {
                    var documentData = try documentSnapshot.data(as: Post.self)
                    documentData.id = documentSnapshot.documentID
                    return documentData
                } catch {
                    print("Error decoding document:", error.localizedDescription)
                    return nil
                }
            }
            
            if self.posts.isEmpty {
                print("No valid posts found.")
            } else {
                print("Fetched posts successfully:")
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
    
    func addPost(text: String, completion: @escaping (Error?) -> Void) {
        let db = Firestore.firestore()
        
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("Current user not found")
            return
        }
        
        let newPost: [String: Any] = [
            "text": text,
            "timeStamp": Date.now,
            "user": currentUserID
        ]
        
        let postRef = db.collection("Posts")
        let userRef = db.collection("Users").document(currentUserID)
        
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
    
    
    
    
    
    func registerUserWithFirebase(email: String, password: String, firstName: String, lastName: String, bio: String?, interests: String?, handicap: Int?, homeCourse: String?, completion: @escaping (Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(error)
                return
            }
            
            guard let uid = result?.user.uid else {
                completion(NSError(domain: "AppDomain", code: 0, userInfo: [NSLocalizedDescriptionKey: "User ID not available"]))
                return
            }
            
            self.createFirestoreUserDocument(uid: uid, email: email, firstName: firstName, lastName: lastName, bio: bio, interests: interests, handicap: handicap, homeCourse: homeCourse, completion: completion)
        }
    }
    
    func createFirestoreUserDocument(uid: String, email: String, firstName: String, lastName: String, bio: String?, interests: String?, handicap: Int?, homeCourse: String?, completion: @escaping (Error?) -> Void) {
        let db = Firestore.firestore()
        let usersCollection = db.collection("Users")
        
        var userData: [String: Any] = [
            "email": email,
            "firstName": firstName,
            "lastName": lastName
        ]
        
        // Add optional fields if provided
        if let bio = bio {
            userData["bio"] = bio
        }
        
        if let interests = interests {
            userData["interests"] = interests
        }
        
        if let handicap = handicap {
            userData["handicap"] = handicap
        }
        
        if let homeCourse = homeCourse {
            userData["homeCourse"] = homeCourse
        }
        
        usersCollection.document(uid).setData(userData) { error in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    
    func uploadPhoto(uiImage: UIImage ) {
        //make sure that the selected image is not nil
        guard profileImage != nil else {
            print("profile image is nil")
            return
        }
        //create the storage reference
        let storageRef = Storage.storage().reference()
        
        //turn our image into data
        let imageData = uiImage.jpegData(compressionQuality: 0.8)
        
        print("image data \(String(describing: imageData))")
        
        guard imageData != nil else {
            return
        }
        
        //specify the file path and name
        let fileRef = storageRef.child("images/\(UUID().uuidString).jpg")
        
        //upload that data
        let uploadTask = fileRef.putData(imageData!, metadata: nil) { metadata, error in
            if error == nil && metadata != nil {
                //save the reference to the file in firestore db
            }
        }
        
    }
    
    func setPhoto(uiImage: UIImage) {
        self.photo = uiImage
        print("photo is set")
    }
}
