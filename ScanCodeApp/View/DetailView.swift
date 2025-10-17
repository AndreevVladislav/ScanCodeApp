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
                    let isValidLink = {
                        if let url = URL(string: raw),
                           let scheme = url.scheme?.lowercased(),
                           (scheme == "http" || scheme == "https") {
                            return true
                        }
                        return false
                    }()

                    Text("Содержимое: \(raw)")
                        .foregroundStyle(isValidLink ? .blue : .primary)
                        .underline(isValidLink, color: .blue)
                        .onTapGesture {
                            if isValidLink, let url = URL(string: raw) {
                                UIApplication.shared.open(url)
                            }
                        }
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
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                ShareLink(item: shareText) {
                    Label("Поделиться", systemImage: "square.and.arrow.up")
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
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
    
    // Текст, который будет отправляться при "Поделиться"
    private var shareText: String {
        var result = ""
        if let title = scan.titleText {
            result += "Название: \(title)\n"
        }
        if let type = scan.codeType {
            result += "Тип: \(type)\n"
        }
        if let raw = scan.rawValue {
            result += "Содержимое: \(raw)\n"
        }
        if let details = scan.detailsJSON, !details.isEmpty {
            result += "\nДоп. информация:\n\(details)"
        }
        return result
    }
}
