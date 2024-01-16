//
//  ViewController.swift
//  SwiftAdapted
//
//  Created by Brett Clifton on 11/16/23.
//

import UIKit
import adadapted_swift_sdk

class ViewController:
    UIViewController,
    UITableViewDataSource,
    UITableViewDelegate,
    UISearchTextFieldDelegate,
    ZoneViewListener,
    AdContentListener {
    
    @IBOutlet weak var aaZoneView: AaZoneView!
    @IBOutlet weak var searchTextField: SearchTextField!
    @IBOutlet weak var addItemButton: UIButton!
    @IBOutlet weak var listTableView: UITableView!
    
    @IBAction func editingChanged(_ sender: Any) {
        searchTextField.filterStrings(getListItems())
    }
    
    @IBAction func setRecipeContext(_ sender: UISwitch) {
        if sender.isEnabled {
            aaZoneView.setAdZoneContextId(contextId: "alex_recipe_id_1")
        } else {
            aaZoneView.clearAdZoneContext()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.delegate = self
        listTableView.delegate = self
        listTableView.dataSource = self
        
        aaZoneView.initialize(zoneId: "102110")
        aaZoneView.onStart(listener: self, contentListener: self)
        
        listData = ["Eggs", "Bread"]
        searchTextField.font = UIFont.systemFont(ofSize: 15)
        searchTextField.minCharactersNumberToStartFiltering = 3
        searchTextField.filterStrings(getListItems())
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        aaZoneView.onStop(listener: self)
    }
    
    var listData = [String]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let item = listData[indexPath.row]
        cell.textLabel?.text = item
        
        return cell
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        addItem(addItemButton)
    }
    
    @IBAction func addItem(_ sender: UIButton) {
        if searchTextField.text != nil && !searchTextField.text!.isEmpty {
            appendListItem(itemName: searchTextField.text!)
        }
    }
    
    func onContentAvailable(zoneId: String, content: AddToListContent) {
        let items = content.getItems()
        
        for item in items {
            content.itemAcknowledge(item: item)
            appendListItem(itemName: item.title)
        }
        content.acknowledge()
    }
    
    func onZoneHasAds(hasAds: Bool) {
        var check = hasAds
    }
    
    func onAdLoaded() {
        
    }
    
    func onAdLoadFailed() {
        
    }
    
    func getListItems() -> [String] {
        if let plistPath = Bundle.main.path(forResource: "DefaultListItems", ofType: "plist"),
           let plistData = FileManager.default.contents(atPath: plistPath) {
            do {
                let plistObject = try PropertyListSerialization.propertyList(from: plistData, options: [], format: nil)
                if let stringArray = plistObject as? [String] {
                    return stringArray
                }
            } catch {
                print("Error: Unable to deserialize plist data - \(error)")
            }
        }
        return []
    }
    
    private func appendListItem(itemName: String = "") {
        listData.append(itemName)
        listTableView.reloadData()
        searchTextField.text = ""
    }
}
