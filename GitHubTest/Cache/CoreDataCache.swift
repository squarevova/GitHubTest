//
//  CoreDataCache.swift
//  GitHubTest
//
//  Created by Volodymyr Milichenko on 24/01/2024.
//

import CoreData

final class CoreDataCache {
    private let persistentContainer: NSPersistentContainer
    
    // MARK: - Init
    
    init(storageType: StorageType = .persistent) {
        self.persistentContainer = NSPersistentContainer(name: "UsersCacheModel")

        if storageType == .inMemory {
            let description = NSPersistentStoreDescription()
            description.url = URL(fileURLWithPath: "/dev/null")
            self.persistentContainer.persistentStoreDescriptions = [description]
        }
        
        self.persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
    // MARK: - Private methods
    
    private func clearStorageForEntity(entityName: String) throws {
        let context = persistentContainer.newBackgroundContext()
        
        try context.performAndWait {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            try context.execute(batchDeleteRequest)
        }
    }

    private func fetchObjects<T: NSManagedObject>() throws -> [T] {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<T>(entityName: String.init(describing: T.self))
        
        return try context.fetch(fetchRequest)
    }
    
    private func saveObjects<T>(
        _ objects: [T],
        entityName: String,
        mapping: (NSManagedObject, T) -> Void
    ) throws {
        let context = persistentContainer.newBackgroundContext()
        
        try context.performAndWait {
            try objects.forEach { object in
                guard let entity = NSEntityDescription.entity(
                    forEntityName: entityName,
                    in: context
                ) else {
                    throw NSError(
                        domain: "CoreData",
                        code: -1,
                        userInfo: [NSLocalizedDescriptionKey: "Incorrect entity name for saving: \(entityName)"]
                    )
                }
                
                let forecastManaged = NSManagedObject(entity: entity, insertInto: context)
                
                mapping(forecastManaged, object)
            }
            
            try context.save()
        }
    }
}

extension CoreDataCache: CacheType {
    func loadObjects() -> [User]? {
        do {
            let usersManaged: [UserManagedObject] = try fetchObjects()
            
            return usersManaged.map {
                User(
                    id: Int($0.id),
                    name: $0.name ?? "",
                    avatarUrl: $0.avatarUrl ?? "",
                    followersUrl: $0.followersUrl ?? "",
                    reposUrl: $0.reposUrl ?? ""
                )
            }
        } catch {
            assertionFailure("Load objects error: \(error)")
            return []
        }
    }
    
    func saveObjects(_ objects: [User]) {
        let entityName = String(describing: UserManagedObject.self)
        
        do {
            try clearStorageForEntity(entityName: entityName)
            
            try saveObjects(objects, entityName: entityName) { managedObject, user in
                guard let userManaged = managedObject as? UserManagedObject else {
                    assertionFailure("Incorrect managed object: \(entityName)")
                    return
                }
                
                userManaged.id = Int32(user.id)
                userManaged.name = user.name
                userManaged.avatarUrl = user.avatarUrl
                userManaged.followersUrl = user.followersUrl
                userManaged.reposUrl = user.reposUrl
            }
        } catch {
            assertionFailure("Save objects to Core Data error: \(error)")
        }
    }
}

extension CoreDataCache {
    enum StorageType {
        case persistent
        case inMemory
    }
}
