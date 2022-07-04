//
//  FileManager-DocumentsDirectory.swift
//  PingPong
//
//  Created by Philipp on 04.07.22.
//

import Foundation

extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
