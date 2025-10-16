//
//  HistoryViewModel.swift
//  scanCodeApp
//
//  Created by Vladislav Andreev on 16.10.2025.
//

import Foundation
import CoreData
import Combine

@MainActor
final class HistoryViewModel: ObservableObject {
    @Published var scans: [ScannedCode] = []
    @Published var errorMessage: String?

    private let storage = ScanStorage.shared

    init() {
        fetchScans()
        NotificationCenter.default.addObserver(
            forName: .NSManagedObjectContextObjectsDidChange,
            object: PersistenceController.shared.container.viewContext,
            queue: .main
        ) { [weak self] _ in
            self?.fetchScans()
        }
    }

    func fetchScans() {
        do {
            scans = try storage.fetchAll()
        } catch {
            errorMessage = "Ошибка загрузки истории: \(error.localizedDescription)"
        }
    }

    func renameScan(_ scan: ScannedCode, newTitle: String) {
        guard let context = scan.managedObjectContext else { return }
        scan.titleText = newTitle
        do {
            try context.save()
            fetchScans()
        } catch {
            errorMessage = "Не удалось сохранить изменения: \(error.localizedDescription)"
        }
    }

    func deleteScan(_ scan: ScannedCode) {
        guard let context = scan.managedObjectContext else { return }
        context.delete(scan)
        do {
            try context.save()
            fetchScans()
        } catch {
            errorMessage = "Ошибка удаления: \(error.localizedDescription)"
        }
    }
}
