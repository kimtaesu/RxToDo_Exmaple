//
//  MainViewModel.swift
//  RxTableView
//
//  Created by Milkyo on 29/07/2019.
//  Copyright © 2019 MilKyo. All rights reserved.
//

import CoreData
import Foundation

class MainViewModel: SendDataDelegate {
    var mainData = MainDataManager.sharedMainData
    var coreData = CoreDataManager.sharedCoreData

    func defaultData() {
        var loadMemo = [ToDoData]()

        do {
            guard let context = coreData.context else {
                return
            }
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ToDo")
            let loadData = try context.fetch(fetchRequest)

            for index in loadData {
                guard let id = index.value(forKey: "id") as? Int else {
                    return
                }

                guard let title = index.value(forKey: "title") as? String else {
                    return
                }

                guard let date = index.value(forKey: "date") as? String else {
                    return
                }

                guard let isCheck = index.value(forKey: "isCheck") as? Bool else {
                    return
                }

                loadMemo.append(ToDoData(id: id, title: title, date: date, isCheck: isCheck))
            }

            self.mainData.memo = loadMemo
        } catch {
            print(error.localizedDescription)
        }
    }

    func sendData(_ data: ToDoData) {
        self.mainData.memo.append(data)
    }

    init() {
        self.defaultData()
        print("INIT")
    }
}
