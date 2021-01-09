//
//  ViewController.swift
//  CostingHelper
//
//  Created by Rhett Owen on 1/4/21.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var inputFileBox: NSTextField!
    @IBOutlet weak var outputFileBox: NSTextField!
    @IBOutlet weak var outputFileNameBox: NSTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    /*
     Code from online. Opens file dialog window.
     */
    @IBAction func selectInputClicked(_ sender: Any) {
        let dialog = NSOpenPanel()

        dialog.title                   = "Choose input file"
        dialog.showsResizeIndicator    = true
        dialog.showsHiddenFiles        = false
        dialog.allowsMultipleSelection = false
        dialog.canChooseDirectories = false

        if (dialog.runModal() ==  NSApplication.ModalResponse.OK) {
            let result = dialog.url

            if (result != nil) {
                let path: String = result!.path
                inputFileBox.stringValue = path
                global.inputFile = inputFileBox.stringValue
            }
            
        } else {
            // User clicked on "Cancel"
            return
        }
    }
    
    /*
     Had to split into directory and file name bc mac is weird.
     */
    @IBAction func selectOutputClicked(_ sender: Any) {
        let dialog = NSOpenPanel()

        dialog.title                   = "Choose output file"
        dialog.showsResizeIndicator    = true
        dialog.showsHiddenFiles        = false
        dialog.allowsMultipleSelection = false
        dialog.canChooseDirectories = true

        if (dialog.runModal() ==  NSApplication.ModalResponse.OK) {
            let result = dialog.url

            if (result != nil) {
                let path: String = result!.path
                outputFileBox.stringValue = path
                global.outputFile = "file://" + outputFileBox.stringValue
                
            }
            
        } else {
            // User clicked on "Cancel"
            return
        }
    }
    

    
    @IBAction func goClicked(_ sender: Any) {
        global.outputFile += "/" + outputFileNameBox.stringValue
        print("GloBAL THING IS \(global.outputFile)")
        performSegue(withIdentifier:"showScrapingWindow", sender: self)
    }
    
}

//To make global accessible
var global = Global()

