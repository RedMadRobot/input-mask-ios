//
// Project «InputMask»
// Created by Jeorge Taflanidi
//

#if !os(macOS) && !os(watchOS)

import Foundation

open class NumberInputListener: MaskedTextInputListener {
    open var numberFormatter: NumberFormatter?
    
    open override func pickMask(forText text: CaretString) -> Mask {
        guard let formatter = numberFormatter
        else {
            return super.pickMask(forText: text)
        }
        
        let decimalSeparator = formatter.decimalSeparator ?? "."
        let currencyDecimalSeparator = formatter.currencyDecimalSeparator ?? "."
        
        let number = text.string.filter { character in
            let characterStr = String(character)
            let ok = characterStr == decimalSeparator || characterStr == currencyDecimalSeparator || CharacterSet.decimalDigits.isMember(character: character)
            return ok
        }
        
        let decimalNumber: String = number
            .replacingOccurrences(of: decimalSeparator, with: ".")
            .replacingOccurrences(of: currencyDecimalSeparator, with: ".")
        
        guard let number = NumberFormatter().number(from: decimalNumber), let maskFormat = formatter.string(from: number)
        else {
            return super.pickMask(forText: text)
        }
        
        primaryMaskFormat = "{\(maskFormat)}"
        return super.pickMask(forText: text)
    }
}

#endif
