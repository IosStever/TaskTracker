//
//  PopOverViewController.swift
//  TaskTracker
//
//  Created by Steven Robertson on 2/23/19.
//  Copyright © 2019 Steven Robertson. All rights reserved.
//

import UIKit

class PopOverViewController: UIViewController {

    @IBOutlet weak var popOverTextView: UITextView!
    
    var popOverText = NSAttributedString()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popOverTextView.attributedText = popOverText
    }
    

}
