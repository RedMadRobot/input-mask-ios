//
// Project «InputMask»
// Created by Jeorge Taflanidi
//


import Foundation


/**
 Utility extension for comonly used ```Mask``` operations upon strings.
 */
extension String {
    
    /**
     Make a string by cutting the first character of current.
     
     - returns: Current string without first character.
     
     - throws: EXC_BAD_INSTRUCTION for empty strings.
     */
    func truncateFirst() -> String {
        return String(self[self.index(after: self.startIndex)...])
    }
    
}
