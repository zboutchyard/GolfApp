//
//  NewPostView.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 11/28/23.
//

import SwiftUI
import FirebaseStorage
import AlertToast

struct NewPostView: View {
    @State var postText: String = ""
    @ObservedObject var authViewModel: AuthViewModel
    @State var user: User
    @State private var showingImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var inputImage: UIImage?
    @State var data: Data?
    @Environment(\.presentationMode) var presentationMode
    var onPostSubmitted: (() -> Void)?
    let storageReference = Storage.storage().reference().child("\(UUID().uuidString)")
    
    var body: some View {
        ScrollView {
            HStack {
                Image(systemName: "person.fill")
                    .scaledToFill()
                    .foregroundStyle(.whiteOrDark)
                    .clipShape(Circle())
                    .frame(width: 50, height: 50)
                    .background {
                        Circle().fill(Color("AppGray"))
                    }
                Text("\(user.firstName) \(user.lastName)")
                    .fontWeight(.semibold)
                    .kerning(1.2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Button(action: {
                    Task {
                        if let data = data {
                            onPostSubmitted?()
                            // Upload the image to Firebase Storage
                            storageReference.putData(data, metadata: nil) { metadata, error in
                                guard metadata != nil else {
                                    // Handle the error if image upload fails
                                    print("Error uploading image: \(error?.localizedDescription ?? "Unknown error")")
                                    return
                                }

                                // After successful upload, add the post referencing the image
                                authViewModel.addPost(text: postText, imageRef: storageReference.name) { _ in
                                    presentationMode.wrappedValue.dismiss()
                                }
                            }
                        } else {
                                authViewModel.addPost(text: postText, imageRef: nil) { _ in
                                    onPostSubmitted?()
                                    presentationMode.wrappedValue.dismiss()
                                }
                           
                        }
                    }
                   
                }, label: {
                    Text("Post")
                })                       
                .buttonStyle(.borderedProminent)
                .disabled((data == nil) && postText.isEmpty)
                
            }
            .padding()
            Button(action: {
                showingImagePicker = true
            }, label: {
                HStack {
                    Image(systemName: "photo.on.rectangle.angled")
                        .resizable()
                        .padding(.trailing)
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
            })
            .buttonStyle(.plain)
            
            TextField("tell me something..", text: $postText, axis: .vertical)
                .lineLimit(12)
            if let selectedImage = self.selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFill()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.top)
            }
            
        }
        .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
            ImagePicker(image: $inputImage)
        }
    }
    func loadImage() {
        guard let inputImage = inputImage else { return }
        selectedImage = inputImage
        data = selectedImage?.jpegData(compressionQuality: 0.2)
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
