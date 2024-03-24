import GoogleMobileAds
import UIKit

class GoogleAdViewController: UIViewController, GADVideoControllerDelegate, GADAdLoaderDelegate, GADNativeAdLoaderDelegate, GADNativeAdDelegate {

    var iconView: UIImageView!
    var headlineLabel: UILabel!
    var bodyLabel: UILabel!
    var callToActionButton: UIButton!
    var priceLabel: UILabel!
    var storeLabel: UILabel!
    var mediaView: GADMediaView!
    var nativeAdPlaceholder: UIView!
    var heightConstraint: NSLayoutConstraint?
    var adLoader: GADAdLoader!
    var nativeAdView: GADNativeAdView!
    let adUnitID = "ca-app-pub-6684582127321393/3737224559"
    var sponsoredLabel: UILabel!
    
    var onHeightChange: ((CGFloat) -> Void)?


    override func viewDidLoad() {
        super.viewDidLoad()
        setupNativeAdPlaceholder()
        setupIconView()
        setupHeadlineLabel()
        setupBodyLabel()
        setupSponsoredLabel()
        setupMediaView()
        setupCallToActionButton()
        setupPriceLabel()
        setupStoreLabel()
        loadNativeAd()
    }

    func setupNativeAdPlaceholder() {
        nativeAdPlaceholder = UIView()
        nativeAdPlaceholder.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nativeAdPlaceholder)

        NSLayoutConstraint.activate([
            nativeAdPlaceholder.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nativeAdPlaceholder.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nativeAdPlaceholder.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            nativeAdPlaceholder.heightAnchor.constraint(equalToConstant: 400)
        ])
        nativeAdPlaceholder.clipsToBounds = true
    }

    func setupIconView(with iconImage: UIImage? = nil) {
        iconView = UIImageView()
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.contentMode = .scaleAspectFill
        iconView.clipsToBounds = true
        iconView.layer.cornerRadius = 25 // Make it circular
        nativeAdPlaceholder.addSubview(iconView)

        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: nativeAdPlaceholder.leadingAnchor, constant: 0),
            iconView.topAnchor.constraint(equalTo: nativeAdPlaceholder.topAnchor, constant: 0),
            iconView.widthAnchor.constraint(equalToConstant: 50),
            iconView.heightAnchor.constraint(equalToConstant: 50)
        ])

        if let iconImage = iconImage {
            iconView.image = iconImage
        } else {
            // Create a default icon view
            let defaultIconLabel = UILabel()
            defaultIconLabel.text = "AD"
            defaultIconLabel.textColor = .white
            defaultIconLabel.font = UIFont.boldSystemFont(ofSize: 14)
            defaultIconLabel.textAlignment = .center
            defaultIconLabel.translatesAutoresizingMaskIntoConstraints = false
            iconView.addSubview(defaultIconLabel)

            iconView.backgroundColor = .gray

            NSLayoutConstraint.activate([
                defaultIconLabel.centerXAnchor.constraint(equalTo: iconView.centerXAnchor),
                defaultIconLabel.centerYAnchor.constraint(equalTo: iconView.centerYAnchor),
                defaultIconLabel.widthAnchor.constraint(equalTo: iconView.widthAnchor),
                defaultIconLabel.heightAnchor.constraint(equalTo: iconView.heightAnchor)
            ])
        }
        iconView.clipsToBounds = true
    }


    func handleIconForNativeAd(_ nativeAd: GADNativeAd) {
        let iconImage = nativeAd.icon?.image
        setupIconView(with: iconImage)
    }



    func setupHeadlineLabel() {
        headlineLabel = UILabel()
        headlineLabel.translatesAutoresizingMaskIntoConstraints = false
        nativeAdPlaceholder.addSubview(headlineLabel)

        NSLayoutConstraint.activate([
            headlineLabel.topAnchor.constraint(equalTo: nativeAdPlaceholder.topAnchor, constant: 8),
            headlineLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 8),
            headlineLabel.trailingAnchor.constraint(equalTo: nativeAdPlaceholder.trailingAnchor, constant: -15)
        ])
        headlineLabel.clipsToBounds = true
    }
    
    func setupSponsoredLabel() {
        sponsoredLabel = UILabel()
        sponsoredLabel.translatesAutoresizingMaskIntoConstraints = false
        sponsoredLabel.text = "Sponsored"
        sponsoredLabel.font = UIFont.systemFont(ofSize: 12) // Adjust font size as needed
        sponsoredLabel.textColor = .gray // Set text color as needed
        nativeAdPlaceholder.addSubview(sponsoredLabel)

        NSLayoutConstraint.activate([
            sponsoredLabel.topAnchor.constraint(equalTo: headlineLabel.bottomAnchor, constant: 5), // Adjust the constant for spacing
            sponsoredLabel.leadingAnchor.constraint(equalTo: headlineLabel.leadingAnchor),
            sponsoredLabel.trailingAnchor.constraint(equalTo: headlineLabel.trailingAnchor)
        ])
        sponsoredLabel.clipsToBounds = true
    }


    func setupBodyLabel() {
        bodyLabel = UILabel()
        bodyLabel.numberOfLines = 0
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        nativeAdPlaceholder.addSubview(bodyLabel)

        NSLayoutConstraint.activate([
            bodyLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 8),
            bodyLabel.leadingAnchor.constraint(equalTo: nativeAdPlaceholder.leadingAnchor, constant: 15),
            bodyLabel.trailingAnchor.constraint(equalTo: nativeAdPlaceholder.trailingAnchor, constant: -15)
        ])
        bodyLabel.clipsToBounds = true
    }

    func setupPriceLabel() {
        priceLabel = UILabel()
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        nativeAdPlaceholder.addSubview(priceLabel)

        NSLayoutConstraint.activate([
            priceLabel.leadingAnchor.constraint(equalTo: nativeAdPlaceholder.leadingAnchor, constant: 15),
            priceLabel.bottomAnchor.constraint(equalTo: callToActionButton.topAnchor, constant: -10)
        ])
        priceLabel.clipsToBounds = true
    }

    func setupStoreLabel() {
        storeLabel = UILabel()
        storeLabel.translatesAutoresizingMaskIntoConstraints = false
        nativeAdPlaceholder.addSubview(storeLabel)

        NSLayoutConstraint.activate([
            storeLabel.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor, constant: 10),
            storeLabel.bottomAnchor.constraint(equalTo: callToActionButton.topAnchor, constant: -10)
        ])
        storeLabel.clipsToBounds = true
    }

    func setupMediaView() {
        mediaView = GADMediaView()
        mediaView.translatesAutoresizingMaskIntoConstraints = false
        nativeAdPlaceholder.addSubview(mediaView)

        NSLayoutConstraint.activate([
            mediaView.leadingAnchor.constraint(equalTo: nativeAdPlaceholder.leadingAnchor),
            mediaView.trailingAnchor.constraint(equalTo: nativeAdPlaceholder.trailingAnchor),
            mediaView.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor, constant: 10), // Adjust constant for desired spacing
            mediaView.heightAnchor.constraint(equalToConstant: 225) // Assuming a 16:9 aspect ratio
        ])
        mediaView.clipsToBounds = true
    }
    
    func setupCallToActionButton() {
        callToActionButton = UIButton(type: .system)
        callToActionButton.translatesAutoresizingMaskIntoConstraints = false
        nativeAdPlaceholder.addSubview(callToActionButton)

        NSLayoutConstraint.activate([
            callToActionButton.trailingAnchor.constraint(equalTo: nativeAdPlaceholder.trailingAnchor, constant: -10),
            callToActionButton.topAnchor.constraint(equalTo: mediaView.bottomAnchor, constant: 4), // Set top anchor relative to mediaView's bottom
            callToActionButton.widthAnchor.constraint(equalToConstant: 100),
            callToActionButton.heightAnchor.constraint(equalToConstant:40)
        ])
        callToActionButton.clipsToBounds = true
    }
    
    func loadNativeAd() {
        adLoader = GADAdLoader(adUnitID: adUnitID, rootViewController: self, adTypes: [.native], options: [])
        adLoader.delegate = self
        adLoader.load(GADRequest())
    }

    func updateAdHeight() {
            // Perform layout
            self.view.layoutIfNeeded()

            // Calculate the content height (this is a placeholder, implement your logic)
            let contentHeight = self.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height

            // Notify the height change
            onHeightChange?(contentHeight)
        }

    // GADAdLoaderDelegate
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
        print("AdLoader failed with error: \(error.localizedDescription)")
    }

    // GADNativeAdLoaderDelegate
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
        nativeAd.delegate = self

        // Initialize nativeAdView
        nativeAdView = GADNativeAdView()

        // Assign native ad to nativeAdView
        nativeAdView.nativeAd = nativeAd
        handleIconForNativeAd(nativeAd)
        // Set up nativeAdView's components
        nativeAdView.mediaView = mediaView
        nativeAdView.headlineView = headlineLabel
        nativeAdView.bodyView = bodyLabel
        nativeAdView.callToActionView = callToActionButton
        nativeAdView.priceView = priceLabel
        nativeAdView.storeView = storeLabel
        nativeAdView.iconView = iconView // Assign your custom iconView here
        
        self.view.layoutIfNeeded()

        // Set the actual content from the native ad to your views
        headlineLabel.text = nativeAd.headline
        bodyLabel.text = nativeAd.body
        if let iconImage = nativeAd.icon?.image {
            iconView.image = iconImage
        }
        if let callToAction = nativeAd.callToAction {
            callToActionButton.setTitle(callToAction, for: .normal)
        }
        priceLabel.text = nativeAd.price
        storeLabel.text = nativeAd.store

        if nativeAd.mediaContent.hasVideoContent {
                nativeAd.mediaContent.videoController.delegate = self
            }
        // Add nativeAdView to the placeholder
        nativeAdPlaceholder.addSubview(nativeAdView)
        nativeAdView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nativeAdView.leadingAnchor.constraint(equalTo: nativeAdPlaceholder.leadingAnchor),
            nativeAdView.trailingAnchor.constraint(equalTo: nativeAdPlaceholder.trailingAnchor),
            nativeAdView.topAnchor.constraint(equalTo: nativeAdPlaceholder.topAnchor),
            nativeAdView.bottomAnchor.constraint(equalTo: nativeAdPlaceholder.bottomAnchor)
        ])
        updateAdHeight()
        
        nativeAdView.clipsToBounds = true
    }


    // GADNativeAdDelegate
    func nativeAdDidRecordClick(_ nativeAd: GADNativeAd) {
        print("Native ad was clicked.")
    }
    
    func videoControllerDidEndVideoPlayback(_ videoController: GADVideoController) {
        print("Video playback ended")
        loadNativeAd() // Function to load a new native ad


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
