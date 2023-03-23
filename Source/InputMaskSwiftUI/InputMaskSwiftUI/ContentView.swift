//
//  ContentView.swift
//  InputMaskSwiftUI
//
//  Created by Jeorge Taflanidi on 2023-03-22.
//

import SwiftUI
import InputMask

struct ContentView: View {
    @State var name = ""
    @State var phone = ""
    @State var dob = ""
    
    @State var keepFocused = false
    @State var keepFocusedDob = false
    
    @State var completePhone = false
    @State var completeDob = false
    
    var body: some View {
        NavigationStack{
            Form {
                Section {
                    HStack {
                        Image(systemName: "person")
                            .imageScale(.large)
                            .foregroundColor(.accentColor)
                        TextField("Name", text: $name)
                    }
                    HStack {
                        Image(systemName: "phone")
                            .imageScale(.large)
                            .foregroundColor(.accentColor)
                        MaskedTextField(
                            text: $phone,
                            keepFocused: $keepFocused,
                            placeholder: "+380 (00) 000-00-00",
                            primaryMaskFormat: "+380 ([00]) [000]-[00]-[00]",
                            autocomplete: true,
                            autocompleteOnFocus: true,
                            allowSuggestions: true,
                            onMaskedTextChangedCallback: { textInput, value, complete in
                                print("PHONE complete: \(complete); value: \(value); text: \(phone)")
                                completePhone = complete
                            })
                        .monospaced()
                        .keyboardType(.phonePad)
                    }
                    HStack {
                        Image(systemName: "calendar")
                            .imageScale(.large)
                            .foregroundColor(.accentColor)
                        MaskedTextField(
                            text: $dob,
                            keepFocused: $keepFocusedDob,
                            placeholder: "00.00.0000",
                            primaryMaskFormat: "[90].[90].[0000]",
                            autocomplete: true,
                            autocompleteOnFocus: true,
                            allowSuggestions: true,
                            onMaskedTextChangedCallback: { textInput, value, complete in
                                print("DOB complete: \(complete); value: \(value); text: \(dob)")
                                completeDob = complete
                            })
                        .monospaced()
                        .keyboardType(.decimalPad)
                    }
                } header: {
                    Text("User")
                } footer: {
                    completePhone && completeDob ? Text("Done") : nil
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
