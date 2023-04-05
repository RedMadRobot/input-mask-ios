//
// Project «InputMask»
// Created by Jeorge Taflanidi
//

#if !os(macOS) && !os(watchOS)

import Foundation
import UIKit

@available(iOS 16.0, *)
open class NumberInputListener: MaskedTextInputListener {
    open var formatter: NumberFormatter?
    
    open override func pickMask(forText text: CaretString) -> Mask {
        guard let formatter = formatter
        else {
            return try! Mask.getOrCreate(withFormat: "[…]")
        }
        
        let definedDecimalSeparator = formatter.decimalSeparator ?? "."
        let definedCurrencyDecimalSeparator = formatter.currencyDecimalSeparator ?? "."
        
        var expectedDecimalSeparator: String = definedDecimalSeparator
        if text.string.contains(definedCurrencyDecimalSeparator) {
            expectedDecimalSeparator = definedCurrencyDecimalSeparator
        }
        
        var digitsAndDecimalSeparators = text.string
            .replacingOccurrences(of: definedDecimalSeparator, with: ".")
            .replacingOccurrences(of: definedCurrencyDecimalSeparator, with: ".")
            .filter { c in
                return CharacterSet.decimalDigits.isMember(character: c) || c == "."
            }
        
        let numberOfOccurencesOfDecimalSeparator = digitsAndDecimalSeparators.numberOfOccurencesOf(".")
        if numberOfOccurencesOfDecimalSeparator > 1 {
            digitsAndDecimalSeparators =
                digitsAndDecimalSeparators
                    .reversed
                    .replacing(".", with: "", maxReplacements: numberOfOccurencesOfDecimalSeparator - 1)
                    .reversed
        }
        
        let components = digitsAndDecimalSeparators.components(separatedBy: ".")
        
        var intStr = components.first ?? ""
        var decStr = components.last ?? ""
        
        intStr = intStr.isEmpty ? "0" : intStr
        decStr = String(decStr.prefix(formatter.maximumFractionDigits))
        
        guard let intNum = NumberFormatter().number(from: intStr), let intMaskFormat = formatter.string(from: intNum)
        else {
            return try! Mask.getOrCreate(withFormat: "[…]")
        }
        
        let intZero: Bool = intNum.isEqual(to: 0)
        customNotations = [
            Notation(
                character: "1",
                characterSet: CharacterSet(charactersIn: "123456789"),
                isOptional: false
            )
        ]
        
        var maskFormat = ""
        var first = true
        intMaskFormat.forEach { char in
            if CharacterSet.decimalDigits.isMember(character: char) {
                if first && !intZero {
                    maskFormat += "[1]"
                    first = false
                } else {
                    maskFormat += "[0]"
                }
            } else {
                maskFormat += "{\(char)}"
            }
        }
        
        if numberOfOccurencesOfDecimalSeparator > 0 {
            maskFormat += "{\(expectedDecimalSeparator)}"
        }
        
        decStr.forEach { char in
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
}

#endif
