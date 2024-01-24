//
//  CoreDataCache.swift
//  GitHubTest
//
//  Created by Volodymyr Milichenko on 24/01/2024.
//

import CoreData

enum StorageType {
  case persistent, inMemory
}

final class CoreDataCache {
    private let persistentContainer: NSPersistentContainer
    
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

    private func saveContext() {
        let context = persistentContainer.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    private func clearStorageForEntity(entityName: String) {
        let managedObjectContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try managedObjectContext.execute(batchDeleteRequest)
        } catch let error as NSError {
            print(error)
        }
    }

    private func fetchObjects<T: NSManagedObject>() -> [T] {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<T>(entityName: String.init(describing: T.self))
        
        do {
            let result = try context.fetch(fetchRequest)
            return result
        } catch {
            print("Failed to fetch objects: \(error)")
            return []
        }
    }
}

extension CoreDataCache: CacheType {
    func fetchObjects() -> [User] {
        let usersManaged: [UserManagedObject] = fetchObjects()

        return usersManaged.map {
            User(
                id: Int($0.id),
                name: $0.name ?? "",
                avatarUrl: $0.avatarUrl ?? ""
            )
        }
    }
    
    func saveObjects(_ objects: [User]) {
        let context = persistentContainer.newBackgroundContext()
        
        context.performAndWait {
            objects.forEach { user in
                do {
                    guard let entity = NSEntityDescription.entity(
                        forEntityName: String.init(describing: UserManagedObject.self),
                        in: context
                    ) else {
                        return
                    }
                    
                    guard let userManaged = NSManagedObject(
                        entity: entity,
                        insertInto: context
                    ) as? UserManagedObject else {
                        return
                    }
                    
                    userManaged.id = Int32(user.id)
                    userManaged.name = user.name
                    userManaged.avatarUrl = user.avatarUrl
                    
                    try context.save()
                } catch {
                    assertionFailure("CoreData saving error")
                }
                
            }
        }
    }
    
    func clearStorage() {
        clearStorageForEntity(entityName: String(describing: UserManagedObject.self))
    }
}

extension CoreDataCache {
    enum StorageType {
        case persistent
        case inMemory
    }
}
