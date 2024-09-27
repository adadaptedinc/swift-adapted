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
    @IBOutlet weak var offScreenZoneViewTwo: AaZoneView!
    @IBOutlet weak var keywordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        offScreenScrollView.delegate = self
        
        offScreenZoneView.initialize(zoneId: "102110")
        offScreenZoneView.setAdZoneVisibility(isViewable: false)
        offScreenZoneView.onStart(listener: self, contentListener: self)
        
        offScreenZoneViewTwo.initialize(zoneId: "102110")
        offScreenZoneViewTwo.setAdZoneVisibility(isViewable: false)
        offScreenZoneViewTwo.onStart(listener: self, contentListener: self)
        
        keywordText.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        offScreenZoneView.onStop(listener: self)
        offScreenZoneViewTwo.onStop(listener: self)
    }
    
    //for directly testing keywords
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text {
            let results = KeywordInterceptMatcher.getInstance().match(constraint: text)
        }
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
            
            let viewFrameTwo = scrollView.convert(offScreenZoneView.bounds, from: offScreenZoneViewTwo)
            if viewFrameTwo.intersects(scrollView.bounds) {
                // Set ad zone visibility here for accurate tracking of off screen ads
                offScreenZoneViewTwo.setAdZoneVisibility(isViewable: true)
            } else {
                offScreenZoneViewTwo.setAdZoneVisibility(isViewable: false)
            }
        }
    }
}
