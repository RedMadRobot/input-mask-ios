//
// Project «InputMask»
// Created by Jeorge Taflanidi
//

#if !os(macOS) && !os(watchOS)

import SwiftUI

/**
 ### MaskedTextField
 
 A UITextField wrapper for SwiftUI, with a MaskedTextInputListener attached.
 */
@available(iOS 13.0, *)
public struct MaskedTextField: UIViewRepresentable {
    public typealias UITextFieldEvent = (_ textField: UITextField) -> Void
    
    @Binding public var text: String
    @Binding public var value: String
    @Binding public var complete: Bool
    
    public var placeholder: String
    
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
    
    public var onSubmit: UITextFieldEvent?
    public var onFocus: UITextFieldEvent?
    
    // MaskedTextFieldDelegate properties
    
    public let primaryMaskFormat:   String
    public let autocomplete:        Bool
    public let autocompleteOnFocus: Bool
    public let autoskip:            Bool
    public let rightToLeft:         Bool
    
    public let allowSuggestions: Bool
    
    public let atomicCursorMovement: Bool = false
    
    public let affineFormats:               [String]
    public let affinityCalculationStrategy: AffinityCalculationStrategy
    public let customNotations:             [Notation]
    
    public init(
        text: Binding<String>,
        value: Binding<String>,
        complete: Binding<Bool>,
        placeholder: String,
        primaryMaskFormat: String = "",
        autocomplete: Bool = true,
        autocompleteOnFocus: Bool = true,
        autoskip: Bool = false,
        rightToLeft: Bool = false,
        allowSuggestions: Bool = true,
        affineFormats: [String] = [],
        affinityCalculationStrategy: AffinityCalculationStrategy = .wholeString,
        customNotations: [Notation] = []
    ) {
        self._text = text
        self._value = value
        self._complete = complete
        self.placeholder = placeholder
        self.primaryMaskFormat = primaryMaskFormat
        self.autocomplete = autocomplete
        self.autocompleteOnFocus = autocompleteOnFocus
        self.autoskip = autoskip
        self.rightToLeft = rightToLeft
        self.allowSuggestions = allowSuggestions
        self.affineFormats = affineFormats
        self.affinityCalculationStrategy = affinityCalculationStrategy
        self.customNotations = customNotations
    }
    
    public func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        updateTextFieldAttributes(textField, context: context)
        textField.delegate = context.coordinator
        return textField
    }
    
    public func updateUIView(_ uiView: UITextField, context: Context) {
        let coordinator = context.coordinator
        
        coordinator.onSubmit = onSubmit
        coordinator.onFocus = onFocus
        
        updateTextFieldAttributes(uiView, context: context)
        uiView.delegate = coordinator
        uiView.text = text
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(
            primaryFormat: primaryMaskFormat,
            autocomplete: autocomplete,
            autocompleteOnFocus: autocompleteOnFocus,
            autoskip: autoskip,
            rightToLeft: rightToLeft,
            affineFormats: affineFormats,
            affinityCalculationStrategy: affinityCalculationStrategy,
            customNotations: customNotations,
            onMaskedTextChangedCallback: { input, value, complete in
                self.text = input.allText
                self.value = value
                self.complete = complete
            },
            allowSuggestions: allowSuggestions,
            onSubmit: onSubmit,
            onFocus: onFocus
        )
    }
    
    public final class Coordinator: MaskedTextInputListener {
        public var onSubmit: UITextFieldEvent?
        public var onFocus: UITextFieldEvent?
        
        public init(
            primaryFormat: String = "",
            autocomplete: Bool = true,
            autocompleteOnFocus: Bool = true,
            autoskip: Bool = false,
            rightToLeft: Bool = false,
            affineFormats: [String] = [],
            affinityCalculationStrategy: AffinityCalculationStrategy = .wholeString,
            customNotations: [Notation] = [],
            onMaskedTextChangedCallback: ((UITextInput, String, Bool) -> ())? = nil,
            allowSuggestions: Bool = true,
            onSubmit: UITextFieldEvent? = nil,
            onFocus: UITextFieldEvent? = nil
        ) {
            self.onSubmit = onSubmit
            self.onFocus = onFocus
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
        
        public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            onSubmit?(textField)
            return true
        }

        public override func textFieldDidBeginEditing(_ textField: UITextField) {
            super.textFieldDidBeginEditing(textField)
            onFocus?(textField)
        }
    }
    
    private func updateTextFieldAttributes(_ field: UITextField, context: Context) {
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
        
        field.isEnabled = context.environment.isEnabled
        
        if context.environment.autocorrectionDisabled {
            field.autocorrectionType = .no
        }
        
        if #available(iOS 14.0, *) {
            if let textCase = context.environment.textCase {
                switch textCase {
                    case .uppercase:
                        field.autocapitalizationType = .allCharacters
                    case .lowercase:
                        field.autocapitalizationType = .none
                }
            }
        }
    }
}

#endif
