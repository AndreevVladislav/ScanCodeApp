//
//  DetailView.swift
//  scanCodeApp
//
//  Created by Vladislav Andreev on 16.10.2025.
//

import Foundation
import SwiftUI

struct DetailView: View {
    @ObservedObject var scan: ScannedCode
    var onRename: ((String) -> Void)? = nil
    @State private var isEditing = false
    @State private var newTitle: String = ""

    var body: some View {
        Form {
            Section("Информация") {
                if isEditing {
                    TextField("Название", text: $newTitle)
                        .textFieldStyle(.roundedBorder)
                } else {
                    Text(scan.titleText ?? "Без названия")
                        .font(.headline)
                }
                Text("Тип кода: \(scan.codeType ?? "—")")
                if let raw = scan.rawValue {
                    Text("Содержимое: \(raw)")
                }
            }

            if let details = scan.detailsJSON, !details.isEmpty {
                Section("Доп. данные") {
                    Text(details)
                        .font(.caption)
                    
                }
            }
        }
        .navigationTitle(scan.titleText ?? "Детали")
        .toolbar {
            Button(isEditing ? "Сохранить" : "Изменить") {
                if isEditing {
                    onRename?(newTitle)
                } else {
                    newTitle = scan.titleText ?? ""
                }
                isEditing.toggle()
            }
        }
    }
}
