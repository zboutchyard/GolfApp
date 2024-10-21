//
//  AdLoaderDelegate.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 10/20/24.
//

import Foundation
import GoogleMobileAds

class AdLoaderDelegate: NSObject, GADNativeAdLoaderDelegate {
    var adReceivedHandler: ((GADNativeAd) -> Void)?
    var didFailToReceiveAd: ((Error) -> Void)?

    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
        adReceivedHandler?(nativeAd)
    }

    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
        didFailToReceiveAd?(error)
    }
}
