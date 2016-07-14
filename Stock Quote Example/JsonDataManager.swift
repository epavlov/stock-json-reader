//
//  JsonDataManager.swift
//  Stock Quote Example
//
//  Created by Eugene on 7/13/16.
//  Copyright © 2016 Ievgenii Pavlov. All rights reserved.
//

import Foundation

class JsonDataManager {
    
    static let sharedInstance = JsonDataManager() // singleton
    let JSON_URL = "https://www.google.com/finance/info?q=GM" // constant for URL from which JSON will be retrieved
    var errorReturned: String! // variable to hold error
    
    /**
     Function to load and parse json data from Google Finiance page
     
     - returns: conmpition handler with StockData class object
     */
    func downloadData(completionHandler: (stockData: StockData) -> ()) {
        let sd = StockData()
        
        if let url = NSURL(string: JSON_URL) { // safe unwrap of URL
            
            let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, responce, error) -> Void in
                // Check if data exist (safe unwrapping)
                if let urlContent = data {
    
                    // Encoding data to readable format
                    let resultData = NSString(data: urlContent, encoding: NSUTF8StringEncoding)
                    // Wait until data is downloaded and then work with it
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        if let result = resultData { // Save unwrap
                            
                            // Since downloaded data from Google Finance has HTML content type and not JSON, we need to remove "//" characters from the beggining of the returned string, to be able to serialize json data for further use
                            let jsonString  = result.substringFromIndex(4)
                            do {
                                // Convert jsonString to NSData to be able to serialize it as json object
                                let jsonData = jsonString.dataUsingEncoding(NSUTF8StringEncoding)
                                
                                // Serializa json data as an object
                                let jsonObject = try NSJSONSerialization.JSONObjectWithData(jsonData!, options: .AllowFragments)
                                
                                if let stockData = jsonObject as? [[String: AnyObject]] {
                                    for stockObject in stockData {
                                        // Retrieve data and save into appropriate global vars
                                        if let stockValueRaw = stockObject["l"] as? String {
                                            sd.stockValue = stockValueRaw
                                        }
                                        if let stockLabelRaw = stockObject["t"] as? String {
                                            sd.stockLabel = stockLabelRaw
                                        }
                                        if let stockTimestapmRaw = stockObject["lt_dts"] as? String {
                                            sd.timestamp = stockTimestapmRaw
                                        }
                                    }
                                }
                                
                            } catch {
                                self.errorReturned = "JSON Serialization failed: \(error)"
                            }
                            
                        }
                        completionHandler(stockData: sd)
                    })
                } else {
                    self.errorReturned = "No data returned from URL: \(self.JSON_URL)"
                    completionHandler(stockData: sd)
                }
            }
            // Run the task
            task.resume()
        }
    }
}