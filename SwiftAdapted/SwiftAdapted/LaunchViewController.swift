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
        AdAdaptedListManager.itemAddedToList(list: "swift_adapted_list", item: "testItemAdd")
        AdAdaptedListManager.itemCrossedOffList(list: "swift_adapted_list", item: "testItemCross")
        AdAdaptedListManager.itemDeletedFromList(list: "swift_adapted_list", item: "testItemDelete")
        
        Toast.showToast(message: "List Manager Reports Sent.")
    }
}
