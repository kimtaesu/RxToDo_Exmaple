//
//  ActionViewModel.swift
//  RxTableView
//
//  Created by Milkyo on 06/08/2019.
//  Copyright © 2019 MilKyo. All rights reserved.
//

import CoreData
import Foundation
import RxCocoa
import RxSwift

class ActionViewModel {
    var mainData = MainDataManager.sharedMainData
    var coreData = CoreDataManager.sharedCoreData
    var disposebag = DisposeBag()
    var actionEvent = PublishSubject<ActionList>()

    func linkAction(action: ActionList) {
        switch action {
        case let .deleteItem(index):
            self.removeItem(index)
        case let .moveItem((sourceIndex, destinationIndex)):
            self.moveItem(sourceIndex, destinationIndex)
        case let .checkItem(index):
            self.checkItem(index)
        }
        self.mainData.memoData.accept([SectionOfMemoData(items: mainData.memo)])
    }

    func checkItem(_ index: Int) {
        self.mainData.memo[index - 1].isCheck = !self.mainData.memo[index - 1].isCheck
        self.chagneData(index)
    }

    func chagneData(_ index: Int) {
        guard let context = coreData.context else {
            return
        }

        do {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ToDo")
            let toDoData = try context.fetch(fetchRequest)

            for content in toDoData {
                if index == content.value(forKey: "id") as? Int {
                    content.setValue(self.mainData.memo[index - 1].isCheck, forKey: "isCheck")
                }
            }

            try context.save()

        } catch {
            context.rollback()
        }
    }

    func removeItem(_ indexPath: IndexPath) {
        let removeIndex = self.mainData.memo[indexPath.row].id
        self.mainData.memo.remove(at: indexPath.row)
        self.removeData(removeIndex)
    }

    func removeData(_ removeIndex: Int) {
        guard let context = coreData.context else {
            return
        }
        let nsToDoRequest = NSFetchRequest<NSManagedObject>(entityName: "ToDo")

        do {
            let toDoData = try context.fetch(nsToDoRequest)

            for content in toDoData {
                if removeIndex == content.value(forKey: "id") as? Int {
                    context.delete(content)
                }
            }
            try context.save()

        } catch {
            context.rollback()
        }
    }

    func moveItem(_ sourceIndexPath: IndexPath, _ destinationIndexPath: IndexPath) {
        let targetData = self.mainData.memo[sourceIndexPath.row]
        self.mainData.memo.remove(at: sourceIndexPath.row)
        self.mainData.memo.insert(targetData, at: destinationIndexPath.row)
    }

    init() {
        self.actionEvent
            .bind(onNext: self.linkAction)
            .disposed(by: self.disposebag)
    }
}
