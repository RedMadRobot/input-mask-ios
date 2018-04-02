//
// Project «InputMask»
// Created by Jeorge Taflanidi
//


import Foundation


public extension MaskedTextFieldDelegate {
    
    /**
     Workaround to support Interface Builder delegate outlets.
     
     Allows assigning ```MaskedTextFieldDelegate.listener``` within the Interface Builder.
     
     Consider using ```MaskedTextFieldDelegate.listener``` property from your source code instead of
     ```MaskedTextFieldDelegate.delegate``` outlet.
     */
    @IBOutlet public var delegate: NSObject? {
        get {
            return self.listener as? NSObject
        }
        
        set(newDelegate) {
            if let listener = newDelegate as? MaskedTextFieldDelegateListener {
                self.listener = listener
            }
        }
    }
    
}
