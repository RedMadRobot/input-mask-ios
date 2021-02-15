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
open class MaskedTextViewDelegate: NSObject, UITextViewDelegate {
    
    open weak var listener: MaskedTextViewDelegateListener?
    open var onMaskedTextChangedCallback: ((_ textField: UITextView, _ value: String, _ complete: Bool) -> ())?

    @IBInspectable open var primaryMaskFormat:   String
    @IBInspectable open var autocomplete:        Bool
    @IBInspectable open var autocompleteOnFocus: Bool
    @IBInspectable open var autoskip:            Bool
    @IBInspectable open var rightToLeft:         Bool
    /**
        Allows input suggestions from keyboard
     */
    @IBInspectable open var allowSuggestions:   Bool
    
    /**
     Shortly after new text is being pasted from the clipboard, ```UITextView``` receives a new value for its
     `selectedTextRange` property from the system. This new range is not consistent with the formatted text and
     calculated cursor position most of the time, yet it's being assigned just after ```set cursorPosition``` call.
     
     To ensure correct cursor position is set, it is assigned asynchronously (presumably after a vanishingly
     small delay), if cursor movement is set to be non-atomic.
     
     Default is ```false```.
     */
    @IBInspectable open var atomicCursorMovement: Bool = false

    open var affineFormats:               [String]
    open var affinityCalculationStrategy: AffinityCalculationStrategy
    open var customNotations:             [Notation]
    
    open var primaryMask: Mask {
        return try! maskGetOrCreate(withFormat: primaryMaskFormat, customNotations: customNotations)
    }
    
    public init(
        primaryFormat: String = "",
        autocomplete: Bool = true,
        autocompleteOnFocus: Bool = true,
        autoskip: Bool = false,
        rightToLeft: Bool = false,
        affineFormats: [String] = [],
        affinityCalculationStrategy: AffinityCalculationStrategy = .wholeString,
        customNotations: [Notation] = [],
        onMaskedTextChangedCallback: ((_ textInput: UITextInput, _ value: String, _ complete: Bool) -> ())? = nil,
        allowSuggestions: Bool = true
    ) {
        self.primaryMaskFormat = primaryFormat
        self.autocomplete = autocomplete
        self.autocompleteOnFocus = autocompleteOnFocus
        self.autoskip = autoskip
        self.rightToLeft = rightToLeft
        self.affineFormats = affineFormats
        self.affinityCalculationStrategy = affinityCalculationStrategy
        self.customNotations = customNotations
        self.onMaskedTextChangedCallback = onMaskedTextChangedCallback
        self.allowSuggestions = allowSuggestions
        super.init()
    }
    
    public override init() {
        /**
         Interface Builder support
         
         https://developer.apple.com/documentation/xcode_release_notes/xcode_10_2_release_notes/swift_5_release_notes_for_xcode_10_2
         From known issue no.2:
         
         > To reduce the size taken up by Swift metadata, convenience initializers defined in Swift now only allocate an
         > object ahead of time if they’re calling a designated initializer defined in Objective-C. In most cases, this
         > has no effect on your program, but if your convenience initializer is called from Objective-C, the initial
         > allocation from +alloc is released without any initializer being called.
         */
        self.primaryMaskFormat = ""
        self.autocomplete = true
        self.autocompleteOnFocus = true
        self.autoskip = false
        self.rightToLeft = false
        self.affineFormats = []
        self.affinityCalculationStrategy = .wholeString
        self.customNotations = []
        self.onMaskedTextChangedCallback = nil
        self.allowSuggestions = true
        super.init()
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
    open func put(text: String, into textView: UITextView, autocomplete putAutocomplete: Bool? = nil) -> Mask.Result {
        let autocomplete: Bool = putAutocomplete ?? self.autocomplete
        let mask: Mask = pickMask(
            forText: CaretString(
                string: text,
                caretPosition: text.endIndex,
                caretGravity: CaretString.CaretGravity.forward(autocomplete: autocomplete)
            )
        )
        
        let result: Mask.Result = mask.apply(
            toText: CaretString(
                string: text,
                caretPosition: text.endIndex,
                caretGravity: CaretString.CaretGravity.forward(autocomplete: autocomplete)
            )
        )
        
        textView.text = result.formattedText.string
        textView.cursorPosition = result.formattedText.string.distanceFromStartIndex(
            to: result.formattedText.caretPosition
        )
        
        notifyOnMaskedTextChangedListeners(forTextView: textView, result: result)
        return result
    }
    
    open func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return listener?.textViewShouldBeginEditing?(textView) ?? true
    }
    
    open func textViewDidBeginEditing(_ textView: UITextView) {
        if autocompleteOnFocus && textView.text.isEmpty {
            let result: Mask.Result = put(text: "", into: textView, autocomplete: true)
            notifyOnMaskedTextChangedListeners(forTextView: textView, result: result)
        }
        listener?.textViewDidBeginEditing?(textView)
    }
    
    open func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return listener?.textViewShouldEndEditing?(textView) ?? true
    }
    
    open func textViewDidEndEditing(_ textView: UITextView) {
        listener?.textViewDidEndEditing?(textView)
    }
    
    open func textView(
        _ textView: UITextView,
        shouldChangeTextIn range: NSRange,
        replacementText text: String
    ) -> Bool {
        // UITextView edge case
        let updatedText: String = replaceCharacters(inText: textView.text ?? "", range: range, withCharacters: text)
        // https://stackoverflow.com/questions/52131894/shouldchangecharactersin-combined-with-suggested-text
        if (allowSuggestions && text == " " && updatedText == " ") {
            return true
        }
        let isDeletion = (0 < range.length && 0 == text.count) || (0 == range.length && 0 == range.location && 0 == text.count)
        let useAutocomplete = isDeletion ? false : autocomplete
        let useAutoskip = isDeletion ? autoskip : false
        let caretGravity: CaretString.CaretGravity =
            isDeletion ? .backward(autoskip: useAutoskip) : .forward(autocomplete: useAutocomplete)
        
        let caretPositionInt: Int = isDeletion ? range.location : range.location + text.count
        let caretPosition: String.Index = updatedText.startIndex(offsetBy: caretPositionInt)
        let text = CaretString(string: updatedText, caretPosition: caretPosition, caretGravity: caretGravity)
        
        let mask: Mask = pickMask(forText: text)
        let result: Mask.Result = mask.apply(toText: text)
        
        textView.text = result.formattedText.string
        
        if self.atomicCursorMovement {
            textView.cursorPosition = result.formattedText.string.distanceFromStartIndex(
                to: result.formattedText.caretPosition
            )
        } else {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
                textView.cursorPosition = result.formattedText.string.distanceFromStartIndex(
                    to: result.formattedText.caretPosition
                )
            }
        }
        
        notifyOnMaskedTextChangedListeners(forTextView: textView, result: result)
        return false
    }
    
    open func textViewDidChange(_ textView: UITextView) {
        listener?.textViewDidChange?(textView)
    }
    
    open func textViewDidChangeSelection(_ textView: UITextView) {
        listener?.textViewDidChangeSelection?(textView)
    }
    
    @available(iOS 10.0, *)
    open func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return listener?.textView?(textView, shouldInteractWith: URL, in: characterRange, interaction: interaction) ?? true
    }
    
    @available(iOS 10.0, *)
    open func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return listener?.textView?(textView, shouldInteractWith: textAttachment, in: characterRange, interaction: interaction) ?? true
    }
    
    @available(iOS, introduced: 7.0, deprecated: 10.0, message: "Use textView:shouldInteractWithURL:inRange:forInteractionType: instead")
    open func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        return listener?.textView?(textView, shouldInteractWith: URL, in: characterRange) ?? true
    }
    
    @available(iOS, introduced: 7.0, deprecated: 10.0, message: "Use textView:shouldInteractWithTextAttachment:inRange:forInteractionType: instead")
    open func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange) -> Bool {
        return listener?.textView?(textView, shouldInteractWith: textAttachment, in: characterRange) ?? true
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
    
    open func pickMask(forText text: CaretString) -> Mask {
        guard !affineFormats.isEmpty
        else { return primaryMask }
        
        let primaryAffinity: Int = affinityCalculationStrategy.calculateAffinity(ofMask: primaryMask, forText: text, autocomplete: autocomplete)
        
        var masksAndAffinities: [MaskAndAffinity] = affineFormats.map { (affineFormat: String) -> MaskAndAffinity in
            let mask = try! maskGetOrCreate(withFormat: affineFormat, customNotations: customNotations)
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
    
    open func notifyOnMaskedTextChangedListeners(forTextView textView: UITextView, result: Mask.Result) {
        listener?.textView?(textView, didFillMandatoryCharacters: result.complete, didExtractValue: result.extractedValue)
        onMaskedTextChangedCallback?(textView, result.extractedValue, result.complete)
    }

    private func maskGetOrCreate(withFormat format: String, customNotations: [Notation]) throws -> Mask {
        if rightToLeft {
            return try RTLMask.getOrCreate(withFormat: format, customNotations: customNotations)
        }
        return try Mask.getOrCreate(withFormat: format, customNotations: customNotations)
    }
    
    private struct MaskAndAffinity {
        let mask: Mask
        let affinity: Int
    }
    
    /**
     Workaround to support Interface Builder delegate outlets.
     
     Allows assigning ```MaskedTextViewDelegate.listener``` within the Interface Builder.
     
     Consider using ```MaskedTextViewDelegate.listener``` property from your source code instead of
     ```MaskedTextViewDelegate.delegate``` outlet.
     */
    @IBOutlet public var delegate: NSObject? {
        get {
            return self.listener as? NSObject
        }
        
        set(newDelegate) {
            if let listener = newDelegate as? MaskedTextViewDelegateListener {
                self.listener = listener
            }
        }
    }
    
}
