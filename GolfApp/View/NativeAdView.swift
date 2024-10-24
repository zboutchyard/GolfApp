//
//  NativeAdView.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 10/20/24.
//

import SwiftUI
import GoogleMobileAds

struct NativeAdView: View {
    @StateObject private var nativeViewModel = NativeAdViewModel()

    var body: some View {
       VStack {
         VStack(spacing: 20) {
           NativeAd(nativeViewModel: nativeViewModel)
                 .frame(minHeight: 425)
                 .background(.whiteOrDark)
         }
       }
       .onAppear {
         refreshAd()
       }
     }

     private func refreshAd() {
       nativeViewModel.refreshAd()
     }
}

private struct NativeAd: UIViewRepresentable {
    typealias UIViewType = GADNativeAdView
    
    // Observer to update the UIView when the native ad value changes.
    @ObservedObject var nativeViewModel: NativeAdViewModel
    
    func makeUIView(context: Context) -> GADNativeAdView {
        return Bundle.main.loadNibNamed(
            "NativeAdView",
            owner: nil,
            options: nil)?.first as! GADNativeAdView
        // swiftlint:disable:previous force_cast
    }
    
    func updateUIView(_ nativeAdView: GADNativeAdView, context: Context) {
        guard let nativeAd = nativeViewModel.nativeAd else { return }
        
        // Each UI property is configurable using your native ad.
        (nativeAdView.headlineView as? UILabel)?.text = nativeAd.headline
        
        nativeAdView.mediaView?.mediaContent = nativeAd.mediaContent
        
        (nativeAdView.bodyView as? UILabel)?.text = nativeAd.body
        
        if let iconImageView = nativeAdView.iconView as? UIImageView {
                iconImageView.image = nativeAd.icon?.image
                
                // Make the icon circular
                let iconSize = min(iconImageView.frame.size.width, iconImageView.frame.size.height)
                iconImageView.layer.cornerRadius = iconSize / 2
                iconImageView.clipsToBounds = true
        }
        
        (nativeAdView.starRatingView as? UIImageView)?.image = imageOfStars(from: nativeAd.starRating)
        
        (nativeAdView.storeView as? UILabel)?.text = nativeAd.store
        
        (nativeAdView.priceView as? UILabel)?.text = nativeAd.price
        
        (nativeAdView.advertiserView as? UILabel)?.text = "Sponsored"
        
        (nativeAdView.callToActionView as? UIButton)?.setTitle(nativeAd.callToAction, for: .normal)
        
        // For the SDK to process touch events properly, user interaction should be disabled.
        nativeAdView.callToActionView?.isUserInteractionEnabled = false
        
        // Associate the native ad view with the native ad object. This is required to make the ad
        // clickable.
        // Note: this should always be done after populating the ad views.
        nativeAdView.nativeAd = nativeAd
        nativeAdView.backgroundColor = .whiteOrDark
    }
    // [END create_native_ad_view]
    
    private func imageOfStars(from starRating: NSDecimalNumber?) -> UIImage? {
        guard let rating = starRating?.doubleValue else {
            return nil
        }
        if rating >= 5 {
            return UIImage(named: "stars_5")
        } else if rating >= 4.5 {
            return UIImage(named: "stars_4_5")
        } else if rating >= 4 {
            return UIImage(named: "stars_4")
        } else if rating >= 3.5 {
            return UIImage(named: "stars_3_5")
        } else {
            return nil
        }
    }
    
}

class NativeAdViewModel: NSObject, ObservableObject, GADNativeAdLoaderDelegate, GADVideoControllerDelegate, GADAdLoaderDelegate {
  @Published var nativeAd: GADNativeAd?
  private var adLoader: GADAdLoader!

  func refreshAd() {
    adLoader = GADAdLoader(
      adUnitID: "ca-app-pub-3940256099942544/3986624511",
      // The UIViewController parameter is optional.
      rootViewController: nil,
      adTypes: [.native], options: nil)
    adLoader.delegate = self
    adLoader.load(GADRequest())
  }

  func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
    // Native ad data changes are published to its subscribers.
    self.nativeAd = nativeAd
    if nativeAd.mediaContent.hasVideoContent {
        nativeAd.mediaContent.videoController.delegate = self
    }
    nativeAd.delegate = self
  }

  func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
    print("\(adLoader) failed with error: \(error.localizedDescription)")
  }
}
// [END create_view_model]

// MARK: - GADNativeAdDelegate implementation
extension NativeAdViewModel: GADNativeAdDelegate {
    // GADNativeAdDelegate
       func nativeAdDidRecordClick(_ nativeAd: GADNativeAd) {
           print("Native ad was clicked.")
       }
       
       func videoControllerDidEndVideoPlayback(_ videoController: GADVideoController) {
           print("Video playback ended")
           refreshAd()
       }

       func nativeAdDidRecordImpression(_ nativeAd: GADNativeAd) {
           print("Native ad impression recorded.")
       }

       func nativeAdWillPresentScreen(_ nativeAd: GADNativeAd) {
           print("Native ad will present screen.")
       }

       func nativeAdWillDismissScreen(_ nativeAd: GADNativeAd) {
           print("Native ad will dismiss screen.")
       }

       func nativeAdDidDismissScreen(_ nativeAd: GADNativeAd) {
           print("Native ad did dismiss screen.")
       }

       func nativeAdWillLeaveApplication(_ nativeAd: GADNativeAd) {
           print("Native ad will leave application.")
       }
}
