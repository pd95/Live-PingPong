//
//  ViewModel.swift
//  PingPong
//
//  Created by Philipp on 04.07.22.
//

import AppKit
import Foundation
import UserNotifications

class ViewModel: ObservableObject {
    @Published var servers: [Server]
    @Published var lastRefreshDate = Date.now
    @Published var refreshInProgress = false

    private var refreshTask: Task<Void, Error>?
    let delay: UInt64 = 1_000_000_000 * 10 //60 * 10 // 10 minutes between refreshes

    private let savePath = FileManager.documentsDirectory.appendingPathComponent("ServerCache")

    init() {
        do {
            let data = try Data(contentsOf: savePath)
            servers = try JSONDecoder().decode([Server].self, from: data)
        } catch {
            servers = []
        }

        refresh()
    }

    func save() {
        print("Saving to \(savePath)")

        do {
            let data = try JSONEncoder().encode(servers)
            try data.write(to: savePath, options: [.atomic, .completeFileProtection])
        } catch {
            print("Unable to save data", error)
        }
    }

    func add(_ url: URL) {
        let server = Server(url: url)
        servers.append(server)
        save()
        refresh()
    }

    func delete(_ offsets: IndexSet) {
        servers.remove(atOffsets: offsets)
        save()
    }

    @MainActor
    private func refreshAllServers() async {
        defer { queueRefresh() }

        guard servers.isEmpty == false else { return }

        refreshInProgress = true
        try? await Task.sleep(nanoseconds: 200_000_000)

        let session = URLSession(configuration: .ephemeral)
        var changesDetected = false

        for server in servers {
            print("Fetching \(server.url)")

            if let (newData, _) = try? await session.data(from: server.url) {
                if newData != server.content {
                    if server.content != nil {
                        changesDetected = true
                        server.hasChanges = true
                        notifyChange(for: server)
                    }

                    server.lastChange = .now
                    server.content = newData
                }
            }
        }

        if changesDetected {
            NSApp.requestUserAttention(.criticalRequest)
            save()
        }

        lastRefreshDate = .now
        refreshInProgress = false
    }

    private func queueRefresh() {
        refreshTask = Task {
            try await Task.sleep(nanoseconds: delay)
            await refreshAllServers()
        }
    }

    func refresh() {
        guard refreshInProgress == false else { return }

        refreshTask?.cancel()

        Task {
            await refreshAllServers()
        }
    }

    private func notifyChange(for server: Server) {
        let center = UNUserNotificationCenter.current()

        center.requestAuthorization(options: [.alert]) { granted, error in
            guard granted else { return }
            let content = UNMutableNotificationContent()
            let host = server.url.host ?? "Server"
            content.title = "\(host) has changed!"

            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
            center.add(request)
        }
    }

    func acknowledgeChanges(for server: Server) {
        guard server.hasChanges else { return }

        objectWillChange.send()
        server.hasChanges = false
        save()
    }
}
