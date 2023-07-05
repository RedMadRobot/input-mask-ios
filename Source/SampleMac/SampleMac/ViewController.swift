//
// Project «InputMask»
// Created by Jeorge Taflanidi
//


import Cocoa
import InputMask


class ViewController: NSViewController {
    @IBOutlet weak var dateTextListener: TextViewListener!
    @IBOutlet weak var dateTextView: NSTextView!
    
    @IBOutlet weak var phoneTextListener: TextViewListener!
    @IBOutlet weak var phoneTextView: NSTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let datePlaceholder = NSAttributedString(
            string: dateTextListener.placeholder,
            attributes: [
                .foregroundColor: NSColor.secondaryLabelColor,
                .font: NSFont.monospacedSystemFont(ofSize: 14, weight: NSFont.Weight.regular)
            ]
        )
        
        dateTextView.font = NSFont.monospacedSystemFont(ofSize: 14, weight: NSFont.Weight.regular)
        dateTextView.setAttributedPlaceholder(datePlaceholder)
        
        let phonePlaceholder = NSAttributedString(
            string: phoneTextListener.placeholder,
            attributes: [
                .foregroundColor: NSColor.secondaryLabelColor,
                .font: NSFont.monospacedSystemFont(ofSize: 14, weight: NSFont.Weight.regular)
            ]
        )
        
        phoneTextView.font = NSFont.monospacedSystemFont(ofSize: 14, weight: NSFont.Weight.regular)
        phoneTextView.setAttributedPlaceholder(phonePlaceholder)
    }
}
