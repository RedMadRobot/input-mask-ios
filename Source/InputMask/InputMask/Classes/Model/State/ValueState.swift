//
// Project «InputMask»
// Created by Jeorge Taflanidi
//


import Foundation


/**
 ### ValueState
 
 Represents mandatory characters in square brackets [].
 
 Accepts only characters of own type (see ```StateType```). Puts accepted characters into the result string.
 
 Returns accepted characters as an extracted value.
 
 - seealso: ```ValueState.StateType```
 */
class ValueState: State {
    
    /**
     ### StateType
     
     * ```numeric``` stands for [9] characters
     * ```literal``` stands for [a] characters
     * ```alphaNumeric``` stands for [-] characters
     */
    enum StateType {
        case numeric
        case literal
        case alphaNumeric
        var characterSet: CharacterSet {
            switch self {
                case .numeric: return CharacterSet.decimalDigits
                case .literal: return CharacterSet.letters
                case .alphaNumeric: return CharacterSet.alphanumerics
            }
        }
    }
    
    let type: StateType
    
        }
    
    func accepts(character char: Character) -> Bool {
        return self.type.characterSet.isMember(character: char)
    }
    
    override func accept(character char: Character) -> Next? {
        if !self.accepts(character: char) {
            return nil
        }
        
        return Next(
            state: self.nextState(),
            insert: char,
            pass: true,
            value: char
        )
    }
    
    /**
     Constructor.
     
     - parameter child: next ```State```
     - parameter type: type of the accepted characters
     
     - seealso: ```ValueState.StateType```
     
     - returns: Initialized ```ValueState``` instance.
     */
    init(
        child: State,
        type: StateType
    ) {
        self.type = type
        super.init(child: child)
    }
    
    override var debugDescription: String {
        switch self.type {
            case .literal:
                return "[A] -> " + (nil != self.child ? self.child!.debugDescription : "nil")
            case .numeric:
                return "[0] -> " + (nil != self.child ? self.child!.debugDescription : "nil")
            case .alphaNumeric:
                return "[_] -> " + (nil != self.child ? self.child!.debugDescription : "nil")
            case .ellipsis:
                return "[…] -> " + (nil != self.child ? self.child!.debugDescription : "nil")
        }
    }
    
}
