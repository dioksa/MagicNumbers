//
//  MainViewModel.swift
//  MagicNumbers
//
//  Created by Oksana Dionisieva on 18.09.2025.
//

final class MainViewModel {
    private let repository: FactRepository
    private(set) var history: [FactEntity] = []

    init(repository: FactRepository) {
        self.repository = repository
        loadHistory()
    }

    private func loadHistory() {
        do {
            history = try repository.fetchAll()
        } catch {
            history = []
        }
    }

    func numberOfItems() -> Int { history.count }

    func item(at index: Int) -> FactEntity { history[index] }

    func refresh() { loadHistory() }

    func delete(at index: Int) throws {
        let obj = history[index]
        try repository.delete(obj)
        loadHistory()
    }

    func getFact(for number: String) async throws -> String {
        // TODO: - Add fetch request here
        loadHistory()
        return ""
    }

    func getRandomFact() async throws -> (number: String, fact: String) {
        // TODO: - Add fetch request here
        loadHistory()
        return ("", "")
    }
}
