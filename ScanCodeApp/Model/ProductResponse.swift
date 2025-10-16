//
//  ProductResponse.swift
//  scanCodeApp
//
//  Created by Vladislav Andreev on 16.10.2025.
//

import Foundation

struct ProductResponse: Codable {
    let status: Int
    let product: Product?
}
