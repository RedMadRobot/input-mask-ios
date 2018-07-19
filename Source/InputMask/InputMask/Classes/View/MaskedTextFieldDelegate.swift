//
// Project «InputMask»
// Created by Jeorge Taflanidi
//


import Foundation
import UIKit


/**
 ### MaskedTextFieldDelegateListener
 
 Allows clients to obtain value extracted by the mask from user input.
 
 Provides callbacks from listened UITextField.
 */
@objc public protocol MaskedTextFieldDelegateListener: UITextFieldDelegate {
    
    /**
     Callback to return extracted value and to signal whether the user has complete input.
     */
    @objc optional func textField(
        _ textField: UITextField,
        didFillMandatoryCharacters complete: Bool,
        didExtractValue value: String
    )
    
}


/**
 ### MaskedTextFieldDelegate
 
 UITextFieldDelegate, which applies masking to the user input.
 
 Might be used as a decorator, which forwards UITextFieldDelegate calls to its own listener.
 */
@IBDesignable
open class MaskedTextFieldDelegate: MaskedTextInputDelegate, UITextFieldDelegate {

    @IBInspectable public var autocompleteOnFocus: Bool

    open weak var listener: MaskedTextFieldDelegateListener?

    public override init(format: String) {
        self.autocompleteOnFocus = false
        super.init(format: format)
    }

    open func put(text: String, into field: UITextField) {
        let result: Mask.Result = put(text: text, into: field)
        listener?.textField?(field, didFillMandatoryCharacters: result.complete, didExtractValue: result.extractedValue)
    }

    // MARK: - UITextFieldDelegate

    open func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return listener?.textFieldShouldBeginEditing?(textField) ?? true
    }

    open func textFieldDidBeginEditing(_ textField: UITextField) {
        if autocompleteOnFocus && textField.text!.isEmpty {
            let _ = self.textField(
                textField,
                shouldChangeCharactersIn: NSMakeRange(0, 0),
                replacementString: ""
            )
        }
        listener?.textFieldDidBeginEditing?(textField)
    }
    
    open func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        let result = textInput(textField, isChangingCharactersIn: range, replacementString: string)
        listener?.textField?(
            textField,
            didFillMandatoryCharacters: result.complete,
            didExtractValue: result.extractedValue
        )
        let _ = listener?.textField?(textField, shouldChangeCharactersIn: range, replacementString: string)
        return false
    }
    
    open func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return listener?.textFieldShouldEndEditing?(textField) ?? true
    }
    
    open func textFieldDidEndEditing(_ textField: UITextField) {
        listener?.textFieldDidEndEditing?(textField)
    }
    
    open func textFieldShouldClear(_ textField: UITextField) -> Bool {
        let shouldClear: Bool = listener?.textFieldShouldClear?(textField) ?? true
        if shouldClear {
            let result: Mask.Result = mask.apply(
                toText: CaretString(string: "", caretPosition: "".endIndex),
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
    
    open func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return listener?.textFieldShouldReturn?(textField) ?? true
    }
    
}
