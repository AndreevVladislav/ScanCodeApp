//
//  OFFProduct.swift
//  scanCodeApp
//
//  Created by Vladislav Andreev on 16.10.2025.
//

import Foundation

struct OFFProduct: Decodable {
    let product_name: String?
    let brands: String?
    let image_url: String?
    let ingredients_text: String?
    let nutriscore_grade: String?
    let categories: String?
    let quantity: String?
    let countries: String?
    let packaging: String?
    let stores: String?
}

// упрощенная модель товара
private struct OFFSlim: Decodable {
    let product_name: String?
    let ingredients_text: String?
    let brands: String?
    let nutriscore_grade: String?
}

// если JSON приходит как { "product": { ... } }
private struct OFFWrap: Decodable { let product: OFFSlim? }

func extractIngredients(from jsonString: String) -> String? {
    guard let data = jsonString.data(using: .utf8) else { return nil }
    let decoder = JSONDecoder()

    if let wrapped = try? decoder.decode(OFFWrap.self, from: data),
       let text = wrapped.product?.ingredients_text {
        return prettifyIngredients(text)
    }

    if let slim = try? decoder.decode(OFFSlim.self, from: data),
       let text = slim.ingredients_text {
        return prettifyIngredients(text)
    }

    // 3) универсальный fallback через JSONSerialization
    if let obj = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
       let text = obj["ingredients_text"] as? String {
        return prettifyIngredients(text)
    }

    return nil
}

// немного “косметики” для текста ингредиентов
private func prettifyIngredients(_ raw: String) -> String {
    var s = raw
    s = s.replacingOccurrences(of: "\\n", with: "\n")
    s = s.replacingOccurrences(of: " ,", with: ",")
         .replacingOccurrences(of: "( ", with: "(")
         .replacingOccurrences(of: " )", with: ")")
    s = s.trimmingCharacters(in: .whitespacesAndNewlines)
    return s
}
