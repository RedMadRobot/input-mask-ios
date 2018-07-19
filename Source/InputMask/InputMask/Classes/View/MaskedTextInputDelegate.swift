//
// Project «InputMask»
// Created by Jeorge Taflanidi
//


import Foundation
import UIKit


/**
 ### MaskedTextInputDelegate
 
 Common logic for masking UITextFieldDelegate and UITextViewDelegate.
 */
@IBDesignable
open class MaskedTextInputDelegate: NSObject {
    
    @IBInspectable public var maskFormat: String
    @IBInspectable public var autocomplete: Bool

    public var customNotations: [Notation]

    public var mask: Mask {
        return try! Mask.getOrCreate(withFormat: maskFormat, customNotations: customNotations)
    }

    public init(format: String) {
        self.maskFormat = format
        self.autocomplete = false
        self.customNotations = []
        super.init()
    }

    public override convenience init() {
        self.init(format: "")
    }

    /**
     Maximal length of the text inside the field.

     - returns: Total available count of mandatory and optional characters inside the text field.
     */
    open func placeholder() -> String {
        return mask.placeholder
    }

    /**
     Minimal length of the text inside the field to fill all mandatory characters in the mask.

     - returns: Minimal satisfying count of characters inside the text field.
     */
    open func acceptableTextLength() -> Int {
        return mask.acceptableTextLength
    }

    /**
     Maximal length of the text inside the field.

     - returns: Total available count of mandatory and optional characters inside the text field.
     */
    open func totalTextLength() -> Int {
        return mask.totalTextLength
    }

    /**
     Minimal length of the extracted value with all mandatory characters filled.

     - returns: Minimal satisfying count of characters in extracted value.
     */
    open func acceptableValueLength() -> Int {
        return mask.acceptableValueLength
    }

    /**
     Maximal length of the extracted value.

     - returns: Total available count of mandatory and optional characters for extracted value.
     */
    open func totalValueLength() -> Int {
        return mask.totalValueLength
    }

    open func put(text: String, into field: UITextInput) -> Mask.Result {
        let result: Mask.Result = mask.apply(
            toText: CaretString(
                string: text,
                caretPosition: text.endIndex
            ),
            autocomplete: autocomplete
        )

        field.allText = result.formattedText.string
        field.caretPosition = result.formattedText.string.distance(
            from: result.formattedText.string.startIndex,
            to: result.formattedText.caretPosition
        )

        return result
    }

    open func textInput(
        _ textInput: UITextInput,
        isChangingCharactersIn range: NSRange,
        replacementString string: String
    ) -> Mask.Result {
        if isDeletion(inRange: range, string: string) {
            return deleteText(inRange: range, inTextInput: textInput)
        } else {
            return modifyText(inRange: range, inTextInput: textInput, withText: string)
        }
    }

    open func isDeletion(inRange range: NSRange, string: String) -> Bool {
        return 0 < range.length && 0 == string.count
    }

    open func deleteText(inRange range: NSRange, inTextInput field: UITextInput) -> Mask.Result {
        let updatedText: String = replaceCharacters(inText: field.allText, range: range, withCharacters: "")
        let caretPosition: String.Index = updatedText.index(updatedText.startIndex, offsetBy: range.location)

        let result: Mask.Result = mask.apply(
            toText: CaretString(string: updatedText, caretPosition: caretPosition),
            autocomplete: false
        )

        field.allText = result.formattedText.string
        field.caretPosition = range.location

        return result
    }

    open func modifyText(inRange range: NSRange, inTextInput field: UITextInput, withText text: String) -> Mask.Result {
        let updatedText: String = replaceCharacters(inText: field.allText, range: range, withCharacters: text)
        let caretPosition: String.Index = updatedText.index(
            updatedText.startIndex,
            offsetBy: field.caretPosition + text.count
        )

        let result: Mask.Result = mask.apply(
            toText: CaretString(string: updatedText, caretPosition: caretPosition),
            autocomplete: autocomplete
        )

        field.allText = result.formattedText.string
        field.caretPosition = result.formattedText.string.distance(
            from: result.formattedText.string.startIndex,
            to: result.formattedText.caretPosition
        )

        return result
    }

    func replaceCharacters(inText text: String, range: NSRange, withCharacters newText: String) -> String {
        if 0 < range.length {
            let result = NSMutableString(string: text)
            result.replaceCharacters(in: range, with: newText)
            return result as String
        } else {
            let result = NSMutableString(string: text)
            result.insert(newText, at: range.location)
            return result as String
        }
    }
    
}
