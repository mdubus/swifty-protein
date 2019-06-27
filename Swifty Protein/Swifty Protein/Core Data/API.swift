//
//  API.swift
//  Swifty Protein
//
//  Created by Morgane DUBUS on 6/27/19.
//  Copyright © 2019 Morgane DUBUS. All rights reserved.
//

import Foundation
import UIKit
import CoreData

let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

func getCount(_ entityName: String) -> Int {
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
    do {
        let count = try context.count(for: fetchRequest)
        return count
    }
    catch let error {
        print(error)
    }
    return 0
}

func deleteAllEntities(_ entity:String) {
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
    fetchRequest.returnsObjectsAsFaults = false
    do {
        let results = try context.fetch(fetchRequest)
        for object in results {
            guard let objectData = object as? NSManagedObject else {continue}
            context.delete(objectData)
        }
    } catch let error {
        print("Detele all data in \(entity) error :", error)
    }
}

func fetchAllMolecules() -> [Molecules] {
    let request: NSFetchRequest<Molecules> = Molecules.fetchRequest()
    do {
        let molecules = try context.fetch(request)
        return molecules
    }
    catch let error {
        print("Error fetching molecules : ", error)
        return []
    }
    
}
