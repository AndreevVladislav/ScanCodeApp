//
//  PersistenceController.swift
//  scanCodeApp
//
//  Created by Vladislav Andreev on 16.10.2025.
//

import Foundation
import CoreData

// Синглтон, который управляет Core Data стеком
final class PersistenceController {
    static let shared = PersistenceController()
    let container: NSPersistentContainer

    private init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "CodeScannerModel")
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Ошибка загрузки Core Data: \(error)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
