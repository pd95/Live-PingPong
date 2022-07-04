//
//  AddServerView.swift
//  PingPong
//
//  Created by Philipp on 04.07.22.
//

import SwiftUI

struct AddServerView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var model: ViewModel
    @State private var url = ""

    @State private var showingError = false
    @State private var validationMessage: String?

    var body: some View {
        Form {
            TextField("Server URL:", text: $url)
                .onSubmit(save)

            validationMessage.map(Text.init)

            HStack {
                Spacer()

                Button("Cancel", action: close)
                    .keyboardShortcut(.cancelAction)

                Button("Save", action: save)
                    .keyboardShortcut(.defaultAction)
            }
        }
        .frame(minWidth: 400)
        .padding()
        .alert("Invalid URL", isPresented: $showingError) {

        } message: {
            Text("Please make sure your URL starts with https:// so we can fetch its data correctly.")
        }
        .onExitCommand(perform: close)
    }

    private func close() {
        dismiss()
    }

    private func save() {
        guard url.hasPrefix("https://") else {
            showingError.toggle()
            return
        }

        guard let url = URL(string: url) else {
            validationMessage = "This is not a valid URL."
            return
        }

        validationMessage = model.validate(url: url)

        if validationMessage == nil {
            model.add(url)
            close()
        }
    }
}

struct AddServerView_Previews: PreviewProvider {
    static var previews: some View {
        AddServerView()
            .environmentObject(ViewModel())
    }
}
