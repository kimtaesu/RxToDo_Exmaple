//
//  MainViewModelTest.swift
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

class MainViewModelTest: XCTestCase {

    var viewModel: MainViewModel!

    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()
        scheduler = TestScheduler(initialClock: 0, simulateProcessingDelay: false)
        disposeBag = DisposeBag()
        viewModel = MainViewModel()

    }
    func testLoadEmptyMemo() {
        let memoData = scheduler.createObserver([SectionOfMemoData].self)
        
        scheduler.start()
        XCTAssertTrue(memoData.events.isEmpty)
    }
}
