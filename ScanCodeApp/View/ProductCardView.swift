//
//  ProductCardView.swift
//  scanCodeApp
//
//  Created by Vladislav Andreev on 16.10.2025.
//

import Foundation
import SwiftUI

struct ProductCardView: View {
    let product: OFFProduct
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Заголовок
            Text(product.product_name ?? "Неизвестный товар")
                .font(.title3.weight(.semibold))
                .lineLimit(2)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Бренд + NutriScore
            HStack(spacing: 12) {
                if let brands = product.brands, !brands.isEmpty {
                    Label(brands, systemImage: "tag")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                if let grade = product.nutriscore_grade, !grade.isEmpty {
                    Label("NutriScore: \(grade.uppercased())", systemImage: "leaf")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            
            // Картинка (если есть)
            if let urlStr = product.image_url, let url = URL(string: urlStr) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 220)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    case .failure(_):
                        placeholder
                    case .empty:
                        ProgressView().frame(height: 120)
                    @unknown default:
                        placeholder
                    }
                }
            }
            
            // Ингредиенты
            if let ing = product.ingredients_text, !ing.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Ингредиенты").font(.headline)
                    Text(ing).font(.callout).foregroundStyle(.secondary)
                }
            }
            
            // Остальные поля компактно
            Grid(alignment: .leading, horizontalSpacing: 12, verticalSpacing: 6) {
                if let categories = product.categories, !categories.isEmpty {
                    row("Категории", categories)
                }
                if let qty = product.quantity, !qty.isEmpty {
                    row("Фасовка", qty)
                }
                if let packaging = product.packaging, !packaging.isEmpty {
                    row("Упаковка", packaging)
                }
                if let countries = product.countries, !countries.isEmpty {
                    row("Страны", countries)
                }
                if let stores = product.stores, !stores.isEmpty {
                    row("Магазины", stores)
                }
            }
        }
        .padding(16)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
    
    private var placeholder: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.secondary.opacity(0.08))
            Image(systemName: "photo")
                .imageScale(.large)
                .foregroundStyle(.secondary)
        }
        .frame(height: 120)
    }
    
    @ViewBuilder
    private func row(_ title: String, _ value: String) -> some View {
        GridRow {
            Text(title + ":")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)
            Text(value)
                .font(.subheadline)
        }
    }
}
