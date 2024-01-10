//
//  LaunchViewController.swift
//  SwiftAdapted
//
//  Created by Brett Clifton on 1/10/24.
//

import Foundation
import adadapted_swift_sdk
import UIKit

class LaunchViewController: UIViewController {
    @IBAction func testSendListManagerReports(_ sender: Any) {
        AdAdaptedListManager.itemAddedToList(item: "testItemAdd", list: "swift_adapted_list")
        AdAdaptedListManager.itemCrossedOffList(item: "testItemCross", list: "swift_adapted_list")
        AdAdaptedListManager.itemDeletedFromList(item: "testItemDelete", list: "swift_adapted_list")
        
        Toast.showToast(message: "List Manager Reports Sent.")
    }
}
