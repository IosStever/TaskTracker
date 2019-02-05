//
//  SummaryViewController.swift
//  ProductionControlTaskTracking
//
//  Created by Steven Robertson on 1/19/19.
//  Copyright © 2019 Steven Robertson. All rights reserved.
//

import UIKit

class SummaryViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var summaryTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let attrs = [NSAttributedString.Key.font : UIFont(name: "Georgia", size: 14)!]
        summaryTextView.allowsEditingTextAttributes = true
        summaryTextAttributed = NSAttributedString(string: summaryText, attributes: attrs)
        summaryTextView.attributedText = summaryTextAttributed
    }
    
    var summaryText = ""
    var summaryTextAttributed = NSAttributedString()
    
    @IBAction func shareButtonPressed(_ sender: UIBarButtonItem) {
        let print = UISimpleTextPrintFormatter(attributedText: summaryTextAttributed)
        let ac = UIActivityViewController(activityItems: [summaryText, print], applicationActivities: nil)
        present(ac, animated: true)
        if let popOver = ac.popoverPresentationController {
            popOver.sourceView = self.view 
        }
        
    }
    
    
    
    @IBAction func share() {
        let print = UISimpleTextPrintFormatter(text: summaryText)
        let ac = UIActivityViewController(activityItems: [summaryText, print], applicationActivities: nil)
        present(ac, animated: true)
        if let popOver = ac.popoverPresentationController {
            popOver.sourceView = self.view
        }
    }
    
    
    
}
