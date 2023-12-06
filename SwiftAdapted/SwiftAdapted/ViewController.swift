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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.delegate = self
        listTableView.delegate = self
        listTableView.dataSource = self
        
        aaZoneView.initialize(zoneId: "102110")
        aaZoneView.onStart(listener: self, contentListener: self)
        
        listData = ["Eggs", "Bread"]
        searchTextField.font = UIFont.systemFont(ofSize: 15)
        //searchTextField.minCharactersNumberToStartFiltering = 3
        //searchTextField.filterStrings(getListItems())
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
    
    @IBAction func textFieldChanged(_ sender: UITextField) {
        searchTextField.filterStrings(getListItems())
    }
    @IBAction func addItem(_ sender: UIButton) {
        if searchTextField.text != nil && !searchTextField.text!.isEmpty {
            //RECIPE test call to get recipe ads
            var test = searchTextField.text
            if (searchTextField.text == "clear") {
                //adAdaptedZoneView.clearAdZoneContext()
            } else {
                //adAdaptedZoneView.setAdZoneContext(contextID: "1201") //berry-smoothie-bowl
            }
            // END RECIPE TEST
            
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
    
    private func getListItems(suggestion: String = String()) -> [String] {
        guard let path = Bundle.main.url(forResource: "DefaultListItems", withExtension: "plist") else {return []}
        let data = try! Data(contentsOf: path)
        
        guard var plist = try! PropertyListSerialization.propertyList(from: data, options: .mutableContainers, format: nil) as? [String] else {return []}
        
        if !suggestion.isEmpty {
            plist.append(suggestion)
        }
        
        return plist
    }
    
    private func appendListItem(itemName: String = "") {
        listData.append(itemName)
        listTableView.reloadData()
        searchTextField.text = ""
    }
    
}
