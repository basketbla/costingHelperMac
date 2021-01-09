//
//  ScrapingWindow.swift
//  CostingHelper
//
//  Created by Rhett Owen on 1/4/21.
//

import Cocoa
import SwiftSoup
import WebKit
import SafariServices

class ScrapingWindow: NSViewController {
    
    @IBOutlet weak var progressBox: NSTextField!
    var queryTerms = [] as Array<String>
    var dataTask: URLSessionDataTask?
    let webView = WKWebView()
    var output = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doScraping()
        progressBox.stringValue += "\nDone! You can find the file with the results at\n\(global.outputFile)"
        do {
            try output.write(to: URL(string: global.outputFile)!, atomically: false, encoding: .utf8)
        }
        catch {progressBox.stringValue += "\nThere was an error writing to the output file. Maybe try a different directory or file name."}

    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    //Let's translate this into swift!
    func doScraping() {
        var siteUrl: String
        progressBox.stringValue = "Doing some scraping and such..."
        readInput()
        for term in queryTerms {
            siteUrl = "https://www.google.com/search?psb=1&tbm=shop&q=" + term + "&ved=0CAQQr4sDKAJqFwoTCI2Vw6OSyesCFVoeswAdo2EPURAD"
            scrapeGoogle(url: siteUrl, item: term)
        }
        
    }
    
    /*
     Parses input (from file or direct box) and puts terms in queryTerms
     */
    func readInput() {
        progressBox.stringValue += "\nReading Input..."
        var inputString = ""
        if(global.usingFile) {
            do {
                inputString = try String(contentsOfFile: global.inputFile)
            }
            catch {
                progressBox.stringValue += "\nThere was an error reading from the input file. Maybe try a different directory or file name."
            }
            progressBox.stringValue += inputString
        }
        else {
            inputString = global.directEntry
        }
        let lines = inputString.components(separatedBy: "\n")
        for line in lines {
            if(line != "") {
                queryTerms.append(line)
            }
        }
    }
    
    /*
     Main helper function. Makes searches and calls other helpers to clean results
     */
    func scrapeGoogle(url: String, item: String) {
        let html = try! String(contentsOf: URL(string: url)!, encoding: .ascii)
        let doc = try! SwiftSoup.parse(html)

        let items = try! doc.select("div.rgHvZc")
        let prices = try! doc.select("span.HRLxBb")
        let shipping = try! doc.select("span.dD8iuc")
        let sellers = try! doc.select("div.dD8iuc")
        
        //Check to see if we can get all results
        let limitingNum = min(items.count, prices.count, shipping.count, sellers.count)

        if (limitingNum < global.numResults) {
            print("LIMITING NUM IS \(limitingNum)")
            progressBox.stringValue += "\nDidn't have enough results for \(item). Using \(limitingNum) instead of \(global.numResults)."
            global.numResults = limitingNum
        }
        
        output += item
        var priceSum = 0.0
        var itemStrings = [] as Array<String>
        var priceStrings = [] as Array<String>
        var shippingStrings = [] as Array<String>
        var sellerStrings = [] as Array<String>
        
        //This is wacky, but I'm just filtering out bad seller tags
        var sellerCounter = 0
        
        //Get string representations and price sum
        for x in 0..<global.numResults {
            itemStrings.append(try! items[x].text())
            
            var price = try! prices[x].text()
            price = price.replacingOccurrences(of: ",", with: "", options: NSString.CompareOptions.literal, range: nil)
            if price.contains("used") {
                price = price.replacingOccurrences(of: " used", with: "", options: NSString.CompareOptions.literal, range: nil)
            }
            var numIndex = price.index(price.startIndex, offsetBy: 1)
            priceSum += Double(price[numIndex...])!
            priceStrings.append(price)
            
            var shipping = try! shipping[x].text()
            shipping = shipping.replacingOccurrences(of: ",", with: "", options: NSString.CompareOptions.literal, range: nil)
            if !shipping.lowercased().contains("free") {
                numIndex = shipping.index(shipping.startIndex, offsetBy: 2)
                print(shipping)
                priceSum += Double(shipping[numIndex...shipping.index(shipping.firstIndex(of: "s")!, offsetBy:-2)])!
            }
            shippingStrings.append(shipping)
            
            var seller = try! sellers[sellerCounter].text()
            while !seller.contains("from") {
                sellerCounter += 1
                seller = try! sellers[sellerCounter].text()
            }
            numIndex = seller.index(seller.firstIndex(of: "m")!, offsetBy: 2)
            sellerStrings.append(String(seller[numIndex...]))
            sellerCounter += 1
        }
        //actually modify output string
        output += "\nAverage price (including shipping): $\(((priceSum/Double(global.numResults))*100).rounded()/100)"
        
        for x in 0..<global.numResults {
            output += "\n"
            output += "\nItem \(x+1):"
            output += "\n\(itemStrings[x])"
            output += "\n\(priceStrings[x])"
            output += "\n\(shippingStrings[x])"
            output += "\n\(sellerStrings[x])"
        }
        output += "\n\n"
    }
}


