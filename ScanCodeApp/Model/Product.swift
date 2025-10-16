//
//  Product.swift
//  scanCodeApp
//
//  Created by Vladislav Andreev on 16.10.2025.
//

import Foundation

struct Product: Codable {
    let productName: String?
    let brands: String?
    let ingredientsText: String?
    let nutriScore: String?

    enum CodingKeys: String, CodingKey {
        case productName = "product_name"
        case brands
        case ingredientsText = "ingredients_text"
        case nutriScore = "nutriscore_grade"
    }
}
