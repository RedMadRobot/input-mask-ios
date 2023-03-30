//
// Project «InputMask»
// Created by Jeorge Taflanidi
//

import InputMask
import SwiftUI

struct MaskedTextField: View {
    @Binding var text: String
    @Binding var value: String
    @Binding var complete: Bool
    
    let placeholder: String
    let mask: String
    
    var body: some View {
        InputMask.MaskedTextField(
            text: $text,
            value: $value,
            complete: $complete,
            placeholder: placeholder,
            primaryMaskFormat: mask,
            autocomplete: true,
            autocompleteOnFocus: true,
            allowSuggestions: true
        )
        .monospaced()
        .keyboardType(.numbersAndPunctuation)
        .returnKeyType(.done)
        .onSubmit { textField in
            textField.resignFirstResponder()
        }
        .onChange(of: text) { newValue in
            print("\nTEXT: \(text)\nVALUE: \(value)\nCOMPLETE: \(complete)")
        }
    }
}

struct MaskedTextField_Previews: PreviewProvider {
    static var previews: some View {
        MaskedTextField(
            text: Binding.constant(""),
            value: Binding.constant(""),
            complete: Binding.constant(false),
            placeholder: "",
            mask: ""
        )
    }
}
