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
                Section(header: Text("Доп. данные")) {
                    if let ingredients = extractIngredients(from: details), !ingredients.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Ингредиенты")
                                .font(.headline)

                            Text(ingredients)
                                .font(.callout)
                                .foregroundStyle(.secondary)
                                .lineSpacing(3)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(12)
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
                    } else {
                        Text("Ингредиенты не найдены")
                            .foregroundStyle(.secondary)
                    }
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
