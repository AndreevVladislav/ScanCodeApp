//
//  OpenFoodFactsService.swift
//  scanCodeApp
//
//  Created by Vladislav Andreev on 16.10.2025.
//

import Foundation

// Класс получения информации о продукте
final class OpenFoodFactsService {
    
    static let shared = OpenFoodFactsService()
    private init() {}

    func fetchProduct(barcode: String) async throws -> Product {
        let urlString = "\(Constants.API.baseURL)/product/\(barcode).json"
        guard let url = URL(string: urlString) else { throw APIError.invalidURL }

        let (data, response) = try await URLSession.shared.data(from: url)
        guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
            throw APIError.badResponse
        }

        let decoded = try JSONDecoder().decode(ProductResponse.self, from: data)
        guard decoded.status == 1, let product = decoded.product else {
            throw APIError.notFound
        }

        return product
    }

    enum APIError: LocalizedError {
        case invalidURL
        case badResponse
        case notFound
        case decodingError

        var errorDescription: String? {
            switch self {
            case .invalidURL: return "Некорректный адрес запроса"
            case .badResponse: return "Ошибка при получении данных с сервера"
            case .notFound: return "Информация о продукте не найдена"
            case .decodingError: return "Ошибка при обработке ответа"
            }
        }
    }
}
