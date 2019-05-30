//
// Project «InputMask»
// Created by Jeorge Taflanidi
//


import Foundation


/**
 ### AffinityCalculationStrategy
 
 Allows to opt for a different mask picking algorithm in text field listeners.
 */
public enum AffinityCalculationStrategy {
    /**
     Default strategy.
     
     Uses ```Mask``` built-in mechanism to calculate total affinity between the text and the mask format.
     
     For example:
     ```
     format: [00].[00]
     
     input1: 1234
     input2: 12.34
     input3: 1.234
     
     affinity1 = 4 (symbols) - 1 (missed dot)                       = 3
     affinity2 = 5 (symbols)                                        = 5
     affinity3 = 5 (symbols) - 1 (superfluous dot) - 1 (missed dot) = 3
     ```
     */
    case wholeString
    
    /**
     Finds the longest common prefix between the original text and the same text after applying the mask.
     
     For example:
     ```
     format1: +7 [000] [000]
     format2: 8 [000] [000]
     
     input: +7 12 345
     affinity1 = 5
     affinity2 = 0
     
     input: 8 12 345
     affinity1 = 0
     affinity2 = 4
     ```
     */
    case prefix
    
    /**
     Affinity is tolerance between the length of the input and the total amount of text current mask can accomodate.
     
     If current mask can't accomodate all the text, the affinity equals `Int.min`.
     
     For example:
     ```
     format1: [000]
     format2: [00000]
     format3: [0000000]
     
     input          affinity1    affinity2    affinity3
     1              -2           -4           -6
     12             -1           -3           -5
     123            0            -2           -4
     1234           Int.min      -1           -3
     12345          Int.min      0            -2
     123456         Int.min      Int.min      -1
     ```
     
     This affinity calculation strategy comes in handy when the mask format radically changes depending on the input
     length.
     
     N.B.: Make sure the widest mask format is the primary mask format.
     */
    case capacity
    
    public func calculateAffinity(
        ofMask mask: Mask,
        forText text: CaretString,
        autocomplete: Bool
    ) -> Int {
        switch self {
            case .wholeString:
                return mask.apply(
                    toText: text,
                    autocomplete: autocomplete
                ).affinity
            case .prefix:
                return mask.apply(
                    toText: text,
                    autocomplete: autocomplete
                ).formattedText.string.prefixIntersection(with: text.string).count
            case .capacity:
                let textLength: Int = text.string.count
                if textLength > mask.totalTextLength {
                    return Int.min
                } else {
                    return textLength - mask.totalTextLength
                }
        }
    }
}
