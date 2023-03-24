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

    @State var completeName = false
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
                            .onSubmit {
                                completeName = !name.isEmpty
                            }
                            .submitLabel(SubmitLabel.done)
                    }
                    HStack {
                        Image(systemName: "phone")
                            .imageScale(.large)
                            .foregroundColor(.accentColor)
                        MaskedTextField(
                            text: $phone,
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
                        .keyboardType(.numbersAndPunctuation)
                        .returnKeyType(.done)
                        .onSubmit { textField in
                            textField.resignFirstResponder()
                        }
                    }
                    HStack {
                        Image(systemName: "calendar")
                            .imageScale(.large)
                            .foregroundColor(.accentColor)
                        MaskedTextField(
                            text: $dob,
                            placeholder: "00.00.0000",
                            primaryMaskFormat: "[90]{.}[90]{.}[0000]",
                            autocomplete: true,
                            autocompleteOnFocus: true,
                            allowSuggestions: true,
                            onMaskedTextChangedCallback: { textInput, value, complete in
                                print("DOB complete: \(complete); value: \(value); text: \(dob)")
                                completeDob = complete
                            })
                        .monospaced()
                        .keyboardType(.numbersAndPunctuation)
                        .returnKeyType(.done)
                        .onSubmit { textField in
                            textField.resignFirstResponder()
                        }
                    }
                } header: {
                    Text("User")
                } footer: {
                    completeName && completePhone && completeDob ? Text("Done") : nil
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
