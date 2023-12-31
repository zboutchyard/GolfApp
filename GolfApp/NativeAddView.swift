import SwiftUI
import GoogleMobileAds

struct NativeAdView: UIViewRepresentable {
    @Binding var headline: String
    @Binding var body: String
    @Binding var callToAction: String
    @Binding var image: UIImage?

    func makeUIView(context: Context) -> GADNativeAdView {
        // Create and configure GADNativeAdView
        let view = GADNativeAdView()
        // Additional configuration as needed
        return view
    }

    func updateUIView(_ uiView: GADNativeAdView, context: Context) {
        // Update the view when ad data changes
    }

    class Coordinator: NSObject, GADNativeAdLoaderDelegate {
        var parent: NativeAdView

        init(parent: NativeAdView) {
            self.parent = parent
        }

        func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
            // Handle ad loading success
            parent.headline = nativeAd.headline ?? ""
            parent.body = nativeAd.body ?? ""
            parent.callToAction = nativeAd.callToAction ?? ""
            parent.image = nativeAd.images?.first?.image
        }

        func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
            // Handle ad loading failure
            print("Ad failed to load with error: \(error.localizedDescription)")
        }

        // Implement other required delegate methods if any
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
}
