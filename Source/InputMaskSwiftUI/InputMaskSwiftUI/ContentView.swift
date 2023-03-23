//
//  ContentView.swift
//  InputMaskSwiftUI
//
//  Created by Jeorge Taflanidi on 2023-03-22.
//

import SwiftUI
import InputMask

struct ContentView: View {
    @State var placeholder = "+380 (00) 000-00-00"
    @State var text = ""
    @State var isEditing = false
    
    var body: some View {
        NavigationStack{
            Form {
                Section {
                    HStack {
                        Image(systemName: "phone")
                            .imageScale(.large)
                            .foregroundColor(.accentColor)
                        MaskedTextField(
                            text: $text,
                            placeholder: $placeholder,
                            isEditing: $isEditing,
                            primaryMaskFormat: "+380 ([00]) [000]-[00]-[00]",
                            autocomplete: true,
                            autocompleteOnFocus: true,
                            allowSuggestions: true,
                            onMaskedTextChangedCallback: { textInput, value, complete in
                                print("complete: \(complete); value: \(value); text: \(text)")
                            })
                        .monospaced()
                    }
                } header: {
                    Text("Phone")
                }
            }
            .navigationTitle("Sample")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
