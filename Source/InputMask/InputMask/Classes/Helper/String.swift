//
// Project «InputMask»
// Created by Jeorge Taflanidi
//


import Foundation


/**
 Utility extension for comonly used ```Mask``` operations upon strings.
 */
public extension String {
    
    /**
     Make a string by cutting the first character of current.
     
     - returns: Current string without first character.
     
     - throws: EXC_BAD_INSTRUCTION for empty strings.
     */
    public func truncateFirst() -> String {
        return String(self[self.index(after: self.startIndex)...])
    }
    
    /**
     Find common prefix.
     */
    public func prefixIntersection(with string: String) -> Substring {
        var lhsIndex = startIndex
        var rhsIndex = string.startIndex
        
        while lhsIndex != endIndex && rhsIndex != string.endIndex {
            if self[...lhsIndex] == string[...rhsIndex] {
                lhsIndex = index(after: lhsIndex)
                rhsIndex = string.index(after: rhsIndex)
            } else {
                return self[..<lhsIndex]
            }
        }
        
        return self[..<lhsIndex]
    }
    
    /**
     Reverse format string preserving `[...]` and `{...}` symbol groups.
     */
    func reversedFormat() -> String {
        return String(
            String(self.reversed())
                .replacingOccurrences(of: "[\\", with: "\\]")
                .replacingOccurrences(of: "]\\", with: "\\[")
                .replacingOccurrences(of: "{\\", with: "\\}")
                .replacingOccurrences(of: "}\\", with: "\\{")
                .map { (c: Character) -> Character in
                    switch c {
                        case "[": return "]"
                        case "]": return "["
                        case "{": return "}"
                        case "}": return "{"
                        default: return c
                    }
                }
        )
    }
    
}
