//
// Project «InputMask»
// Created by Jeorge Taflanidi
//

import UIKit
import SwiftUI

@available(iOS 13.0, *)
public extension MaskedTextField {
    func textColor(_ color: UIColor) -> Self {
        var s = self
        s.textColor = color
        return s
    }
    
    func fontFromUIFont(_ font: UIFont) -> Self {
        var s = self
        s.font = font
        return s
    }
    
    func textAlignement(_ alignment: NSTextAlignment) -> Self {
        var s = self
        s.textAlignement = alignment
        return s
    }
    
    func borderStyle(_ borderStyle: UITextField.BorderStyle) -> Self {
        var s = self
        s.borderStyle = borderStyle
        return s
    }
    
    func tintColor(_ tintColor: UIColor) -> Self {
        var s = self
        s.tintColor = tintColor
        return s
    }
    
    func clearsOnBeginEditing(_ clearsOnBeginEditing: Bool) -> Self {
        var s = self
        s.clearsOnBeginEditing = clearsOnBeginEditing
        return s
    }
    
    func clearsOnInsertion(_ clearsOnInsertion: Bool) -> Self {
        var s = self
        s.clearsOnInsertion = clearsOnInsertion
        return s
    }
    
    func adjustsFontSizeToFitWidth(_ adjustsFontSizeToFitWidth: Bool) -> Self {
        var s = self
        s.adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth
        return s
    }
    
    func minimumFontSize(_ minimumFontSize: CGFloat) -> Self {
        var s = self
        s.minimumFontSize = minimumFontSize
        return s
    }
    
    func backgroundImage(_ background: UIImage) -> Self {
        var s = self
        s.background = background
        return s
    }
    
    func disabledBackgroundImage(_ disabledBackground: UIImage) -> Self {
        var s = self
        s.disabledBackground = disabledBackground
        return s
    }
    
    func clearButtonMode(_ clearButtonMode: UITextField.ViewMode) -> Self {
        var s = self
        s.clearButtonMode = clearButtonMode
        return s
    }
    
    func leftView(_ leftView: UIView) -> Self {
        var s = self
        s.leftView = leftView
        return s
    }
    
    func leftViewMode(_ leftViewMode: UITextField.ViewMode) -> Self {
        var s = self
        s.leftViewMode = leftViewMode
        return s
    }
    
    func rightView(_ rightView: UIView) -> Self {
        var s = self
        s.rightView = rightView
        return s
    }
    
    func rightViewMode(_ rightViewMode: UITextField.ViewMode) -> Self {
        var s = self
        s.rightViewMode = rightViewMode
        return s
    }
    
    func inputView(_ inputView: UIView) -> Self {
        var s = self
        s.inputView = inputView
        return s
    }
    
    func inputAccessoryView(_ inputAccessoryView: UIView) -> Self {
        var s = self
        s.inputAccessoryView = inputAccessoryView
        return s
    }
    
    func isUserInteractionEnabled(_ isUserInteractionEnabled: Bool) -> Self {
        var s = self
        s.isUserInteractionEnabled = isUserInteractionEnabled
        return s
    }
    
    func autocapitalizationType(_ autocapitalizationType: UITextAutocapitalizationType) -> Self {
        var s = self
        s.autocapitalizationType = autocapitalizationType
        return s
    }
    
    func autocorrectionType(_ autocorrectionType: UITextAutocorrectionType) -> Self {
        var s = self
        s.autocorrectionType = autocorrectionType
        return s
    }
    
    func spellCheckingType(_ spellCheckingType: UITextSpellCheckingType) -> Self {
        var s = self
        s.spellCheckingType = spellCheckingType
        return s
    }
    
    func smartQuotesType(_ smartQuotesType: UITextSmartQuotesType) -> Self {
        var s = self
        s.smartQuotesType = smartQuotesType
        return s
    }
    
    func smartDashesType(_ smartDashesType: UITextSmartDashesType) -> Self {
        var s = self
        s.smartDashesType = smartDashesType
        return s
    }
    
    func smartInsertDeleteType(_ smartInsertDeleteType: UITextSmartInsertDeleteType) -> Self {
        var s = self
        s.smartInsertDeleteType = smartInsertDeleteType
        return s
    }
    
    func keyboardType(_ keyboardType: UIKeyboardType) -> Self {
        var s = self
        s.keyboardType = keyboardType
        return s
    }
    
    func keyboardAppearance(_ keyboardAppearance: UIKeyboardAppearance) -> Self {
        var s = self
        s.keyboardAppearance = keyboardAppearance
        return s
    }
    
    func returnKeyType(_ returnKeyType: UIReturnKeyType) -> Self {
        var s = self
        s.returnKeyType = returnKeyType
        return s
    }
    
    func enablesReturnKeyAutomatically(_ enablesReturnKeyAutomatically: Bool) -> Self {
        var s = self
        s.enablesReturnKeyAutomatically = enablesReturnKeyAutomatically
        return s
    }
    
    func isSecureTextEntry(_ isSecureTextEntry: Bool) -> Self {
        var s = self
        s.isSecureTextEntry = isSecureTextEntry
        return s
    }
    
    func textContentType(_ textContentType: UITextContentType) -> Self {
        var s = self
        s.textContentType = textContentType
        return s
    }
    
    func passwordRules(_ passwordRules: UITextInputPasswordRules) -> Self {
        var s = self
        s.passwordRules = passwordRules
        return s
    }
    
    func contentHuggingPriorityVertical(_ contentHuggingPriorityVertical: UILayoutPriority) -> Self {
        var s = self
        s.contentHuggingPriorityVertical = contentHuggingPriorityVertical
        return s
    }
    
    func contentHuggingPriorityHorizontal(_ contentHuggingPriorityHorizontal: UILayoutPriority) -> Self {
        var s = self
        s.contentHuggingPriorityHorizontal = contentHuggingPriorityHorizontal
        return s
    }
    
    func contentCompressionResistancePriorityHorizontal(_ contentCompressionResistancePriorityHorizontal: UILayoutPriority) -> Self {
        var s = self
        s.contentCompressionResistancePriorityHorizontal = contentCompressionResistancePriorityHorizontal
        return s
    }
    
    func contentCompressionResistancePriorityVertical(_ contentCompressionResistancePriorityVertical: UILayoutPriority) -> Self {
        var s = self
        s.contentCompressionResistancePriorityVertical = contentCompressionResistancePriorityVertical
        return s
    }
    
    func onMaskedTextChanged(_ onMaskedTextChangedCallback: @escaping (_ textInput: UITextInput, _ value: String, _ complete: Bool) -> ()) -> Self {
        var s = self
        s.onMaskedTextChangedCallback = onMaskedTextChangedCallback
        return s
    }
    
    // MARK: - SwiftUI Modifiers

    func monospacedDigit(size: CGFloat = 16.0, weight: UIFont.Weight = .medium) -> Self {
        var s = self
        s.font = UIFont.monospacedDigitSystemFont(ofSize: size, weight: weight)
        return s
    }
    
    func monospaced(size: CGFloat = 16.0, weight: UIFont.Weight = .medium) -> Self {
        var s = self
        s.font = UIFont.monospacedSystemFont(ofSize: size, weight: weight)
        return s
    }
    
    func fontSizeWeight(_ size: CGFloat = 16.0, _ weight: UIFont.Weight = .medium) -> Self {
        var s = self
        s.font = UIFont.systemFont(ofSize: size, weight: weight)
        return s
    }
    
    func bold(_ size: CGFloat = 16.0) -> Self {
        var s = self
        s.font = UIFont.boldSystemFont(ofSize: size)
        return s
    }
    
    func italic(_ size: CGFloat = 16.0) -> Self {
        var s = self
        s.font = UIFont.italicSystemFont(ofSize: size)
        return s
    }
}
