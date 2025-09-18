//
//  NumbersAPIService.swift
//  MagicNumbers
//
//  Created by Oksana Dionisieva on 18.09.2025.
//

import UIKit

protocol NumbersAPIServiceProtocol {
    func fact(for number: String) async throws -> String
    func randomMathFact() async throws -> (number: String, fact: String)
}

enum NumbersAPIError: String, Error {
    case invalidURL = "Invalid URL. \nCannot fetch number fact."
    case invalidResponse = "Invalid response. \nPlease check the number or try again later."
}

final class NumbersAPIService: NumbersAPIServiceProtocol {
    func fact(for number: String) async throws -> String {
        guard let url = URL(string: "http://numbersapi.com/\(number)") else { throw NumbersAPIError.invalidURL }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else { throw NumbersAPIError.invalidResponse }
        guard let text = String(data: data, encoding: .utf8) else { throw NumbersAPIError.invalidResponse }
        return text
    }

    func randomMathFact() async throws -> (number: String, fact: String) {
        guard let url = URL(string: "http://numbersapi.com/random/math") else { throw NumbersAPIError.invalidURL }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else { throw NumbersAPIError.invalidResponse }
        guard let text = String(data: data, encoding: .utf8) else { throw NumbersAPIError.invalidResponse }
        // Attempt to extract leading number token
        let tokens = text.split(separator: " ")
        let first = tokens.first.map(String.init) ?? ""
        let numberCandidate = first.trimmingCharacters(in: .punctuationCharacters)
        return (numberCandidate, text)
    }
}
