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
            withFormat: self.maskFormat.reversedFormat(),
            customNotations: customNotations
        )
    }
    
    override open func put(text: String, into field: UITextField) {
        let reversedText = String(text.reversed())
        let result: Mask.Result = self.reversedMask.apply(
            toText: CaretString(
                string: reversedText,
                caretPosition: reversedText.endIndex
            ),
            autocomplete: self.autocomplete
        )
        
        field.text = String(result.formattedText.string.reversed())
        
        let position: Int =
            result.formattedText.string.distance(from: result.formattedText.string.startIndex, to: result.formattedText.caretPosition)
        
        self.setCaretPosition(position, inField: field)
        self.listener?.textField?(
            field,
            didFillMandatoryCharacters: result.complete,
            didExtractValue: result.extractedValue
        )
    }
    
    override open func deleteText(
        inRange range: NSRange,
        inField field: UITextField
    ) -> (String, Bool) {
        let text: String = self.replaceCharacters(
            inText: field.text,
            range: range,
            withCharacters: ""
        )
        
        let reversedText: String = String(text.reversed())
        let reversedCaretPosition: String.Index = reversedText.index(reversedText.endIndex, offsetBy: -range.location)
        
        let result: Mask.Result = self.reversedMask.apply(
            toText: CaretString(
                string: reversedText,
                caretPosition: reversedCaretPosition
            ),
            autocomplete: false
        )
        
        field.text = String(result.formattedText.string.reversed())
        self.setCaretPosition(range.location, inField: field)
        
        return (result.extractedValue, result.complete)
    }
    
    override open func modifyText(
        inRange range: NSRange,
        inField field: UITextField,
        withText text: String
    ) -> (String, Bool) {
        let updatedText: String = self.replaceCharacters(
            inText: field.text,
            range: range,
            withCharacters: text
        )
        
        let reversedText: String = String(updatedText.reversed())
        let reversedCaretPosition: String.Index = reversedText.index(reversedText.endIndex, offsetBy: -(self.caretPosition(inField: field) + text.count))
        
        let result: Mask.Result = self.mask.apply(
            toText: CaretString(
                string: reversedText,
                caretPosition: reversedCaretPosition
            ),
            autocomplete: self.autocomplete
        )
        
        let formattedText = result.formattedText
        
        let reversedResultText = String(formattedText.string.reversed())
        let reversedResultCaretPosition: String.Index =
            reversedResultText.index(
                reversedResultText.endIndex,
                offsetBy: -(formattedText.string.distance(from: formattedText.string.startIndex, to: formattedText.caretPosition))
            )
        
        field.text = reversedResultText
        let position: Int = reversedResultText.distance(from: reversedResultText.startIndex, to: reversedResultCaretPosition)
        self.setCaretPosition(position, inField: field)
        
        return (result.extractedValue, result.complete)
    }
    
    override open func textFieldShouldClear(_ textField: UITextField) -> Bool {
        let shouldClear: Bool = self.listener?.textFieldShouldClear?(textField) ?? true
        if shouldClear {
            let result: Mask.Result = self.reversedMask.apply(
                toText: CaretString(
                    string: "",
                    caretPosition: "".endIndex
                ),
                autocomplete: self.autocomplete
            )
            self.listener?.textField?(
                textField,
                didFillMandatoryCharacters: result.complete,
                didExtractValue: result.extractedValue
            )
        }
        return shouldClear
    }
    
}
