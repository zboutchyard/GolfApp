//
//  BackButtonToolbarModifier.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 10/25/24.
//

import SwiftUI

struct BackButtonToolbarModifier: ViewModifier {
    @Environment(\.dismiss) private var dismiss
    var title: String?
    var useCloseIcon: Bool = false

    func body(content: Content) -> some View {
        content.toolbar {
            ToolbarItem(id: "search", placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    HStack {
                        if useCloseIcon {
                            Image(systemName: "xmark")
                        } else {
                            Image(systemName: "chevron.left")
                        }
                    }
                    .tint(Color.heading)
                }
            }
            if let title = title {
                ToolbarItem(placement: .principal) {
                    Text(title)
                        .font(.headline)
                }
               
            }
        }
    }
}

extension View {
    func backButtonToolbar(title: String? = nil, useCloseIcon: Bool = false) -> some View {
        self.modifier(BackButtonToolbarModifier(title: title, useCloseIcon: useCloseIcon))
    }
}
