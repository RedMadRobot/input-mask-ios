//
// Project «InputMask»
// Created by Jeorge Taflanidi
//


import Foundation
import UIKit


/**
 ### MaskedTextViewDelegateListener
 
 Allows clients to obtain value extracted by the mask from user input.
 
 Provides callbacks from listened UITextView.
 */
@objc public protocol MaskedTextViewDelegateListener: UITextViewDelegate {
    
    /**
     Callback to return extracted value and to signal whether the user has complete input.
     */
    @objc optional func textView(
        _ textView: UITextView,
        didFillMandatoryCharacters complete: Bool,
        didExtractValue value: String
    )
    
}


/**
 ### MaskedTextViewDelegate
 
 UITextViewDelegate, which applies masking to the user input.
 
 Might be used as a decorator, which forwards UITextViewDelegate calls to its own listener.
 */
@IBDesignable
open class MaskedTextViewDelegate: MaskedTextInputDelegate, UITextViewDelegate {
    
    open weak var listener: MaskedTextViewDelegateListener?
    
    open func put(text: String, into field: UITextView) {
        let result: Mask.Result = put(text: text, into: field)
        listener?.textView?(field, didFillMandatoryCharacters: result.complete, didExtractValue: result.extractedValue)
    }
    
    // MARK: - UITextViewDelegate
    
    open func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return listener?.textViewShouldBeginEditing?(textView) ?? true
    }
    
    open func textViewDidBeginEditing(_ textView: UITextView) {
        listener?.textViewDidBeginEditing?(textView)
    }
    
    open func textView(
        _ textView: UITextView,
        shouldChangeTextIn range: NSRange,
        replacementText string: String
    ) -> Bool {
        let result = textInput(textView, isChangingCharactersIn: range, replacementString: string)
        listener?.textView?(
            textView,
            didFillMandatoryCharacters: result.complete,
            didExtractValue: result.extractedValue
        )
        let _ = listener?.textView?(textView, shouldChangeTextIn: range, replacementText: string)
        return false
    }
    
    open func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return listener?.textViewShouldEndEditing?(textView) ?? true
    }
    
    open func textViewDidEndEditing(_ textView: UITextView) {
        listener?.textViewDidEndEditing?(textView)
    }
    
    open func textViewDidChange(_ textView: UITextView) {
        listener?.textViewDidChange?(textView)
    }
    
    open func textViewDidChangeSelection(_ textView: UITextView) {
        listener?.textViewDidChangeSelection?(textView)
    }
    
    @available(iOS 10.0, *)
    open func textView(
        _ textView: UITextView,
        shouldInteractWith URL: URL,
        in characterRange: NSRange,
        interaction: UITextItemInteraction
    ) -> Bool {
        return listener?.textView?(textView, shouldInteractWith: URL, in: characterRange, interaction: interaction) ?? true
    }
    
    @available(iOS 10.0, *)
    open func textView(
        _ textView: UITextView,
        shouldInteractWith textAttachment: NSTextAttachment,
        in characterRange: NSRange,
        interaction: UITextItemInteraction
    ) -> Bool {
        return listener?.textView?(textView, shouldInteractWith: textAttachment, in: characterRange, interaction: interaction) ?? true
    }
    
    @available(iOS, introduced: 7.0, deprecated: 10.0, message: "Use textView:shouldInteractWithURL:inRange:forInteractionType: instead")
    open func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        return listener?.textView?(textView, shouldInteractWith: URL, in: characterRange) ?? true
    }
    
    @available(iOS, introduced: 7.0, deprecated: 10.0, message: "Use textView:shouldInteractWithTextAttachment:inRange:forInteractionType: instead")
    open func textView(
        _ textView: UITextView,
        shouldInteractWith textAttachment: NSTextAttachment,
        in characterRange: NSRange
    ) -> Bool {
        return listener?.textView?(textView, shouldInteractWith: textAttachment, in: characterRange) ?? true
    }
    
    open override func isDeletion(inRange range: NSRange, string: String) -> Bool {
        // UITextView edge case, making autocomplete on focus feature impossible:
        return super.isDeletion(inRange: range, string: string) || (0 == range.length && 0 == range.location && 0 == string.count)
    }
    
}
