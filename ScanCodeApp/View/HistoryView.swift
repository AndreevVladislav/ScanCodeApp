//
//  HistoryView.swift
//  scanCodeApp
//
//  Created by Vladislav Andreev on 16.10.2025.
//

import Foundation
import SwiftUI

struct HistoryView: View {
    @StateObject private var viewModel = HistoryViewModel()
    @State private var showRenameSheet = false
    @State private var selectedScan: ScannedCode?
    @State private var newTitle: String = ""

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.scans, id: \.id) { scan in
                    NavigationLink(destination: DetailView(scan: scan, onRename: { updatedTitle in
                        viewModel.renameScan(scan, newTitle: updatedTitle)
                    })) {
                        HStack {
                            if scan.codeType == "barcode" {
                                Image(systemName: "barcode")
                                    .font(.system(size: 36))
                            } else {
                                Image(systemName: "qrcode")
                                    .font(.system(size: 36))
                            }
                            VStack(alignment: .leading) {
                                Text(scan.titleText ?? "Без названия")
                                    .font(.headline)
                                Text(scan.codeType ?? "")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Text(scan.scannedAt ?? Date(), style: .date)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                viewModel.deleteScan(scan)
                            } label: {
                                Label("", systemImage: "trash")
                            }
                            Button {
                                selectedScan = scan
                                newTitle = scan.titleText ?? ""
                                showRenameSheet = true
                            } label: {
                                Label("", systemImage: "pencil")
                            }
                        }
                    }
                }
            }
            .navigationTitle("Сохранённые коды")
            .sheet(isPresented: $showRenameSheet) {
                renameSheet
            }
            Spacer()
        }
    }

    private var renameSheet: some View {
        NavigationView {
            Form {
                Section("Новое название") {
                    TextField("Введите новое имя", text: $newTitle)
                }
            }
            .navigationTitle("Переименовать")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена") { showRenameSheet = false }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Сохранить") {
                        if let scan = selectedScan {
                            viewModel.renameScan(scan, newTitle: newTitle)
                        }
                        showRenameSheet = false
                    }
                }
            }
        }
    }
}
