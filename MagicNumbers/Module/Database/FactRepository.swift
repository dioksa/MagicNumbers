//
//  FactRepository.swift
//  MagicNumbers
//
//  Created by Oksana Dionisieva on 18.09.2025.
//

import UIKit
import CoreData

final class FactRepository {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func save(number: String, fact: String) throws {
        let entity = FactEntity(context: context)
        entity.id = UUID()
        entity.numberText = number
        entity.factText = fact
        entity.date = Date()
        try context.save()
    }

    func fetchAll() throws -> [FactEntity] {
        let req: NSFetchRequest<FactEntity> = FactEntity.fetchRequest()
        req.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        return try context.fetch(req)
    }

    func delete(_ object: FactEntity) throws {
        context.delete(object)
        try context.save()
    }
}
