//
//  ScanStorage.swift
//  scanCodeApp
//
//  Created by Vladislav Andreev on 16.10.2025.
//

import Foundation
import CoreData

final class ScanStorage {
    static let shared = ScanStorage()
    private let context = PersistenceController.shared.container.viewContext

    private init() {}

    /// Сохраняет новый скан, если его ещё нет в базе
    func saveScan(rawValue: String, codeType: String, title: String?, details: String?) throws {
        // Проверяем на дубликат
        let request: NSFetchRequest<ScannedCode> = ScannedCode.fetchRequest()
        request.predicate = NSPredicate(format: "rawValue == %@", rawValue)
        request.fetchLimit = 1

        if let _ = try? context.fetch(request).first {
            print("Код уже сохранён — пропускаем")
            return
        }

        let newScan = ScannedCode(context: context)
        newScan.id = UUID()
        newScan.rawValue = rawValue
        newScan.codeType = codeType
        newScan.titleText = title ?? rawValue
        newScan.detailsJSON = details
        newScan.scannedAt = Date()

        try context.save()
    }

    func fetchAll() throws -> [ScannedCode] {
        let request: NSFetchRequest<ScannedCode> = ScannedCode.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \ScannedCode.scannedAt, ascending: false)]
        return try context.fetch(request)
    }
}
