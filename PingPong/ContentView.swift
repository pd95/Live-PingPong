//
//  ContentView.swift
//  PingPong
//
//  Created by Philipp on 04.07.22.
//

import SwiftUI



struct ContentView: View {
    @EnvironmentObject var viewModel: ViewModel

    @State private var showingAddSheet = false

    var body: some View {
        Group {
            if viewModel.servers.isEmpty {
                Text("Please add a server")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List {
                    ForEach(viewModel.servers, content: ServerRow.init(server: ))
                        .onDelete(perform: viewModel.delete(_:))
                }
            }
        }
        .navigationSubtitle("Last Refresh: \(viewModel.lastRefreshDate.formatted())")
        .toolbar {
            Button(action: viewModel.refresh) {
                if viewModel.refreshInProgress {
                    ProgressView()
                        .controlSize(.small)
                } else {
                    Label("Refresh", systemImage: "arrow.clockwise")
                }
            }
            .disabled(viewModel.refreshInProgress)

            Button {
                showingAddSheet.toggle()
            } label: {
                Label("Add Server", systemImage: "plus")
            }
        }
        .sheet(isPresented: $showingAddSheet) {
            AddServerView()
                .environmentObject(viewModel)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ViewModel())
    }
}
