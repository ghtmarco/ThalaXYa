//
//  CoreDataManager.swift
//  ThalaXYa
//
//  Created by Hush on 02/10/25.
//

import UIKit
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    let context: NSManagedObjectContext
    
    private init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Unable to get AppDelegate")
        }
        context = appDelegate.persistentContainer.viewContext
    }
    
    func createUser(email: String, password: String, name: String, role: String, balance: Double = 0) -> Bool {
        let user = NSEntityDescription.insertNewObject(forEntityName: "User", into: context)
        user.setValue(UUID(), forKey: "id")
        user.setValue(email, forKey: "email")
        user.setValue(password, forKey: "password")
        user.setValue(name, forKey: "name")
        user.setValue(role, forKey: "role")
        user.setValue(balance, forKey: "balance")
        
        return saveContext()
    }
    
    func checkUserExists(email: String) -> Bool {
        let request = NSFetchRequest<NSManagedObject>(entityName: "User")
        request.predicate = NSPredicate(format: "email == %@", email)
        
        do {
            let results = try context.fetch(request)
            return !results.isEmpty
        } catch {
            print("Error checking user: \(error)")
            return false
        }
    }
    
    func loginUser(email: String, password: String) -> NSManagedObject? {
        let request = NSFetchRequest<NSManagedObject>(entityName: "User")
        request.predicate = NSPredicate(format: "email == %@ AND password == %@", email, password)
        
        do {
            let results = try context.fetch(request)
            return results.first
        } catch {
            print("Error logging in: \(error)")
            return nil
        }
    }
    
    func saveContext() -> Bool {
        if context.hasChanges {
            do {
                try context.save()
                return true
            } catch {
                print("Error saving context: \(error)")
                return false
            }
        }
        return true
    }
    
    func createFish(name: String, weight: Double, price: Double, dateAdded: Date = Date()) -> Bool {
        let fish = NSEntityDescription.insertNewObject(forEntityName: "Fish", into: context)
        fish.setValue(UUID(), forKey: "id")
        fish.setValue(name, forKey: "name")
        fish.setValue(weight, forKey: "weight")
        fish.setValue(price, forKey: "price")
        fish.setValue(dateAdded, forKey: "dateAdded")
        
        return saveContext()
    }
    
    func getAllFish() -> [NSManagedObject] {
        let request = NSFetchRequest<NSManagedObject>(entityName: "Fish")
        
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching fish: \(error)")
            return []
        }
    }
    
    func updateFish(fish: NSManagedObject, name: String, weight: Double, price: Double) -> Bool {
        fish.setValue(name, forKey: "name")
        fish.setValue(weight, forKey: "weight")
        fish.setValue(price, forKey: "price")
        
        return saveContext()
    }
    
    func deleteFish(fish: NSManagedObject) -> Bool {
        context.delete(fish)
        return saveContext()
    }
    
    func createTransaction(fishName: String, fishWeight: Double, fishPrice: Double, quantity: Int, totalPrice: Double, buyer: NSManagedObject) -> Bool {
        let transaction = NSEntityDescription.insertNewObject(forEntityName: "Transaction", into: context)
        transaction.setValue(UUID(), forKey: "id")
        transaction.setValue(fishName, forKey: "fishName")
        transaction.setValue(fishWeight, forKey: "fishWeight")
        transaction.setValue(fishPrice, forKey: "fishPrice")
        transaction.setValue(Int16(quantity), forKey: "quantity")
        transaction.setValue(totalPrice, forKey: "totalPrice")
        transaction.setValue(Date(), forKey: "transactionDate")
        transaction.setValue(buyer, forKey: "buyer")
        
        return saveContext()
    }

    func getAllTransactions() -> [NSManagedObject] {
        let request = NSFetchRequest<NSManagedObject>(entityName: "Transaction")
        request.sortDescriptors = [NSSortDescriptor(key: "transactionDate", ascending: false)]
        
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching transactions: \(error)")
            return []
        }
    }

    func getTransactionsForUser(user: NSManagedObject) -> [NSManagedObject] {
        let request = NSFetchRequest<NSManagedObject>(entityName: "Transaction")
        request.predicate = NSPredicate(format: "buyer == %@", user)
        request.sortDescriptors = [NSSortDescriptor(key: "transactionDate", ascending: false)]
        
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching user transactions: \(error)")
            return []
        }
    }

    func updateUserBalance(user: NSManagedObject, newBalance: Double) -> Bool {
        user.setValue(newBalance, forKey: "balance")
        return saveContext()
    }
}
