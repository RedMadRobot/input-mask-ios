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
        
        var number = text.string.filter { character in
            let characterStr = String(character)
            let ok = characterStr == decimalSeparator || characterStr == currencyDecimalSeparator || CharacterSet.decimalDigits.isMember(character: character)
            return ok
        }
        
        while number.starts(with: "0") {
            number = number.truncateFirst()
        }
        
        var suffix = ""
        if let lastChar = number.last, !CharacterSet.decimalDigits.isMember(character: lastChar) {
            suffix = String(lastChar) // suffix is a dangling decimal separator
        }
        
        var decimalNumber: String = number
            .replacingOccurrences(of: decimalSeparator, with: ".")
            .replacingOccurrences(of: currencyDecimalSeparator, with: ".")
        
        if decimalNumber.contains(".") {
            let components = decimalNumber.components(separatedBy: ".")
            let intPart = components.first ?? ""
            var decPart = components.last ?? ""
            
            if decPart.count > formatter.maximumFractionDigits {
                decPart = String(decPart[...decPart.startIndex(offsetBy: formatter.maximumFractionDigits)])
            }
            decimalNumber = "\(intPart).\(decPart)"
        }
        
        if suffix.isEmpty && decimalNumber.contains(".") {
            for char in decimalNumber.reversed {
                if char != "0" && char != "." {
                    break
                }
                suffix = String(char) + suffix
            }
        }
        
        guard let number = NumberFormatter().number(from: decimalNumber), let maskFormat = formatter.string(from: number)
        else {
            return super.pickMask(forText: text)
        }
        
        customNotations = [
            Notation(
                character: "1",
                characterSet: CharacterSet(charactersIn: "123456789"),
                isOptional: false
            )
        ]
        
        let canHaveLeadingZero = number.compare(NSNumber(value: 0)) == .orderedDescending && number.intValue == 0
        
        primaryMaskFormat = composeFormat(fromText: maskFormat + suffix, canHaveLeadingZero: canHaveLeadingZero)
        return super.pickMask(forText: text)
    }
    
    open func composeFormat(fromText text: String, canHaveLeadingZero: Bool) -> String {
        var result = ""
        var first = true
        text.forEach { character in
            if CharacterSet.decimalDigits.isMember(character: character) {
                if first && !canHaveLeadingZero {
                    result += "[1]"
                    first = false
                } else {
                    result += "[0]"
                }
            } else {
                result += "{\(character)}"
            }
        }
        return result
    }
}

#endif
