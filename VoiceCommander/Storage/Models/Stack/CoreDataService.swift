//
//  CoreDataService.swift
//  AppolyTemplate
//
//  Created by James Wolfe on 30/01/2023.
//

import Foundation
import CoreData

final class CoreDataService: NSObject {

    // MARK: - Variables
    private static var service: CoreDataService?
    fileprivate let databaseURL: URL = {
        guard let databaseDirectoryURL =
                FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
            fatalError("Cannot access application support area")
        }

        return databaseDirectoryURL.appendingPathComponent("AppolyTemplate.sqlite")
    }()
    
    /// Context used to interact with core data
    var context: NSManagedObjectContext {
        return container.viewContext
    }

    private lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "AppolyTemplate")
        if FileManager.default.fileExists(atPath: databaseURL.path) && Configuration.encryptCoreData {
            do {
                let attributes = [FileAttributeKey.protectionKey: FileProtectionType.complete]
                try FileManager.default.setAttributes(attributes, ofItemAtPath: databaseURL.path)
            } catch {
                fatalError("Failed to protect existing database file: \(error) at: \(databaseURL)")
            }
        }

        let description = NSPersistentStoreDescription(url: databaseURL)
        description.shouldInferMappingModelAutomatically = true
        description.shouldMigrateStoreAutomatically = true
        description.setOption(FileProtectionType.complete as NSObject, forKey: NSPersistentStoreFileProtectionKey)
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Error loading persistent store: \(error), \(error.userInfo)")
            }
        }

        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergePolicy.overwrite
        return container
    }()
    
    /// Shared instance of the core data service
    class var shared: CoreDataService {
        service = service == nil ? CoreDataService() : service
        return service!
    }

    // MARK: - Actions
    
    /// Fetches an managed object from core data
    /// - Parameter predicate: Predicate used to specify the details of thee object we're fetching
    /// - Returns: A managed object matching our optional predicate, if it exists
    func fetchEntity<T>(predicate: NSPredicate? = nil) throws -> T? {
        guard Thread.isMainThread else { fatalError(CoreDataError.mustBeMainThread.localizedDescription) }
        let context = container.viewContext

        guard let type = T.self as? NSManagedObject.Type else {
            fatalError(CoreDataError.invalidType.localizedDescription)
        }
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: NSStringFromClass(type))
        request.predicate = predicate

        let result = try? context.fetch(request).first as? T
        return result
    }

    /// Fetches an array of managed object from core data
    /// - Parameter predicate: Predicate used to specify the details of the objects we're fetching
    /// - Returns: An array of managed objects matching our optional predicate
    func fetchEntities<T>(predicate: NSPredicate? = nil) throws -> [T] {
        guard Thread.isMainThread else { fatalError(CoreDataError.mustBeMainThread.localizedDescription) }
        let context = container.viewContext

        guard let type = T.self as? NSManagedObject.Type else {
            fatalError(CoreDataError.invalidType.localizedDescription)
        }
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: NSStringFromClass(type))
        request.predicate = predicate

        let result = (try context.fetch(request) as? [T]) ?? []
        return result
    }

}

enum CoreDataError: Error {
    case invalidType
    case mustBeMainThread
}

extension CoreDataError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidType:
            return "CoreDataError.InvalidTypeError".localized
        case .mustBeMainThread:
            return NSLocalizedString("CoreDataError.MustBeMainThread.Text", comment: "")
        }
    }
}

extension NSPredicate: @unchecked Sendable { }
