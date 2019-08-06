//
//  MainViewModel.swift
//  RxTableView
//
//  Created by Milkyo on 29/07/2019.
//  Copyright © 2019 MilKyo. All rights reserved.
//

import CoreData
import Foundation
import RxCocoa
import RxSwift

class MainViewModel: SendDataDelegate {
    var disposebag = DisposeBag()
    var memo = [ToDoData]() {
        didSet {
            self.memoData.accept([SectionOfMemoData(items: self.memo)])
        }
    }

    var memoData = BehaviorRelay<[SectionOfMemoData]>(value: [])
    var actionEvent = PublishSubject<ActionList>()
    var isEdit = BehaviorRelay<Bool>(value: false)

    func linkAction(action: ActionList) {
        switch action {
        case let .deleteItem(index):
            self.removeItem(index)
        case let .moveItem((sourceIndex, destinationIndex)):
            self.moveItem(sourceIndex, destinationIndex)
        }
        self.memoData.accept([SectionOfMemoData(items: self.memo)])
    }

    func removeItem(_ indexPath: IndexPath) {
        self.memo.remove(at: indexPath.row)
        self.removeData(removeIndex: indexPath.row)
    }

    func moveItem(_ sourceIndexPath: IndexPath, _ destinationIndexPath: IndexPath) {
        let targetData = self.memo[sourceIndexPath.row]
        self.memo.remove(at: sourceIndexPath.row)
        self.memo.insert(targetData, at: destinationIndexPath.row)
    }

    func removeData(removeIndex: Int) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
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
    }

    func defaultData() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ToDo")
            var loadMemo = [ToDoData]()

            do {
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

                self.memo = loadMemo
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    func sendData(_ data: ToDoData) {
        self.memo.append(data)
        print(self.memo)
    }

    init() {
        self.defaultData()
        self.actionEvent
            .bind(onNext: self.linkAction)
            .disposed(by: self.disposebag)
    }

    deinit {
        disposebag = DisposeBag()
    }
}
