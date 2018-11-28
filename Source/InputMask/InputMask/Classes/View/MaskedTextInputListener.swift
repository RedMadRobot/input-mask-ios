//
// Project «InputMask»
// Created by Jeorge Taflanidi
//


import Foundation
import UIKit


@available(iOS 11, *)
public protocol OnMaskedTextChangedListener: AnyObject {
    func textInput(_ textInput: UITextInput, didExtractValue: String, didFillMandatoryCharacters: Bool)
}


@available(iOS 11, *)
@IBDesignable
open class MaskedTextInputListener: NSObject {

    open weak var listener: OnMaskedTextChangedListener?
    open var onMaskedTextChangedCallback: ((_ textInput: UITextInput, _ value: String, _ complete: Bool) -> ())?

    @IBInspectable open var primaryMaskFormat: String
    @IBInspectable open var autocomplete: Bool
    @IBInspectable open var autocompleteOnFocus: Bool

    open var affineFormats: [String]
    open var affinityCalculationStrategy: AffinityCalculationStrategy
    open var customNotations: [Notation]
    
    open var primaryMask: Mask {
        return try! Mask.getOrCreate(withFormat: primaryMaskFormat, customNotations: customNotations)
    }
    
    public init(
        primaryFormat: String = "",
        autocomplete: Bool = true,
        autocompleteOnFocus: Bool = true,
        affineFormats: [String] = [],
        affinityCalculationStrategy: AffinityCalculationStrategy = .wholeString,
        customNotations: [Notation] = [],
        onMaskedTextChangedCallback: ((_ textInput: UITextInput, _ value: String, _ complete: Bool) -> ())? = nil
    ) {
        self.primaryMaskFormat = primaryFormat
        self.autocomplete = autocomplete
        self.autocompleteOnFocus = autocompleteOnFocus
        self.affineFormats = affineFormats
        self.affinityCalculationStrategy = affinityCalculationStrategy
        self.customNotations = customNotations
        self.onMaskedTextChangedCallback = onMaskedTextChangedCallback
        super.init()
    }
    
    public override convenience init() {
        // Interface Builder support
        self.init(primaryFormat: "")
    }
    
    /**
     Maximal length of the text inside the field.
     
     - returns: Total available count of mandatory and optional characters inside the text field.
     */
    open var placeholder: String {
        return primaryMask.placeholder
    }
    
    /**
     Minimal length of the text inside the field to fill all mandatory characters in the mask.
     
     - returns: Minimal satisfying count of characters inside the text field.
     */
    open var acceptableTextLength: Int {
        return primaryMask.acceptableTextLength
    }
    
    /**
     Maximal length of the text inside the field.
     
     - returns: Total available count of mandatory and optional characters inside the text field.
     */
    open var totalTextLength: Int {
        return primaryMask.totalTextLength
    }
    
    /**
     Minimal length of the extracted value with all mandatory characters filled.
     
     - returns: Minimal satisfying count of characters in extracted value.
     */
    open var acceptableValueLength: Int {
        return primaryMask.acceptableValueLength
    }
    
    /**
     Maximal length of the extracted value.
     
     - returns: Total available count of mandatory and optional characters for extracted value.
     */
    open var totalValueLength: Int {
        return primaryMask.totalValueLength
    }

    @discardableResult
    open func put(text: String, into field: UITextInput, autocomplete putAutocomplete: Bool? = nil) -> Mask.Result {
        let autocomplete: Bool = putAutocomplete ?? self.autocomplete
        let mask: Mask = pickMask(forText: CaretString(string: text), autocomplete: autocomplete)

        let result: Mask.Result = mask.apply(
            toText: CaretString(string: text, caretPosition: text.endIndex),
            autocomplete: autocomplete
        )

        field.allText = result.formattedText.string
        field.caretPosition = result.formattedText.string.distance(
            from: result.formattedText.string.startIndex,
            to: result.formattedText.caretPosition
        )

        notifyOnMaskedTextChangedListeners(forTextInput: field, result: result)
        return result
    }
    
    @discardableResult
    open func textInput(
        _ textInput: UITextInput,
        isChangingCharactersIn range: NSRange,
        replacementString string: String
    ) -> Mask.Result {
        if isDeletion(inRange: range, string: string, field: textInput) {
            return deleteText(inRange: range, inTextInput: textInput)
        } else {
            return modifyText(inRange: range, inTextInput: textInput, withText: string)
        }
    }
    
    open func isDeletion(inRange range: NSRange, string: String, field: UITextInput) -> Bool {
        let isDeletion = 0 < range.length && 0 == string.count
        if field is UITextView {
            // UITextView edge case
            return isDeletion || (0 == range.length && 0 == range.location && 0 == string.count)
        }
        return isDeletion
    }
    
    open func deleteText(inRange range: NSRange, inTextInput field: UITextInput) -> Mask.Result {
        let updatedText: String = replaceCharacters(inText: field.allText, range: range, withCharacters: "")
        let caretPosition: String.Index = updatedText.index(updatedText.startIndex, offsetBy: range.location)

        let mask: Mask = pickMask(
            forText: CaretString(string: updatedText, caretPosition: caretPosition),
            autocomplete: false
        )

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
            offsetBy: range.location + text.count
        )
        
        let mask: Mask = pickMask(
            forText: CaretString(string: updatedText, caretPosition: caretPosition),
            autocomplete: autocomplete
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
    
    open func replaceCharacters(inText text: String, range: NSRange, withCharacters newText: String) -> String {
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
    
    open func pickMask(forText text: CaretString, autocomplete: Bool) -> Mask {
        guard !affineFormats.isEmpty
        else { return primaryMask }

        let primaryAffinity: Int = affinityCalculationStrategy.calculateAffinity(ofMask: primaryMask, forText: text, autocomplete: autocomplete)
        
        var masksAndAffinities: [MaskAndAffinity] = affineFormats.map { (affineFormat: String) -> MaskAndAffinity in
            let mask = try! Mask.getOrCreate(withFormat: affineFormat, customNotations: customNotations)
            let affinity = affinityCalculationStrategy.calculateAffinity(ofMask: mask, forText: text, autocomplete: autocomplete)
            return MaskAndAffinity(mask: mask, affinity: affinity)
        }.sorted { (left: MaskAndAffinity, right: MaskAndAffinity) -> Bool in
            return left.affinity > right.affinity
        }
        
        var insertIndex: Int = -1

        for (index, maskAndAffinity) in masksAndAffinities.enumerated() {
            if primaryAffinity >= maskAndAffinity.affinity {
                insertIndex = index
                break
            }
        }
        
        if (insertIndex >= 0) {
            masksAndAffinities.insert(MaskAndAffinity(mask: primaryMask, affinity: primaryAffinity), at: insertIndex)
        } else {
            masksAndAffinities.append(MaskAndAffinity(mask: primaryMask, affinity: primaryAffinity))
        }
        
        return masksAndAffinities.first!.mask
    }
    
    open func notifyOnMaskedTextChangedListeners(forTextInput textInput: UITextInput, result: Mask.Result) {
        listener?.textInput(textInput, didExtractValue: result.extractedValue, didFillMandatoryCharacters: result.complete)
        onMaskedTextChangedCallback?(textInput, result.extractedValue, result.complete)
    }

    private struct MaskAndAffinity {
        let mask: Mask
        let affinity: Int
    }

    /**
     Workaround to support Interface Builder delegate outlets.

     Allows assigning ```MaskedTextFieldDelegate.listener``` within the Interface Builder.

     Consider using ```MaskedTextFieldDelegate.listener``` property from your source code instead of
     ```MaskedTextFieldDelegate.delegate``` outlet.
     */
    @IBOutlet public var delegate: NSObject? {
        get {
            return self.listener as? NSObject
        }

        set(newDelegate) {
            if let listener = newDelegate as? OnMaskedTextChangedListener {
                self.listener = listener
            }
        }
    }

}


@available(iOS 11, *)
extension MaskedTextInputListener: UITextFieldDelegate {

    public func textFieldDidBeginEditing(_ textField: UITextField) {
        if autocompleteOnFocus && (textField.text ?? "").isEmpty {
            let result: Mask.Result = put(text: "", into: textField, autocomplete: true)
            notifyOnMaskedTextChangedListeners(forTextInput: textField, result: result)
        }
    }

    public func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        let result: Mask.Result = textInput(textField, isChangingCharactersIn: range, replacementString: string)
        notifyOnMaskedTextChangedListeners(forTextInput: textField, result: result)
        return false
    }

    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        let result: Mask.Result = put(text: "", into: textField, autocomplete: false)
        notifyOnMaskedTextChangedListeners(forTextInput: textField, result: result)
        return true
    }

}


@available(iOS 11, *)
extension MaskedTextInputListener: UITextViewDelegate {

    public func textViewDidBeginEditing(_ textView: UITextView) {
        if autocompleteOnFocus && textView.text.isEmpty {
            let result: Mask.Result = put(text: "", into: textView, autocomplete: true)
            notifyOnMaskedTextChangedListeners(forTextInput: textView, result: result)
        }
    }

    public func textView(
        _ textView: UITextView,
        shouldChangeTextIn range: NSRange,
        replacementText text: String
    ) -> Bool {
        let result: Mask.Result = textInput(textView, isChangingCharactersIn: range, replacementString: text)
        notifyOnMaskedTextChangedListeners(forTextInput: textView, result: result)
        return false
    }

}
