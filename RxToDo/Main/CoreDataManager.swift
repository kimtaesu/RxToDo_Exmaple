//
//  CoreDataManager.swift
//  RxTableView
//
//  Created by Milkyo on 06/08/2019.
//  Copyright © 2019 MilKyo. All rights reserved.
//

import CoreData
import Foundation
import UIKit

final class CoreDataManager {
    static let sharedCoreData = CoreDataManager()

    lazy var context: NSManagedObjectContext? = {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext

            return context
        }

        return nil
    }()

//    lazy var fetchRequest: [NSManagedObject] = {
//        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
//            let context = appDelegate.persistentContainer.viewContext
//            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ToDo")
//            context
//           let test = try? context.fetch(fetchRequest)
//
//
//            return test ?? [NSManagedObject]()
//        }
//
//
//        guard let context = self.context
//        return [NSManagedObject]()
//    }()

    private init() {}
}
