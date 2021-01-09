//
//  DirectEntryWindow.swift
//  CostingHelper
//
//  Created by Rhett Owen on 1/4/21.
//

import Cocoa

class DirectEntryWindow: NSViewController {
    @IBAction func doneButtonClicked(_ sender: Any) {
        self.view.window?.close()
        global.directEntry = directEntryBox.string
        global.usingFile = false
    }
    

    @IBOutlet var directEntryBox: NSTextView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
}
