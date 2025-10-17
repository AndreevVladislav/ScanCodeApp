//
//  ScannedCodeItem.swift
//  scanCodeApp
//
//  Created by Vladislav Andreev on 17.10.2025.
//

import Foundation

/// Обёртка для сканированного кода, чтобы использовать `.sheet(item:)`
struct ScannedCodeItem: Identifiable {
    let id = UUID()
    let value: String
    let type: String
}
