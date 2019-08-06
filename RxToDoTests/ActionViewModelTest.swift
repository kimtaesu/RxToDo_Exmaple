//
//  ActionViewModelTest.swift
//  RxToDoTests
//
//  Created by tskim on 06/08/2019.
//  Copyright © 2019 MilKyo. All rights reserved.
//

import Foundation
import XCTest
import RxTest
import RxSwift
@testable import RxToDo

class ActionViewModelTest: XCTestCase {

    var addViewModel: AddToDoViewModel!
    var actionViewModel: ActionViewModel!
    var mainViewModel: MainViewModel!
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()
        scheduler = TestScheduler(initialClock: 0, simulateProcessingDelay: false)
        disposeBag = DisposeBag()
        addViewModel = AddToDoViewModel()
        actionViewModel = ActionViewModel()
        mainViewModel = MainViewModel()
    }

    override func tearDown() {
        super.tearDown()
        (UIApplication.shared.delegate as! TestAppDelegate).flushData()
    }
    
    func testActionInsertion() {
        addViewModel.newMemoData = ToDoData.sample
        addViewModel.saveData()

        let data = scheduler.createObserver([SectionOfMemoData].self)
        mainViewModel.mainData.memoData.bind(to: data).disposed(by: disposeBag)

        mainViewModel.defaultData()
        scheduler.start()

        XCTAssertEqual(data.events, [
                .next(0, [SectionOfMemoData(items: [])]),
                .next(0, [SectionOfMemoData(items: [ToDoData.sample])])
            ])
    }
    func testActionRemove() {
        let data = scheduler.createObserver([SectionOfMemoData].self)
        mainViewModel.mainData.memoData.bind(to: data).disposed(by: disposeBag)

        addViewModel.newMemoData = ToDoData.sample
        addViewModel.saveData()
        mainViewModel.defaultData()
        
        let remove = scheduler.createObserver(ActionList.self)
        actionViewModel.actionEvent
            .bind(to: remove)
            .disposed(by: disposeBag)

        scheduler.createHotObservable([
            .next(50, ActionList.deleteItem(IndexPath(row: 0, section: 0)))
            ])
            .bind(to: actionViewModel.actionEvent)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertEqual(data.events, [
            .next(0, [SectionOfMemoData(items: [])]),
            .next(0, [SectionOfMemoData(items: [ToDoData.sample])]),
            .next(50, [SectionOfMemoData(items: [])]),
            .next(50, [SectionOfMemoData(items: [])])
            ])
    }
}

extension ToDoData {
    static var sample: ToDoData {
        return ToDoData(id: 0, title: "sample", date: "date", isCheck: false)
    }
}
