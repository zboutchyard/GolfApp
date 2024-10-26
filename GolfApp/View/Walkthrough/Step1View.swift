//
//  WalkthroughView.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 11/5/23.
//

import SwiftUI

struct Step1View: View {
    @State var user: User?
    @State var email: String
    @State var password: String
    @State var firstName: String
    @State var lastName: String
    @State var data: Data?
    @State private var isStep1Complete: Bool = false
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    HStack {
                        Button(action: {
                            isStep1Complete = true
                        }, label: {
                            Text("Skip")
                        })
                    }
                    .fontWeight(.semibold)
                    .kerning(1.2)
                    Spacer()
                    EditableCircularProfileImage(data: $data)
                    
                    Text("Let's start by getting an image for your profile.")
                        .fontWeight(.semibold)
                        .kerning(1.2)
                        .multilineTextAlignment(.center)
                        .padding(.top)
                    Spacer(minLength: 100)
                }
            }
            .overlay(
                Button(action: {
                    isStep1Complete = true
                }, label: {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(width: 60, height: 60)
                        .background(Color.blue)
                        .clipShape(Circle())
                        .overlay(
                            ZStack {
                                Circle()
                                    .stroke(Color.black.opacity(0.04), lineWidth: 4)
                                Circle()
                                    .trim(from: 0, to: 0.3)
                                    .stroke(Color.green, lineWidth: 4)
                                    .rotationEffect(.init(degrees: -90))
                            }
                                .padding(-15)
                        )
                }), alignment: .bottom
            )
            .navigationDestination(isPresented: $isStep1Complete) {
                Step2View(email: email,
                          password: password,
                          firstName: firstName,
                          lastName: lastName,
                          data: data)
            }
            
            .padding()
            .navigationBarBackButtonHidden()
        }
    }
}
