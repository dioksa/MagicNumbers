//
//  MainViewModel.swift
//  MagicNumbers
//
//  Created by Oksana Dionisieva on 18.09.2025.
//

import UIKit

final class MainViewModel {
    // MARK: - Private properties
    private let repository: FactRepository
    private let apiService: NumbersAPIServiceProtocol
    private(set) var history: [FactEntity] = []

    // MARK: - Public property
    var showError: ((String) -> Void)?

    init(repository: FactRepository, apiService: NumbersAPIServiceProtocol = NumbersAPIService()) {
        self.repository = repository
        self.apiService = apiService
        loadHistory()
    }

    // MARK: - Public methods
    func numberOfItems() -> Int { history.count }

    func item(at index: Int) -> FactEntity { history[index] }

    func refresh() { loadHistory() }

    func delete(at index: Int) throws {
        let obj = history[index]
        try repository.delete(obj)
        loadHistory()
    }

    func getFact(for number: String) async {
        do {
            let text = try await apiService.fact(for: number)
            try repository.save(number: number, fact: text)
            loadHistory()
        } catch let error as NumbersAPIError {
            showError?(error.rawValue)
        } catch {
            showError?("Unknown error: \(error.localizedDescription)")
        }
    }

    func getRandomFact() async {
        do {
            let res = try await apiService.randomMathFact()
            try repository.save(number: res.number, fact: res.fact)
            loadHistory()
        } catch let error as NumbersAPIError {
            showError?(error.rawValue)
        } catch {
            showError?("Unknown error: \(error.localizedDescription)")
        }
    }

    // MARK: - Private part
    private func loadHistory() {
        do {
            history = try repository.fetchAll()
        } catch {
            history = []
        }
    }
}
