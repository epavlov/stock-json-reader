//
//  ViewController.swift
//  Stock Quote Example
//
//  Created by Eugene on 7/13/16.
//  Copyright © 2016 Ievgenii Pavlov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var stockLabelLabel: UILabel!
    @IBOutlet weak var stockValueLabel: UILabel!
    @IBOutlet weak var lastRefreshedLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refresh()
    }
    
    @IBAction func refreshButtonTap(sender: AnyObject) {
        loading()
        refresh()
    }
    
    func refresh() {
        JsonDataManager.sharedInstance.downloadData { (stockData) in
            dispatch_async(dispatch_get_main_queue(), {
                if JsonDataManager.sharedInstance.errorReturned != nil {
                    print(JsonDataManager.sharedInstance.errorReturned)
                } else {
                    self.stockValueLabel.text = stockData.stockValue
                    self.stockLabelLabel.text = stockData.stockLabel
                    self.lastRefreshedLabel.text = stockData.timestamp
                }
            })
        }
    }
    
    func loading() {
        self.stockValueLabel.text = "--"
        self.stockLabelLabel.text = "--"
        self.lastRefreshedLabel.text = "refreshing..."
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

