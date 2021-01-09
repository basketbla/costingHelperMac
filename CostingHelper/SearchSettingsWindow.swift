//
//  SearchSettingsWindow.swift
//  CostingHelper
//
//  Created by Rhett Owen on 1/4/21.
//

import Cocoa

class SearchSettingsWindow: NSViewController {
    
    @IBOutlet weak var numResultsSelector: NSPopUpButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func doneButtonClicked(_ sender: Any) {
        self.view.window?.close()
        global.numResults = Int(numResultsSelector.selectedItem!.title)!
        print("\(global.numResults)")
    }
    

    
    

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
}
