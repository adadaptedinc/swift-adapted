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
    
    //var programmaticZoneView: AaZoneView = AaZoneView()
    
    @IBAction func editingChanged(_ sender: Any) {
        searchTextField.filterStrings(getListItems())
    }
    
    @IBAction func setRecipeContext(_ sender: UISwitch) {
        if sender.isOn {
            aaZoneView.setAdZoneContextId(contextId: "organicBad")
            aaZoneView.setAdZoneContextId(contextId: "organic") //testing
            //programmaticZoneView.setAdZoneContextId(contextId: "organic")
        } else {
            aaZoneView.removeAdZoneContext()
            //aaZoneView.clearAdZoneContext()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.delegate = self
        listTableView.delegate = self
        listTableView.dataSource = self
        
        aaZoneView.initialize(zoneId: "102110") //102110 102176-tasty
        aaZoneView.onStart(listener: self, contentListener: self)
        
//        programmaticZoneView.frame = CGRect(x: 0, y: 600, width: 0, height: 0)
//        programmaticZoneView.initialize(zoneId: "102110")
//        programmaticZoneView.onStart(listener: self)
        //view.addSubview(programmaticZoneView)
        
        listData = ["Eggs", "Bread"]
        searchTextField.font = UIFont.systemFont(ofSize: 15)
        searchTextField.minCharactersNumberToStartFiltering = 3
        searchTextField.filterStrings(getListItems())
        
        //UL testing
//        AdAdaptedLinkHandler.parseUniversalLink("https://ul.adadapted.com/swiftadapted?data=eyJwYXlsb2FkX2lkIjoiMUJDMjBGNDQtMzE1My00QURDLUFCNEEtQzlERUQzNUE0MkQ4IiwicGF5bG9hZF9tZXNzYWdlIjoiRmlyc3QgU2FtcGxlIFByb2R1Y3QiLCJwYXlsb2FkX2ltYWdlIjoiMjAxOTAxMTRfMjIxMTIzX3Rlc3RfaW1hZ2VfMi5wbmciLCJjYW1wYWlnbl9pZCI6IjI1NyIsImFwcF9pZCI6Imdyb2NlcnlsaXN0dGVzdGFwcCIsImV4cGlyZV9zZWNvbmRzIjo2MDQ4MDAsImRldGFpbGVkX2xpc3RfaXRlbXMiOlt7InRyYWNraW5nX2lkIjoiQ0RFQTNGODUtRTc4Ri00NzlGLUFFQkEtMjdBQjY1MEZBMjI2IiwicHJvZHVjdF90aXRsZSI6IkZpcnN0IFNhbXBsZSBQcm9kdWN0IiwicHJvZHVjdF9icmFuZCI6IlNhbXBsZSBCcmFuZCIsInByb2R1Y3RfY2F0ZWdvcnkiOiIiLCJwcm9kdWN0X2JhcmNvZGUiOiIwMTIzNCIsInByb2R1Y3Rfc2t1IjoiIiwicHJvZHVjdF9kaXNjb3VudCI6IiIsInByb2R1Y3RfaW1hZ2UiOiJodHRwczpcL1wvaW1hZ2VzLmFkYWRhcHRlZC5jb21cLzIwMTkwMTE0XzIyMTEyM190ZXN0X2ltYWdlXzIucG5nIn0seyJ0cmFja2luZ19pZCI6IjIxMEI5RUNBLTk4MjQtNDdBMi1BMDQ2LTg0NjRGMkEyOTdENiIsInByb2R1Y3RfdGl0bGUiOiJTZWNvbmQgU2FtcGxlIFByb2R1Y3QiLCJwcm9kdWN0X2JyYW5kIjoiU2FtcGxlIEJyYW5kIiwicHJvZHVjdF9jYXRlZ29yeSI6IiIsInByb2R1Y3RfYmFyY29kZSI6IjQzMjEwIiwicHJvZHVjdF9za3UiOiIiLCJwcm9kdWN0X2Rpc2NvdW50IjoiIiwicHJvZHVjdF9pbWFnZSI6Imh0dHBzOlwvXC9pbWFnZXMuYWRhZGFwdGVkLmNvbVwvMjAxOTAxMTRfMjIxMTQ2X3Rlc3RfaW1hZ2VfMi5wbmcifV19")

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        aaZoneView.onStop(listener: self)
        //programmaticZoneView.onStop(listener: self)
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
        //testing to set size after being started at 0,0
        //programmaticZoneView.frame = CGRect(x: 0, y: 600, width: view.bounds.width, height: 128)
    }
    
    func onContentAvailable(zoneId: String, content: AddToListContent) {
        let items = content.getItems()
        
        for item in items {
            content.itemAcknowledge(item: item)
            appendListItem(itemName: item.title)
        }
        content.acknowledge()
    }
    
    func onNonContentAction(zoneId: String, adId: String) {
        var checkZone = zoneId
        var checkAd = adId
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
