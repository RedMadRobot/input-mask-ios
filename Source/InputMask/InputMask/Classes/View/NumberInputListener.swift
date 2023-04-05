//
// Project «InputMask»
// Created by Jeorge Taflanidi
//

#if !os(macOS) && !os(watchOS)

import Foundation
import UIKit

/**
 — Mom, can we have a neural network?
 — No, we have a neural network at home.
 
 Neural network at home:
 */

/**
 ### NumberInputListener
 
 A ```MaskedTextInputListener``` subclass for numbers
 
 N.B. Assign a ```NumberFormatter``` instance to the ```::formatter``` field
 */
@available(iOS 16.0, *)
open class NumberInputListener: MaskedTextInputListener {
    open var formatter: NumberFormatter?
    
    open override var placeholder: String {
        let text = "0"
        let mask: Mask = pickMask(
            forText: CaretString(
                string: text,
                caretPosition: text.endIndex,
                caretGravity: CaretString.CaretGravity.forward(autocomplete: autocomplete)
            )
        )
        return mask.placeholder
    }
    
    open override func pickMask(forText text: CaretString) -> Mask {
        guard let formatter = formatter
        else {
            return try! Mask.getOrCreate(withFormat: "[…]")
        }
        
        let sanitisedNumberString = extractNumberAndDecimalSeparator(formatter: formatter, text: text.string)
        
        guard let intNum = NumberFormatter().number(from: sanitisedNumberString.intPart), let intMaskFormat = formatter.string(from: intNum)
        else {
            return try! Mask.getOrCreate(withFormat: "[…]")
        }
        
        let intZero: Bool = intNum.isEqual(to: 0)
        let notationChar = assignNonZeroNumberNotation()
        
        var maskFormat = ""
        var first = true
        intMaskFormat.forEach { char in
            if CharacterSet.decimalDigits.isMember(character: char) {
                if first && !intZero {
                    maskFormat += "[\(notationChar)]"
                    first = false
                } else {
                    maskFormat += "[0]"
                }
            } else {
                maskFormat += "{\(char)}"
            }
        }
        
        if sanitisedNumberString.numberOfOccurencesOfDecimalSeparator > 0 {
            maskFormat += "{\(sanitisedNumberString.expectedDecimalSeparator)}"
        }
        
        sanitisedNumberString.decPart.forEach { char in
            maskFormat += "[0]"
        }
        
        primaryMaskFormat = maskFormat
        return super.pickMask(forText: text)
    }
    
    open override func textFieldDidBeginEditing(_ textField: UITextField) {
        if autocompleteOnFocus && (textField.text ?? "").isEmpty {
            let result: Mask.Result = put(text: "0", into: textField, autocomplete: true)
            notifyOnMaskedTextChangedListeners(forTextInput: textField, result: result)
        }
    }
    
    open override func textFieldShouldClear(_ textField: UITextField) -> Bool {
        let result: Mask.Result = put(text: "0", into: textField, autocomplete: false)
        notifyOnMaskedTextChangedListeners(forTextInput: textField, result: result)
        return true
    }
    
    open override func textViewDidBeginEditing(_ textView: UITextView) {
        if autocompleteOnFocus && textView.text.isEmpty {
            let result: Mask.Result = put(text: "0", into: textView, autocomplete: true)
            notifyOnMaskedTextChangedListeners(forTextInput: textView, result: result)
        }
    }
    
    private struct SanitisedNumberString {
        let intPart: String
        let decPart: String
        let expectedDecimalSeparator: String
        let numberOfOccurencesOfDecimalSeparator: Int
    }
    
    private func extractNumberAndDecimalSeparator(
        formatter: NumberFormatter,
        text: String
    ) -> SanitisedNumberString {
        let decimalSeparator = "."
        
        let appliedDecimalSeparator = formatter.decimalSeparator ?? decimalSeparator
        let appliedCurrencyDecimalSeparator = formatter.currencyDecimalSeparator ?? decimalSeparator
        
        var expectedDecimalSeparator: String = appliedDecimalSeparator
        if text.contains(appliedCurrencyDecimalSeparator) {
            expectedDecimalSeparator = appliedCurrencyDecimalSeparator
        }
        
        var digitsAndDecimalSeparators = text
            .replacingOccurrences(of: appliedDecimalSeparator, with: decimalSeparator)
            .replacingOccurrences(of: appliedCurrencyDecimalSeparator, with: decimalSeparator)
            .filter { c in
                return CharacterSet.decimalDigits.isMember(character: c) || String(c) == decimalSeparator
            }
        
        let numberOfOccurencesOfDecimalSeparator = digitsAndDecimalSeparators.numberOfOccurencesOf(decimalSeparator)
        if numberOfOccurencesOfDecimalSeparator > 1 {
            digitsAndDecimalSeparators =
                digitsAndDecimalSeparators
                    .reversed
                    .replacing(decimalSeparator, with: "", maxReplacements: numberOfOccurencesOfDecimalSeparator - 1)
                    .reversed
        }
        
        let components = digitsAndDecimalSeparators.components(separatedBy: decimalSeparator)
        
        var intStr = components.first ?? ""
        var decStr = components.last ?? ""
        
        intStr = intStr.isEmpty ? "0" : intStr
        intStr = String(intStr.prefix(formatter.maximumIntegerDigits))
        decStr = String(decStr.prefix(formatter.maximumFractionDigits))
        
        return SanitisedNumberString(
            intPart: intStr,
            decPart: decStr,
            expectedDecimalSeparator: expectedDecimalSeparator,
            numberOfOccurencesOfDecimalSeparator: numberOfOccurencesOfDecimalSeparator
        )
    }
    
    private func assignNonZeroNumberNotation() -> Character {
        let character: Character = "1"
        customNotations = [
            Notation(
                character: character,
                characterSet: CharacterSet(charactersIn: "123456789"),
                isOptional: false
            )
        ]
        return character
    }
}

#endif
