//
//  SettingsView.swift
//  PingPong
//
//  Created by Philipp on 04.07.22.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("refreshDelayMinutes") var refreshDelayMinutes: Double = 10
    @StateObject private var viewModel = ViewModel()

    var body: some View {
        Form {
            Text("Refresh in minutes: \(refreshDelayMinutes.formatted(.number.rounded()))")
            Slider(value: $refreshDelayMinutes, in: 1...60, step: 1, onEditingChanged: { changing in
                if changing == false {
                    viewModel.setupRefreshTask()
                }
            })
                .frame(maxWidth: 300)
        }
        .padding()
        .navigationTitle("Settings")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(ViewModel())
    }
}
