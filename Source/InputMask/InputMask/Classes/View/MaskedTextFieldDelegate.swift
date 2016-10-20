//
//  MaskedTextFieldDelegate.swift
//  InputMask
//
//  Created by Egor Taflanidi on 17.08.28.
//  Copyright © 28 Heisei Egor Taflanidi. All rights reserved.
//

import Foundation
import UIKit


/**
 ### MaskedTextFieldDelegateListener
 
 Allows clients to obtain value extracted by the mask from user input.
 
 Provides callbacks from listened UITextField.
 */
@objc public protocol MaskedTextFieldDelegateListener: UITextFieldDelegate {
    
    @objc optional func textField(_ textField: UITextField, didExtractValue value: String)
    
}


/**
 ### MaskedTextFieldDelegate
 
 UITextFieldDelegate, which applies masking to the user input.
 
 Might be used as a decorator, which forwards UITextFieldDelegate calls to its own listener.
 */
@IBDesignable
open class MaskedTextFieldDelegate: NSObject, UITextFieldDelegate {
    
    fileprivate var _maskFormat:            String
    fileprivate var _autocomplete:          Bool
    fileprivate var _autocompleteOnFocus:   Bool
    
    public var mask: Mask
    
    @IBInspectable open var maskFormat: String {
        get {
            return self._maskFormat
        }
        
        set(newFormat) {
            self._maskFormat = newFormat
            self.mask        = try! Mask.getOrCreate(withFormat: newFormat)
        }
    }
    
    @IBInspectable open var autocomplete: Bool {
        get {
            return self._autocomplete
        }
        
        set(newAutocomplete) {
            self._autocomplete = newAutocomplete
        }
    }
    
    @IBInspectable open var autocompleteOnFocus: Bool {
        get {
            return self._autocompleteOnFocus
        }
        
        set(newAutocompleteOnFocus) {
            self._autocompleteOnFocus = newAutocompleteOnFocus
        }
    }
    
    open var listener: MaskedTextFieldDelegateListener?
    
    public init(format: String) {
        self._maskFormat = format
        self.mask = try! Mask.getOrCreate(withFormat: format)
        self._autocomplete = false
        self._autocompleteOnFocus = false
        super.init()
    }
    
    public override convenience init() {
        self.init(format: "")
    }
    
    open func put(text: String, into field: UITextField) {
        let result: Mask.Result = self.mask.apply(
            toText: CaretString(
                string: text,
                caretPosition: text.endIndex
            ),
            autocomplete: self._autocomplete
        )
        
        field.text = result.formattedText.string
        
        let position: Int =
            result.formattedText.string.distance(from: result.formattedText.string.startIndex, to: result.formattedText.caretPosition)
        
        self.setCaretPosition(position, inField: field)
        self.listener?.textField?(field, didExtractValue: result.extractedValue)
    }
    
    // MARK: - UITextFieldDelegate
    
    open func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String) -> Bool {
        
        let extractedValue: String
        
        if isDeletion(
            inRange: range,
            string: string
        ) {
            extractedValue = self.deleteText(inRange: range, inField: textField)
        } else {
            extractedValue = self.modifyText(inRange: range, inField: textField, withText: string)
        }
        
        self.listener?.textField?(textField, didExtractValue: extractedValue)
        let _ = self.listener?.textField?(textField, shouldChangeCharactersIn: range, replacementString: string)
        return false
    }
    
    open func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return self.listener?.textFieldShouldBeginEditing?(textField) ?? true
    }
    
    open func textFieldDidBeginEditing(_ textField: UITextField) {
        if self._autocompleteOnFocus && textField.text!.isEmpty {
            let _ = self.textField(
                textField,
                shouldChangeCharactersIn: NSMakeRange(0, 0),
                replacementString: ""
            )
        }
        self.listener?.textFieldDidBeginEditing?(textField)
    }
    
    open func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return self.listener?.textFieldShouldEndEditing?(textField) ?? true
    }
    
    open func textFieldDidEndEditing(_ textField: UITextField) {
        self.listener?.textFieldDidEndEditing?(textField)
    }
    
    open func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return self.listener?.textFieldShouldClear?(textField) ?? true
    }
    
    open func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return self.listener?.textFieldShouldReturn?(textField) ?? true
    }
    
}

private extension MaskedTextFieldDelegate {
    
    func isDeletion(inRange range: NSRange, string: String) -> Bool {
        return 0 < range.length && 0 == string.characters.count
    }
    
    func deleteText(
        inRange range: NSRange,
        inField field: UITextField
    ) -> String {
        let text: String = self.replaceCharacters(
            inText: field.text,
            range: range,
            withCharacters: ""
        )
        
        let result: Mask.Result = self.mask.apply(
            toText: CaretString(
                string: text,
                caretPosition: text.index(text.startIndex, offsetBy: range.location)
            ),
            autocomplete: false
        )
        
        field.text = result.formattedText.string
        self.setCaretPosition(range.location, inField: field)
        
        return result.extractedValue
    }
    
    func modifyText(
        inRange range: NSRange,
        inField field: UITextField,
        withText text: String
    ) -> String {
        let updatedText: String = self.replaceCharacters(
            inText: field.text,
            range: range,
            withCharacters: text
        )
        
        let result: Mask.Result = self.mask.apply(
            toText: CaretString(
                string: updatedText,
                caretPosition: updatedText.index(updatedText.startIndex, offsetBy: self.caretPosition(inField: field) + text.characters.count)
            ),
            autocomplete: self._autocomplete
        )
        
        field.text = result.formattedText.string
        let position: Int =
            result.formattedText.string.distance(from: result.formattedText.string.startIndex, to: result.formattedText.caretPosition)
        self.setCaretPosition(position, inField: field)
        
        return result.extractedValue
    }
    
    func replaceCharacters(inText text: String?, range: NSRange, withCharacters newText: String) -> String {
        if let text = text {
            if 0 < range.length {
                let result = NSMutableString(string: text)
                result.replaceCharacters(in: range, with: newText)
                return result as String
            } else {
                let result = NSMutableString(string: text)
                result.insert(newText, at: range.location)
                return result as String
            }
        } else {
            return ""
        }
    }
    
    func caretPosition(inField field: UITextField) -> Int {
        // Workaround for non-optional `field.beginningOfDocument`, which could actually be nil if field doesn't have focus
        guard field.isFirstResponder
        else {
            return field.text?.characters.count ?? 0
        }
        
        if let range: UITextRange = field.selectedTextRange {
            let selectedTextLocation: UITextPosition = range.start
            return field.offset(from: field.beginningOfDocument, to: selectedTextLocation)
        } else {
            return 0
        }
    }
    
    func setCaretPosition(_ position: Int, inField field: UITextField) {
        // Workaround for non-optional `field.beginningOfDocument`, which could actually be nil if field doesn't have focus
        guard field.isFirstResponder
        else {
            return
        }

        if position > field.text!.characters.count {
            return
        }
        
        let from: UITextPosition = field.position(from: field.beginningOfDocument, offset: position)!
        let to:   UITextPosition = field.position(from: from, offset: 0)!
        field.selectedTextRange = field.textRange(from: from, to: to)
    }
    
}
