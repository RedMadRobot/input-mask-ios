//
// Project «InputMask»
// Created by Jeorge Taflanidi
//


import Cocoa


extension NSTextView {
    func setAttributedPlaceholder(_ attributedPlaceholder: NSAttributedString) {
        self.setValue(attributedPlaceholder, forKey: "placeholderAttributedString")
    }
}
