//
//  MoreOptionsSheetView.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 10/29/24.
//

import SwiftUI

struct MoreOptionsSheetView: View {
    @Environment(\.dismiss) var dismiss
        @ObservedObject var authViewModel: AuthViewModel
        @Binding var post: Post
    
    // TODO: handle navigation to post detail view
    var body: some View {
        Form {
            Section(header: Text("More options")) {
                Button {
                    authViewModel.deletePost(currentPost: post)
                    dismiss()
                } label: {
                    Text("Remove Post")
                }
                .buttonStyle(.plain)
                Button {
                    // TODO: shouldNavigateToPostDetailView = true
                } label: {
                    Text("View Post")
                }
                .buttonStyle(.plain)
                
                Button {
                    dismiss()
                } label: {
                    Text("Cancel")
                }
                .buttonStyle(.plain)
            }
        }
    }
}
