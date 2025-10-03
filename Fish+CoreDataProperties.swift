//
//  Fish+CoreDataProperties.swift
//  ThalaXYa
//
//  Created by Hush on 02/10/25.
//
//

public import Foundation
public import CoreData


public typealias FishCoreDataPropertiesSet = NSSet

extension Fish {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Fish> {
        return NSFetchRequest<Fish>(entityName: "Fish")
    }

    @NSManaged public var dateAdded: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var price: Double
    @NSManaged public var weight: Double

}

extension Fish : Identifiable {

}
