//
//  AdContentView.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 12/28/23.
//

import SwiftUI
import GoogleMobileAds

struct NativeAdViewControllerWrapper: UIViewControllerRepresentable {

    func makeUIViewController(context: Context) -> GoogleAdViewController {
        GoogleAdViewController()
        }

    func updateUIViewController(_ uiViewController: GoogleAdViewController, context: Context) {
        // This is where you could pass additional data to the controller if needed
    }
}

