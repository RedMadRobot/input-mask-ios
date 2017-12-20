//
//  InputMask
//
//  Created by Egor Taflanidi on 16.08.28.
//  Copyright © 28 Heisei Egor Taflanidi. All rights reserved.
//

import Foundation


/**
 ### State
 
 State of the mask, similar to the state in regular expressions.
 Each state represents a character from the mask format string.
 */
class State: CustomDebugStringConvertible, CustomStringConvertible {
    
    /**
     Next ```State```.
     */
    let child: State?
    
    /**
     Abstract method.
     
     Defines, whether the state accepts user input character or not, and which actions should take place when the 
     character is accepted.
     
     - parameter character: character from the user input string.
     
     - returns: ```Next``` object instance with a set of actions that should take place when the user input character is
     accepted.
     
     - throws: Fatal error, if the method is not implemeted.
     */
    /* abstract */ func accept(character char: Character) -> Next? {
        fatalError("accept(character:) method is abstract")
    }
    
    /**
     Automatically complete user input.
     
     - returns: ```Next``` object instance with a set of actions to complete user input. If no autocomplete available,
     returns ```nil```.
     */
    func autocomplete() -> Next? {
        return nil
    }
    
    /**
     Obtain the next state. 
     
     Sometimes it is necessary to override this behavior. For instance, ```State``` may want to return ```self``` as the
     next state under certain conditions.
     
     - returns: ```State``` object.
     */
    func nextState() -> State {
        return self.child!
    }
    
    /**
     Constructor.
     
     - parameter child: next state.
     
     - returns: Initialized state.
     */
    init(child: State?) {
        self.child = child
    }
    
    var debugDescription: String {
        get {
            return "BASE -> " + (nil != self.child ? self.child!.debugDescription : "nil")
        }
    }
    
    var description: String {
        get {
            return self.debugDescription
        }
    }
    
}
