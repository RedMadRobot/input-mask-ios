//
// Project «InputMask»
// Created by Jeorge Taflanidi
//


import Foundation


/**
 ### CaretString
 
 Model object that represents string with current cursor position.
 */
public struct CaretString: CustomDebugStringConvertible, CustomStringConvertible, Equatable {
    
    /**
     Text from the user.
     */
    public let string: String
    
    /**
     Cursor position from the input text field.
     */
    public let caretPosition: String.Index
    
    /**
     When ```Mask``` puts additional characters at caret position, the caret moves in this direction.
     
     Caret usually has a ```.forward``` gravity, unless this ```CaretString``` is a result of deletion/backspacing.
     */
    public let caretGravity: CaretGravity
    
    /**
     Constructor.
     
     - parameter string: text from the user.
     - parameter caretPosition: cursor position from the input text field.
     - parameter caretGravity: caret tends to move in this direction during ```Mask``` insertions at caret position.
     */
    public init(string: String, caretPosition: String.Index, caretGravity: CaretGravity) {
        self.string        = string
        self.caretPosition = caretPosition
        self.caretGravity  = caretGravity
    }

    /**
     Constructor.
     
     Same as the ```init(string:caretPosition:)```, with the caret position equal to the end of the line.
     */
    public init(string: String) {
        self.init(string: string, caretPosition: string.endIndex, caretGravity: CaretGravity.forward)
    }
    
    public var debugDescription: String {
        return "STRING: \(self.string)\nCARET POSITION: \(self.caretPosition)\nCARET GRAVITY: \(self.caretGravity)"
    }
    
    public var description: String {
        return self.debugDescription
    }

    /**
     Creates a reversed ```CaretString``` instance with reversed string and corresponding caret position.
     */
    func reversed() -> CaretString {
        let reversedString:        String       = self.string.reversed
        let caretPositionInt:      Int          = self.string.distanceFromStartIndex(to: self.caretPosition)
        let reversedCaretPosition: String.Index = reversedString.startIndex(offsetBy: self.string.count - caretPositionInt)
        return CaretString(
            string: reversedString,
            caretPosition: reversedCaretPosition,
            caretGravity: self.caretGravity
        )
    }
    
    /**
     When ```Mask``` puts additional characters at caret position, the caret moves in this direction.
     */
    public enum CaretGravity: Equatable {
        /**
         Put additional characters before caret, thus move caret forward.
         */
        case forward
        
        /**
         Put additional characters after caret, thus caret won't move.
         */
        case backward
    }
    
}


public func ==(left: CaretString, right: CaretString) -> Bool {
    return left.caretPosition == right.caretPosition
        && left.string        == right.string
        && left.caretGravity  == right.caretGravity
}
