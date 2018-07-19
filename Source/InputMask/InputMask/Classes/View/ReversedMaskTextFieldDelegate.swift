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
            withFormat: maskFormat.reversedFormat(),
            customNotations: customNotations
        )
    }
    
    override open func put(text: String, into field: UITextField) {
        let reversedText = String(text.reversed())
        let result: Mask.Result = reversedMask.apply(
            toText: CaretString(
                string: reversedText,
                caretPosition: reversedText.endIndex
            ),
            autocomplete: autocomplete
        )
        
        field.text = String(result.formattedText.string.reversed())
        field.caretPosition = result.formattedText.string.distance(
            from: result.formattedText.string.startIndex,
            to: result.formattedText.caretPosition
        )
        
        listener?.textField?(
            field,
            didFillMandatoryCharacters: result.complete,
            didExtractValue: result.extractedValue
        )
    }
    
    override open func deleteText(inRange range: NSRange, inTextInput field: UITextInput) -> Mask.Result {
        let text: String = replaceCharacters(
            inText: field.allText,
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
        
        field.allText = String(result.formattedText.string.reversed())
        field.caretPosition = range.location
        
        return result
    }
    
    override open func modifyText(
        inRange range: NSRange,
        inTextInput field: UITextInput,
        withText text: String
    ) -> Mask.Result {
        let updatedText: String = replaceCharacters(
            inText: field.allText,
            range: range,
            withCharacters: text
        )
        
        let reversedText: String = String(updatedText.reversed())
        let reversedCaretPosition: String.Index = reversedText.index(reversedText.endIndex, offsetBy: -(field.caretPosition + text.count))
        
        let result: Mask.Result = mask.apply(
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
        
        field.allText = reversedResultText
        field.caretPosition = reversedResultText.distance(from: reversedResultText.startIndex, to: reversedResultCaretPosition)
        
        return result
    }
    
    override open func textFieldShouldClear(_ textField: UITextField) -> Bool {
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
