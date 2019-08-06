//
//  AddToDoViewModel.swift
//  RxTableView
//
//  Created by Milkyo on 05/08/2019.
//  Copyright © 2019 MilKyo. All rights reserved.
//

import CoreData
import Foundation
import RxCocoa
import RxSwift

class AddToDoViewModel {
    var disposeBag = DisposeBag()
    var currentDataCounter = 0
    var newMemoData: ToDoData?
    var delegate: SendDataDelegate?
    var textFieldData = PublishSubject<String>()
    var isEmptyTextField = BehaviorSubject<Bool>(value: false)
    var todoDateData = BehaviorSubject<String>(value: "날짜 지정")
    let coreData = CoreDataManager.sharedCoreData

    func saveData() {
        if let sendData = newMemoData {
            if let context = coreData.context {
                let object = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: context)
                object.setValue(sendData.id, forKey: "id")
                object.setValue(sendData.title, forKey: "title")
                object.setValue(sendData.date, forKey: "date")
                object.setValue(sendData.isCheck, forKey: "isCheck")

                do {
                    try context.save()
                } catch {
                    context.rollback()
                }
            }

            self.delegate?.sendData(sendData)
        }
    }

    func combineData() {
        Observable.combineLatest(self.textFieldData,
                                 self.todoDateData,
                                 resultSelector: { str1, str2 in ToDoData(id: self.currentDataCounter, title: str1, date: str2) })
            .bind(onNext: { [weak self] in self?.newMemoData = $0 })
            .disposed(by: self.disposeBag)
    }

    func bindTextField() {
        self.textFieldData
            .map { $0.trimmingCharacters(in: .whitespaces) != "" }
            .bind(to: self.isEmptyTextField)
            .disposed(by: self.disposeBag)
    }

    init() {
        self.bindTextField()
        self.combineData()
    }

    deinit {
        self.disposeBag = DisposeBag()
    }
}
