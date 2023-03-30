//
// Project «InputMask»
// Created by Jeorge Taflanidi
//

import SwiftUI

struct ContentView: View {
    @State var name = ""
    @State var phone = ""
    @State var dob = ""
    
    @State var phoneValue = ""
    @State var dobValue = ""

    @State var nameComplete = false
    @State var phoneComplete = false
    @State var dobComplete = false
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    HStack {
                        Image(systemName: "person")
                            .imageScale(.large)
                            .foregroundColor(.accentColor)
                        TextField("Name", text: $name)
                            .onChange(of: name) { newValue in
                                nameComplete = !name.isEmpty
                            }
                            .onSubmit {
                                nameComplete = !name.isEmpty
                            }
                            .submitLabel(SubmitLabel.done)
                    }
                    HStack {
                        Image(systemName: "phone")
                            .imageScale(.large)
                            .foregroundColor(.accentColor)
                        MaskedTextField(
                            text: $phone,
                            value: $phoneValue,
                            complete: $phoneComplete,
                            placeholder: "+380 (00) 000-00-00",
                            mask: "+380 ([00]) [000]-[00]-[00]"
                        )
                    }
                    HStack {
                        Image(systemName: "calendar")
                            .imageScale(.large)
                            .foregroundColor(.accentColor)
                        MaskedTextField(
                            text: $dob,
                            value: $dobValue,
                            complete: $dobComplete,
                            placeholder: "00.00.0000",
                            mask: "[90]{.}[90]{.}[0000]"
                        )
                    }
                } header: {
                    Text("User")
                } footer: {
                    nameComplete && phoneComplete && dobComplete ? Text("Done") : nil
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
