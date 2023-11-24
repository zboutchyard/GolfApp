//
//  HomeView.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 11/4/23.
//

import SwiftUI

struct HomeView: View {
    @State private var postSubmissionText: String = ""
    var body: some View {
        NavigationStack {
            ScrollView {
                HStack {
                    HStack {
                        Image(systemName: "person.fill")
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(width: 50, height: 50)
                            .background {
                                Circle().fill(Color("Gray"))
                            }
                        TextField("", text: $postSubmissionText, prompt: Text("write something..."))
                    } .frame(maxWidth: .infinity, alignment: .leading)
                        .padding([.top, .leading, .bottom])
                    HStack {
                        Image(systemName: "photo.on.rectangle.angled")
                            .padding(.trailing)
                    }
                   
                }
                .background(.white)
                Spacer().frame(height: 13)
                Divider()
                Spacer().frame(height: 13)

                VStack {
                    PostView()
                }
            }
            .frame(maxHeight: .infinity)
            .background(Color("Gray"))
        }
       
    }
}

#Preview {
    HomeView()
}
