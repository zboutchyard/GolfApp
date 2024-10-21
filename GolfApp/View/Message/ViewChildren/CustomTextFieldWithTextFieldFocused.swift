//
//  CustomTextField.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 10/16/24.
//

import SwiftUI

 struct CustomTextFieldWithTextFieldFocused: View {
        var placeholder: Text
        @Binding var text: String
        var editingChanged: (Bool) -> Void = { _ in }
        var commit: () -> Void = {}
        @FocusState var isTextFieldFocused: Bool
        
        var body: some View {
            ZStack(alignment: .leading) {
                if text.isEmpty {
                    placeholder
                        .opacity(0.5)
                }
                TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit)
                    .focused($isTextFieldFocused)
            }
        }
    }
