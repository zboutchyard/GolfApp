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
                let viewModel: AuthViewModel = AuthViewModel()
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
                   let chats = data["chats"] as? [String],
                   let friendsList = data["friendsList"] as? [String],
                   let email = data["email"] as? String {
                    let userModel = User(firstName: firstName, lastName: lastName, email: email, chats: chats, friendsList: friendsList)
                    completion(userModel)
                } else {
                    completion(nil)
                }
            } else {
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
                    self.otherUsers = otherUsers
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
    
    
    func registerUserWithFirebase(email: String, password: String, firstName: String, lastName: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if error != nil {
                print(error?.localizedDescription as Any)
            } else {
                self.createFirestoreUserDocument(email: email, firstName: firstName, lastName: lastName, completion: completion)
            }
        }
    }
    
    func createFirestoreUserDocument(email: String, firstName: String, lastName: String, completion: @escaping (Error?) -> Void) {
        // Get the current user's UID
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(NSError(domain: "AppDomain", code: 0, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"]))
            return
        }
        
        let db = Firestore.firestore()
        let usersCollection = db.collection("Users")
        
        // Define the user document data
        let userData: [String: Any] = [
            "email": email,
            "firstName": firstName,
            "lastName": lastName
        ]
        
        // Create a new document with the user's UID as the document name
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
