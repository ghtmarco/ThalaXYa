//
//  Transaction+CoreDataProperties.swift
//  ThalaXYa
//
//  Created by Hush on 02/10/25.
//
//

public import Foundation
public import CoreData


public typealias TransactionCoreDataPropertiesSet = NSSet

extension Transaction {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Transaction> {
        return NSFetchRequest<Transaction>(entityName: "Transaction")
    }

    @NSManaged public var fishName: String?
    @NSManaged public var fishPrice: Double
    @NSManaged public var fishWeight: Double
    @NSManaged public var id: UUID?
    @NSManaged public var quantity: Int16
    @NSManaged public var totalPrice: Double
    @NSManaged public var transactionDate: Date?
    @NSManaged public var buyer: User?

}

extension Transaction : Identifiable {

}
