//
//  MainViewModel.swift
//  RxTableView
//
//  Created by Milkyo on 29/07/2019.
//  Copyright © 2019 MilKyo. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class MainViewModel: SendDataDelegate {

    var disposebag = DisposeBag()
    var memo = [MemoData]() {
        didSet {
            memoData.accept([SectionOfMemoData(items: self.memo)])
        }
    }
    var memoData =  BehaviorRelay<[SectionOfMemoData]>(value: [])
    var value = PublishSubject<ActionList>()

    func linkAction(action: ActionList) {
        switch action {
        case .apendItem(let newData):
            insertItem(str: newData)
        case .deleteItem(let index):
            removeItem(index)
        case .moveItem((let sourceIndex, let destinationIndex)):
            moveItem(sourceIndex, destinationIndex)
        }
        memoData.accept([SectionOfMemoData(items: self.memo)])
    }
    
    func removeItem(_ indexPath: IndexPath) {
        self.memo.remove(at: indexPath.row)
    }

    func moveItem(_ sourceIndexPath: IndexPath, _ destinationIndexPath: IndexPath) {
        let targetData = self.memo[sourceIndexPath.row]
        self.memo.remove(at: sourceIndexPath.row)
        self.memo.insert(targetData, at: destinationIndexPath.row)
    }

    func insertItem(str: String) {
        self.memo.append(MemoData(content: str))
    }

    func defalutData() {
        self.memo = [MemoData(content: "TEST"),MemoData(content: "TEST2")]
    }
    
    func sendData(_ data: MemoData) {
        self.memo.append(data)
    }
    
    init() {
        defalutData()
        value.bind(onNext: self.linkAction).disposed(by: disposebag)
    }
    
    deinit {
        disposebag = DisposeBag()
    }
}
