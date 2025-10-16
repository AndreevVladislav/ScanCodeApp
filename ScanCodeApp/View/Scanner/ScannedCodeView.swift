//
//  ScannedCodeView.swift
//  scanCodeApp
//
//  Created by Vladislav Andreev on 16.10.2025.
//

import Foundation
import SwiftUI
import CoreData

struct ScannedCodeView: View {
    let code: String
    @State private var product: Product?
    @State private var errorMessage: String?
    @State private var isLoading = false
    @State private var customTitle = ""
    @State private var isSaved = false
    @State private var alertMessage: String?
    @State private var showAlert = false

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Результат сканирования")
                    .font(.title2)
                    .bold()

                if isLoading {
                    ProgressView("Загрузка...")
                } else if let product = product {
                    productInfoView(product)
                } else if let error = errorMessage {
                    Text("Ошибка: \(error)")
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                } else {
                    qrInfoView
                }

                Divider()

                if !isSaved {
                    VStack(spacing: 10) {
                        TextField("Введите название", text: $customTitle)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)

                        Button(action: saveCode) {
                            Label("Сохранить", systemImage: "tray.and.arrow.down.fill")
                        }
                        .buttonStyle(.borderedProminent)
                    }
                } else {
                    Label("Сохранено в истории", systemImage: "checkmark.circle.fill")
                        .foregroundColor(.green)
                }
            }
            .padding()
        }
        .onAppear {
            print("safgasdfads")
            print(code)
        }
        .task {
            await loadProductDataIfNeeded()
            checkIfAlreadySaved()
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Инфо"), message: Text(alertMessage ?? ""), dismissButton: .default(Text("OK")))
        }
    }

    // MARK: - Subviews

    private func productInfoView(_ product: Product) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(product.productName ?? "Без названия")
                .font(.headline)
            if let brand = product.brands {
                Text("Бренд: \(brand)")
            }
            if let ingredients = product.ingredientsText {
                Text("Ингредиенты: \(ingredients)")
            }
            if let score = product.nutriScore {
                Text("Nutri-Score: \(score.uppercased())")
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
    }

    private var qrInfoView: some View {
        VStack(spacing: 10) {
            Text("QR-код:")
                .font(.headline)
            Text(code)
                .font(.body)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
        }
    }

    // MARK: - Logic

    private func loadProductDataIfNeeded() async {
        guard code.allSatisfy({ $0.isNumber }) else { return } // QR — не загружаем
        isLoading = true
        defer { isLoading = false }

        do {
            let result = try await OpenFoodFactsService.shared.fetchProduct(barcode: code)
            product = result
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func checkIfAlreadySaved() {
        do {
            let saved = try ScanStorage.shared.fetchAll()
            isSaved = saved.contains { $0.rawValue == code }
        } catch {
            print("Ошибка проверки сохранённости: \(error)")
        }
    }

    private func saveCode() {
        do {
            let details = product != nil ? (try? JSONEncoder().encode(product)).flatMap { String(data: $0, encoding: .utf8) } : nil
            try ScanStorage.shared.saveScan(
                rawValue: code,
                codeType: code.allSatisfy({ $0.isNumber }) ? "barcode" : "qr",
                title: customTitle.isEmpty ? (product?.productName ?? code) : customTitle,
                details: details
            )
            isSaved = true
            alertMessage = "Код успешно сохранён!"
            showAlert = true
        } catch {
            alertMessage = "Ошибка при сохранении: \(error.localizedDescription)"
            showAlert = true
        }
    }
}
