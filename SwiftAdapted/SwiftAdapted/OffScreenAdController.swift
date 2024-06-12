//
//  OffScreenAdController.swift
//  SwiftAdapted
//
//  Created by Brett Clifton on 1/8/24.
//

import Foundation
import UIKit
import adadapted_swift_sdk


class OffScreenAdContoller: UIViewController, UIScrollViewDelegate, ZoneViewListener, AdContentListener {

    @IBOutlet weak var offScreenScrollView: UIScrollView!
    @IBOutlet weak var offScreenZoneView: AaZoneView!

    override func viewDidLoad() {
        super.viewDidLoad()

        offScreenScrollView.delegate = self
        
        offScreenZoneView.initialize(zoneId: "102110")
        offScreenZoneView.setAdZoneVisibility(isViewable: false)
        offScreenZoneView.onStart(listener: self, contentListener: self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        offScreenZoneView.onStop(listener: self)
    }
    
    func onZoneHasAds(hasAds: Bool) {
        var check = hasAds
    }
    
    func onAdLoaded() {
        
    }
    
    func onAdLoadFailed() {
        
    }

    func onContentAvailable(zoneId: String, content: adadapted_swift_sdk.AddToListContent) {
        let items = content.getItems()
        
        for item in items {
            content.itemAcknowledge(item: item)
        }
        content.acknowledge()
    }
    
    func onNonContentAction(zoneId: String, adId: String) {
        var checkZone = zoneId
        var checkAd = adId
    }

    func viewControllerForPresentingModalView() -> UIViewController? {
        return self
    }

    // determines if view is visible on screen
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if offScreenScrollView != nil {
            let viewFrame = scrollView.convert(offScreenZoneView.bounds, from: offScreenZoneView)
            if viewFrame.intersects(scrollView.bounds) {
                // Set ad zone visibility here for accurate tracking of off screen ads
                offScreenZoneView.setAdZoneVisibility(isViewable: true)
            } else {
                offScreenZoneView.setAdZoneVisibility(isViewable: false)
            }
        }
    }
}
