//
//  ReversedMaskTextFieldDelegate.swift
//  InputMask
//
//  Created by Jeorge Taflanidi on 28.04.2018.
//  Copyright © 2018 Egor Taflanidi. All rights reserved.
//

import Foundation


/**
 ### ReversedMaskTextFieldDelegate
 
 UITextFieldDelegate implementation for text fields with right text alignment.
 */
@IBDesignable
open class ReversedMaskTextFieldDelegate: MaskedTextFieldDelegate {
    
    private var reversedMask: Mask {
        return try! Mask.getOrCreate(
            withFormat: primaryMaskFormat.reversedFormat(),
            customNotations: customNotations
        )
    }
    
    @discardableResult
    open override func put(text: String, into field: UITextField, autocomplete putAutocomplete: Bool? = nil) -> Mask.Result {
        let autocomplete: Bool = putAutocomplete ?? self.autocomplete
        
        let reversedText = String(text.reversed())
        let result: Mask.Result = reversedMask.apply(
            toText: CaretString(
                string: reversedText,
                caretPosition: reversedText.endIndex
            ),
            autocomplete: autocomplete
        )
        
        field.text = String(result.formattedText.string.reversed())
        field.cursorPosition = result.formattedText.string.distance(
            from: result.formattedText.string.startIndex,
            to: result.formattedText.caretPosition
        )
        
        listener?.textField?(
            field,
            didFillMandatoryCharacters: result.complete,
            didExtractValue: result.extractedValue
        )
        return result
    }
    
    @discardableResult
    open override func deleteText(inRange range: NSRange, inTextField field: UITextField) -> Mask.Result {
        let text: String = replaceCharacters(
            inText: field.text ?? "",
            range: range,
            withCharacters: ""
        )
        
        let reversedText: String = String(text.reversed())
        let reversedCaretPosition: String.Index = reversedText.index(reversedText.endIndex, offsetBy: -range.location)
        
        let result: Mask.Result = reversedMask.apply(
            toText: CaretString(
                string: reversedText,
                caretPosition: reversedCaretPosition
            ),
            autocomplete: false
        )
        
        field.text = String(result.formattedText.string.reversed())
        field.cursorPosition = range.location
        
        return result
    }
    
    @discardableResult
    open override func modifyText(inRange range: NSRange, inTextField field: UITextField, withText text: String) -> Mask.Result {
        let updatedText: String = replaceCharacters(
            inText: field.text ?? "",
            range: range,
            withCharacters: text
        )
        
        let reversedText: String = String(updatedText.reversed())
        let reversedCaretPosition: String.Index = reversedText.index(reversedText.endIndex, offsetBy: -(range.location + text.count))
        
        let result: Mask.Result = primaryMask.apply(
            toText: CaretString(
                string: reversedText,
                caretPosition: reversedCaretPosition
            ),
            autocomplete: autocomplete
        )
        
        let formattedText = result.formattedText
        
        let reversedResultText = String(formattedText.string.reversed())
        let reversedResultCaretPosition: String.Index =
            reversedResultText.index(
                reversedResultText.endIndex,
                offsetBy: -(formattedText.string.distance(from: formattedText.string.startIndex, to: formattedText.caretPosition))
            )
        
        field.text = reversedResultText
        field.cursorPosition = reversedResultText.distance(from: reversedResultText.startIndex, to: reversedResultCaretPosition)
        
        return result
    }
    
    open override func textFieldShouldClear(_ textField: UITextField) -> Bool {
        let shouldClear: Bool = listener?.textFieldShouldClear?(textField) ?? true
        if shouldClear {
            let result: Mask.Result = reversedMask.apply(
                toText: CaretString(
                    string: "",
                    caretPosition: "".endIndex
                ),
                autocomplete: autocomplete
            )
            listener?.textField?(
                textField,
                didFillMandatoryCharacters: result.complete,
                didExtractValue: result.extractedValue
            )
        }
        return shouldClear
    }
    
}
