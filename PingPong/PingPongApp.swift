//
//  PingPongApp.swift
//  PingPong
//
//  Created by Philipp on 04.07.22.
//

import SwiftUI

@main
struct PingPongApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var viewModel = ViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }

        Settings {
            SettingsView()
                .environmentObject(viewModel)
        }
    }
}
