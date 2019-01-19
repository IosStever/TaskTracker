//
//  SummaryViewController.swift
//  ProductionControlTaskTracking
//
//  Created by Steven Robertson on 1/19/19.
//  Copyright © 2019 Steven Robertson. All rights reserved.
//

import UIKit

class SummaryViewController: UIViewController {
    @IBOutlet weak var summaryTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        summaryTextView.text = summaryText
        
        let share = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.action,  target: self, action: #selector(self.share))
        
        navigationItem.rightBarButtonItems = [share]
    }
    
    var summaryText = ""
    
    @IBAction func share() {
        let print = UISimpleTextPrintFormatter(text: summaryText)
        let ac = UIActivityViewController(activityItems: [summaryText, print], applicationActivities: nil)
        present(ac, animated: true)
        if let popOver = ac.popoverPresentationController {
            popOver.sourceView = self.view
        }
    }
    
    
    
}
