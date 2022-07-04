//
//  ServerRow.swift
//  PingPong
//
//  Created by Philipp on 04.07.22.
//

import SwiftUI

struct ServerRow: View {
    @EnvironmentObject private var viewModel: ViewModel

    let server: Server

    var body: some View {
        HStack(spacing: 15) {
            Button {
                viewModel.acknowledgeChanges(for: server)
            } label: {
                Circle()
                    .fill(server.hasChanges ? .red : .green)
                    .frame(width: 24, height: 24)
            }
            .buttonStyle(.borderless)
            .help(server.hasChanges ? "Click to clear the change marker for this server." : "")
            VStack(alignment: .leading) {
                Link(server.url.absoluteString, destination: server.url)
                    .font(.title)

                Text("Last changed: \(server.lastChange.formatted())")
            }
        }
        .contextMenu {
            Button("Delete", action: { viewModel.delete(server: server) })
        }
    }
}

struct ServerRow_Previews: PreviewProvider {
    static var previews: some View {
        ServerRow(server: .example)
            .environmentObject(ViewModel())
    }
}
