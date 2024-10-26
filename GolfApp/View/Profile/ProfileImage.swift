//
//  ProfileImage.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 11/5/23.
//

import SwiftUI
import PhotosUI

struct ProfileImage: View {
    let imageState: AuthViewModel.ImageState
    
    var body: some View {
        switch imageState {
        case .success(let image):
            image.resizable()
        case .loading:
            ProgressView()
        case .empty:
            Image(systemName: "person.fill")
                .font(.system(size: 120))
                .foregroundColor(.white)
        case .failure:
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 120))
                .foregroundColor(.white)
        }
    }
}

struct CircularProfileImage: View {
    let imageState: AuthViewModel.ImageState
    
    var body: some View {
        ProfileImage(imageState: imageState)
            .scaledToFill()
            .clipShape(Circle())
            .frame(width: 300, height: 300)
            .background {
                Circle().fill(
                    Color.gray
                )
            }
    }
}

extension AuthViewModel.ImageState: Equatable {
    static func == (lhs: AuthViewModel.ImageState, rhs: AuthViewModel.ImageState) -> Bool {
        switch (lhs, rhs) {
        case (.empty, .empty):
            return true
        case (.loading, .loading):
            return true
        case (.success(let leftImage), .success(let rightImage)):
            // Compare images or any other relevant data
            return leftImage == rightImage
        case (.failure, .failure):
            return true
        default:
            return false
        }
    }
}

struct EditableCircularProfileImage: View {
    @StateObject var viewModel: AuthViewModel = AuthViewModel()
    var onDataUpdate: ((Data?) -> Void)?
    @Binding var data: Data?
    
    var body: some View {
        CircularProfileImage(imageState: viewModel.imageState)
            .overlay(alignment: .bottomTrailing) {
                PhotosPicker(selection: $viewModel.imageSelection,
                             matching: .images,
                             photoLibrary: .shared()) {
                    Image(systemName: "pencil.circle.fill")
                        .symbolRenderingMode(.multicolor)
                        .font(.system(size: 75))
                        .foregroundColor(.accentColor)
                }
            }.onChange(of: viewModel.imageSelection) { _, _ in
                guard let item = viewModel.imageSelection else {
                    return
                }
                item.loadTransferable(type: Data.self) { result in
                    switch result {
                    case .success(let data):
                        if let data = data {
                            self.data = data
                        }
                    case .failure(let failure):
                        print("Error: \(failure.localizedDescription)")
                    }
                }
            }
            .buttonStyle(.borderless)
    }
}

private func uiImage(from image: Image) -> UIImage? {
    let controller = UIHostingController(rootView: image)
    
    // Safely unwrap the view and avoid force unwrapping
    guard let view = controller.view else {
        return nil
    }
    
    let renderer = UIGraphicsImageRenderer(bounds: view.bounds)
    let uiImage = renderer.image { _ in
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
    }
    
    guard uiImage.size.width > 0 && uiImage.size.height > 0 else {
        return nil
    }
    
    print("Converted UIImage: \(uiImage)")
    return uiImage
}
