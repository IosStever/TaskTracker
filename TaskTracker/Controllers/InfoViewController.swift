//
//  InfoViewController.swift
//  TaskTracker
//
//  Created by Steven Robertson on 2/8/19.
//  Copyright © 2019 Steven Robertson. All rights reserved.
//

import UIKit
import CoreData

class InfoViewController: UIViewController {

    @IBOutlet weak var taskNameLabel: UILabel!
    
    @IBOutlet weak var taskCommentsLabel: UILabel!
    
    @IBOutlet weak var infoTextView: UITextView!
    
    
    

    
    var infoTask: Task? {
        didSet {

        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        infoTextView.layer.borderWidth = 1
         infoTextView.layer.borderColor = UIColor.blue.cgColor
        taskNameLabel.layer.borderWidth = 1
        taskNameLabel.layer.borderColor = UIColor.blue.cgColor
        taskCommentsLabel.layer.borderWidth = 1
        taskCommentsLabel.layer.borderColor = UIColor.blue.cgColor
                loadTask()
        taskNameLabel.padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        taskCommentsLabel.padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
    }
    
    func loadTask() {
        taskNameLabel.text = ("+\(infoTask?.timeFromStart ?? 0): \((infoTask?.taskName) ?? "No name")")
        
        if let comments = infoTask?.comments {
            taskCommentsLabel.text = comments
        }

        if let info = infoTask?.info {
            infoTextView.attributedText = (info as! NSAttributedString)
        }
        
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//class MyLabel: UILabel{
//    override func drawText(in rect: CGRect) {
//        super.drawText(in: rect.inset(by: UIEdgeInsets(top: 0, left: 100, bottom: 0, right: 0)))
//    }
//}

class InsetLabel: UILabel {
    
    let inset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: inset))
    }
    
    override var intrinsicContentSize: CGSize {
        var intrinsicContentSize = super.intrinsicContentSize
        intrinsicContentSize.width += inset.left + inset.right
        intrinsicContentSize.height += inset.top + inset.bottom
        return intrinsicContentSize
    }
    
}


extension UILabel {
    private struct AssociatedKeys {
        static var padding = UIEdgeInsets()
    }
    
    public var padding: UIEdgeInsets? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.padding) as? UIEdgeInsets
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedKeys.padding, newValue as UIEdgeInsets?, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    override open func draw(_ rect: CGRect) {
        if let insets = padding {
            self.drawText(in: rect.inset(by: insets))
        } else {
            self.drawText(in: rect)
        }
    }
    
    override open var intrinsicContentSize: CGSize {
        guard let text = self.text else { return super.intrinsicContentSize }
        
        var contentSize = super.intrinsicContentSize
        var textWidth: CGFloat = frame.size.width
        var insetsHeight: CGFloat = 0.0
        var insetsWidth: CGFloat = 0.0
        
        if let insets = padding {
            insetsWidth += insets.left + insets.right
            insetsHeight += insets.top + insets.bottom
            textWidth -= insetsWidth
        }
        
        let newSize = text.boundingRect(with: CGSize(width: textWidth, height: CGFloat.greatestFiniteMagnitude),
                                        options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                        attributes: [NSAttributedString.Key.font: self.font], context: nil)
        
        contentSize.height = ceil(newSize.size.height) + insetsHeight
        contentSize.width = ceil(newSize.size.width) + insetsWidth
        
        return contentSize
    }
}
