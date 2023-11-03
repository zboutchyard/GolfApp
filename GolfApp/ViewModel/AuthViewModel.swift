//
//  AuthViewModel.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 11/4/23.
//

import Foundation
import FirebaseDatabaseInternal
import FirebaseAuth
import SwiftUI
import PhotosUI
import FirebaseStorage

class AuthViewModel: ObservableObject {  
    @Published var photo: UIImage?
    enum ImageState {
        case empty
        case loading(Progress)
        case success(Image)
        case failure(Error)
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
        let ref = Database.database().reference().child("Users").child(Auth.auth().currentUser?.uid ?? "")

        ref.observeSingleEvent(of: .value) { snapshot, error  in
            if let userData = snapshot.value as? [String: Any],
               let firstName = userData["firstName"] as? String,
               let lastName = userData["lastName"] as? String,
               let email = userData["email"] as? String {
                let userModel = User(firstName: firstName, lastName: lastName, email: email)
                completion(userModel)
            } else {
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
        let database = Database.database().reference()
        let usersRef = database.child("Users").child(Auth.auth().currentUser?.uid ?? "")
        
        
        let userData: [String: Any] = [
                "email": email,
                "firstName": firstName,
                "lastName": lastName
            ]
        usersRef.setValue(userData){ (error, _) in
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
