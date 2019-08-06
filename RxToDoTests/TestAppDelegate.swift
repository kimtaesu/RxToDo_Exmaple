//
//  TestAppDelegate.swift
//  RxToDoTests
//
//  Created by tskim on 06/08/2019.
//  Copyright © 2019 MilKyo. All rights reserved.
//

import UIKit
import CoreData
@testable import RxToDo

final class TestAppDelegate: AppDelegate {
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
        ) -> Bool {
        return true
    }
    func flushData() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: TODO_ENTIRY_NAME)
        let objs = try! self.persistentContainer.viewContext.fetch(fetchRequest)
        for case let obj as NSManagedObject in objs {
            self.persistentContainer.viewContext.delete(obj)
        }
        try! self.persistentContainer.viewContext.save()
        
    }
}
