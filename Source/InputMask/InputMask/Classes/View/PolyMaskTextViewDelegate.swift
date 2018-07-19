//
// Project «InputMask»
// Created by Jeorge Taflanidi
//


import Foundation
import UIKit


/**
 ### PolyMaskTextViewDelegate
 
 UITextViewDelegate, which applies masking to the user input, picking the most suitable mask for the text.
 
 Might be used as a decorator, which forwards UITextViewDelegate calls to its own listener.
 */
@IBDesignable
open class PolyMaskTextViewDelegate: MaskedTextViewDelegate {
    
    public var affineFormats: [String]
    
    public init(primaryFormat: String, affineFormats: [String]) {
        self.affineFormats = affineFormats
        super.init(format: primaryFormat)
    }
    
    public override init(format: String) {
        self.affineFormats = []
        super.init(format: format)
    }
    
    open override func put(text: String, into field: UITextInput) -> Mask.Result {
        let mask: Mask = pickMask(
            forText: text,
            caretPosition: text.endIndex,
            autocomplete: autocomplete
        )
        
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
    
    override open func deleteText(inRange range: NSRange, inTextInput field: UITextInput) -> Mask.Result {
        let text: String = replaceCharacters(
            inText: field.allText,
            range: range,
            withCharacters: ""
        )
        
        let mask: Mask = pickMask(
            forText: text,
            caretPosition: text.index(text.startIndex, offsetBy: range.location),
            autocomplete: false
        )
        
        let result: Mask.Result = mask.apply(
            toText: CaretString(
                string: text,
                caretPosition: text.index(text.startIndex, offsetBy: range.location)
            ),
            autocomplete: false
        )
        
        field.allText = result.formattedText.string
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
        
        let mask: Mask = pickMask(
            forText: updatedText,
            caretPosition: updatedText.index(updatedText.startIndex, offsetBy: field.caretPosition + text.count),
            autocomplete: autocomplete
        )
        
        let result: Mask.Result = mask.apply(
            toText: CaretString(
                string: updatedText,
                caretPosition: updatedText.index(updatedText.startIndex, offsetBy: field.caretPosition + text.count)
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
    
    func pickMask(forText text: String, caretPosition: String.Index, autocomplete: Bool) -> Mask {
        let primaryAffinity: Int = calculateAffinity(
            ofMask: mask,
            forText: text,
            caretPosition: caretPosition,
            autocomplete: autocomplete
        )
        
        var masks: [(Mask, Int)] = affineFormats.map { (affineFormat: String) -> (Mask, Int) in
            let mask:     Mask = try! Mask.getOrCreate(withFormat: affineFormat, customNotations: customNotations)
            let affinity: Int  = calculateAffinity(
                ofMask: mask,
                forText: text,
                caretPosition: caretPosition,
                autocomplete: autocomplete
            )
            
            return (mask, affinity)
        }
        
        masks.sort { (left: (Mask, Int), right: (Mask, Int)) -> Bool in
            return left.1 > right.1
        }
        
        var insertIndex: Int = -1
        
        for (index, maskAffinity) in masks.enumerated() {
            if primaryAffinity >= maskAffinity.1 {
                insertIndex = index
                break
            }
        }
        
        if (insertIndex >= 0) {
            masks.insert((mask, primaryAffinity), at: insertIndex)
        } else {
            masks.append((mask, primaryAffinity))
        }
        
        return masks.first!.0
    }
    
    func calculateAffinity(
        ofMask mask: Mask,
        forText text: String,
        caretPosition: String.Index,
        autocomplete: Bool
    ) -> Int {
        return mask.apply(
            toText: CaretString(
                string: text,
                caretPosition: caretPosition
            ),
            autocomplete: autocomplete
        ).affinity
    }
    
}
