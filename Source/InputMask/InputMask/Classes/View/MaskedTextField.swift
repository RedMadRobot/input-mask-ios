//
// Project «InputMask»
// Created by Jeorge Taflanidi
//

import SwiftUI

/**
 ### MaskedTextField
 
 A UITextField wrapper for SwiftUI.
 */
@available(iOS 13.0, *)
public struct MaskedTextField: UIViewRepresentable {
    @Binding public var text: String
    @Binding public var placeholder: String
    @Binding public var isEditing: Bool
    
    public var textColor: UIColor?
    public var font: UIFont?
    public var textAlignement: NSTextAlignment?
    
    public var borderStyle: UITextField.BorderStyle?
    public var tintColor: UIColor?
    
    public var clearsOnBeginEditing: Bool?
    public var clearsOnInsertion: Bool?
    
    public var adjustsFontSizeToFitWidth: Bool?
    
    public var minimumFontSize: CGFloat?
    
    public var background: UIImage?
    public var disabledBackground: UIImage?
    
    public var clearButtonMode: UITextField.ViewMode?
    public var leftView: UIView?
    public var leftViewMode: UITextField.ViewMode?
    public var rightView: UIView?
    public var rightViewMode: UITextField.ViewMode?
    
    public var inputView: UIView?
    public var inputAccessoryView: UIView?
    
    public var isUserInteractionEnabled: Bool?
    
    public var autocapitalizationType: UITextAutocapitalizationType?
    public var autocorrectionType: UITextAutocorrectionType?
    public var spellCheckingType: UITextSpellCheckingType?
    public var smartQuotesType: UITextSmartQuotesType?
    public var smartDashesType: UITextSmartDashesType?
    public var smartInsertDeleteType: UITextSmartInsertDeleteType?
    
    public var keyboardType: UIKeyboardType?
    public var keyboardAppearance: UIKeyboardAppearance?
    
    public var returnKeyType: UIReturnKeyType?
    public var enablesReturnKeyAutomatically: Bool?
    
    public var isSecureTextEntry: Bool?
    
    public var textContentType: UITextContentType?
    
    public var passwordRules: UITextInputPasswordRules?
    
    public var contentHuggingPriorityVertical: UILayoutPriority = .defaultHigh
    public var contentHuggingPriorityHorizontal: UILayoutPriority?
    
    public var contentCompressionResistancePriorityHorizontal: UILayoutPriority = .defaultLow
    public var contentCompressionResistancePriorityVertical: UILayoutPriority?
    
    // MaskedTextFieldDelegate properties
    
    public var onMaskedTextChangedCallback: ((_ textInput: UITextInput, _ value: String, _ complete: Bool) -> ())?
    
    public var primaryMaskFormat:   String
    public var autocomplete:        Bool
    public var autocompleteOnFocus: Bool
    public var autoskip:            Bool
    public var rightToLeft:         Bool
    
    public var allowSuggestions: Bool
    
    public var atomicCursorMovement: Bool = false
    
    public var affineFormats:               [String]
    public var affinityCalculationStrategy: AffinityCalculationStrategy
    public var customNotations:             [Notation]
    
    public init(
        text: Binding<String>,
        placeholder: Binding<String>,
        isEditing: Binding<Bool>,
        primaryMaskFormat: String = "",
        autocomplete: Bool = true,
        autocompleteOnFocus: Bool = true,
        autoskip: Bool = false,
        rightToLeft: Bool = false,
        allowSuggestions: Bool = true,
        affineFormats: [String] = [],
        affinityCalculationStrategy: AffinityCalculationStrategy = .wholeString,
        customNotations: [Notation] = [],
        onMaskedTextChangedCallback: ((_ textInput: UITextInput, _ value: String, _ complete: Bool) -> ())? = nil
    ) {
        self._text = text
        self._placeholder = placeholder
        self._isEditing = isEditing
        self.primaryMaskFormat = primaryMaskFormat
        self.autocomplete = autocomplete
        self.autocompleteOnFocus = autocompleteOnFocus
        self.autoskip = autoskip
        self.rightToLeft = rightToLeft
        self.allowSuggestions = allowSuggestions
        self.affineFormats = affineFormats
        self.affinityCalculationStrategy = affinityCalculationStrategy
        self.customNotations = customNotations
        self.onMaskedTextChangedCallback = onMaskedTextChangedCallback
    }
    
    public func makeUIView(context: Context) -> UITextField {
        let field = UITextField(frame: CGRect.zero)
        updateTextFieldAttributes(field)
        field.delegate = context.coordinator
        return field
    }
    
    public func updateUIView(_ uiView: UITextField, context: Context) {
        updateTextFieldAttributes(uiView)
        uiView.delegate = context.coordinator
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(
            text: $text,
            isEditing: $isEditing,
            primaryFormat: primaryMaskFormat,
            autocomplete: autocomplete,
            autocompleteOnFocus: autocompleteOnFocus,
            autoskip: autoskip,
            rightToLeft: rightToLeft,
            affineFormats: affineFormats,
            affinityCalculationStrategy: affinityCalculationStrategy,
            customNotations: customNotations,
            onMaskedTextChangedCallback: onMaskedTextChangedCallback,
            allowSuggestions: allowSuggestions
        )
    }
    
    public final class Coordinator: MaskedTextInputListener {
        @Binding public var text: String
        @Binding public var isEditing: Bool
        
        public init(
            text: Binding<String>,
            isEditing: Binding<Bool>,
            primaryFormat: String = "",
            autocomplete: Bool = true,
            autocompleteOnFocus: Bool = true,
            autoskip: Bool = false,
            rightToLeft: Bool = false,
            affineFormats: [String] = [],
            affinityCalculationStrategy: AffinityCalculationStrategy = .wholeString,
            customNotations: [Notation] = [],
            onMaskedTextChangedCallback: ((UITextInput, String, Bool) -> ())? = nil,
            allowSuggestions: Bool = true
        ) {
            self._text = text
            self._isEditing = isEditing
            super.init(
                primaryFormat: primaryFormat,
                autocomplete: autocomplete,
                autocompleteOnFocus: autocompleteOnFocus,
                autoskip: autoskip,
                rightToLeft: rightToLeft,
                affineFormats: affineFormats,
                affinityCalculationStrategy: affinityCalculationStrategy,
                customNotations: customNotations,
                onMaskedTextChangedCallback: onMaskedTextChangedCallback,
                allowSuggestions: allowSuggestions
            )
        }
        
        public override func textInput(_ textInput: UITextInput, isChangingCharactersIn range: NSRange, replacementString string: String) -> Mask.Result {
            let result = super.textInput(textInput, isChangingCharactersIn: range, replacementString: string)
            text = textInput.allText
            return result
        }
    }
    
    private func updateTextFieldAttributes(_ field: UITextField) {
        field.text = text
        field.placeholder = placeholder
        
        field.textColor = textColor
        field.font = font
        field.textAlignment = textAlignement ?? field.textAlignment
        
        field.borderStyle = borderStyle ?? field.borderStyle
        field.tintColor = tintColor ?? field.tintColor
        
        field.clearsOnBeginEditing = clearsOnBeginEditing ?? field.clearsOnBeginEditing
        field.clearsOnInsertion = clearsOnInsertion ?? field.clearsOnInsertion
        
        field.adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth ?? field.adjustsFontSizeToFitWidth
        
        field.minimumFontSize = minimumFontSize ?? field.minimumFontSize
        
        field.background = background ?? field.background
        field.disabledBackground = disabledBackground ?? field.disabledBackground
        
        field.clearButtonMode = clearButtonMode ?? field.clearButtonMode
        field.leftView = leftView
        field.leftViewMode = leftViewMode ?? field.leftViewMode
        field.rightView = rightView
        field.rightViewMode = rightViewMode ?? field.rightViewMode
        
        field.inputView = inputView
        field.inputAccessoryView = inputAccessoryView
        
        field.isUserInteractionEnabled = isUserInteractionEnabled ?? field.isUserInteractionEnabled
     
        field.autocapitalizationType = autocapitalizationType ?? field.autocapitalizationType
        field.autocorrectionType = autocorrectionType ?? field.autocorrectionType
        field.spellCheckingType = spellCheckingType ?? field.spellCheckingType
        field.smartQuotesType = smartQuotesType ?? field.smartQuotesType
        field.smartDashesType = smartDashesType ?? field.smartDashesType
        field.smartInsertDeleteType = smartInsertDeleteType ?? field.smartInsertDeleteType
        
        field.keyboardType = keyboardType ?? field.keyboardType
        field.keyboardAppearance = keyboardAppearance ?? field.keyboardAppearance
        
        field.returnKeyType = returnKeyType ?? field.returnKeyType
        field.enablesReturnKeyAutomatically = enablesReturnKeyAutomatically ?? field.enablesReturnKeyAutomatically
        
        field.isSecureTextEntry = isSecureTextEntry ?? field.isSecureTextEntry
        
        field.textContentType = textContentType ?? field.textContentType
        
        field.passwordRules = passwordRules ?? field.passwordRules
        
        field.setContentHuggingPriority(contentHuggingPriorityVertical, for: .vertical)
        if let contentHuggingPriorityHorizontal = contentHuggingPriorityHorizontal {
            field.setContentHuggingPriority(contentHuggingPriorityHorizontal, for: .horizontal)
        }
        
        field.setContentCompressionResistancePriority(contentCompressionResistancePriorityHorizontal, for: .horizontal)
        if let contentCompressionResistancePriorityVertical = contentCompressionResistancePriorityVertical {
            field.setContentCompressionResistancePriority(contentCompressionResistancePriorityVertical, for: .vertical)
        }
    }
}
