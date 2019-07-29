//
//  MainViewModel.swift
//  RxTableView
//
//  Created by Milkyo on 29/07/2019.
//  Copyright © 2019 MilKyo. All rights reserved.
//

import Foundation
import RxCocoa
import RxDataSources
import RxSwift

struct MemoData {
    var content: String
}

struct SectionOfCustomData {
    var items: [Item]
}

extension SectionOfCustomData: SectionModelType {
    typealias Item = MemoData

    init(original: SectionOfCustomData, items: [Item]) {
        self = original
        self.items = items
    }
}

class MainViewModel {
    var memo = [MemoData]()
    var memoItems = BehaviorRelay<[MemoData]>(value: [])

    func removeItem(indexPath: IndexPath) {
        self.memo.remove(at: indexPath.row)
        self.memoItems.accept(self.memo)
    }

    func moveItem(sourceIndexPath: IndexPath, destinationIndexPath: IndexPath) {
        let targetData = self.memo[sourceIndexPath.row]
        self.memo.remove(at: sourceIndexPath.row)
        self.memo.insert(targetData, at: destinationIndexPath.row)
        self.memoItems.accept(self.memo)
    }

    func insertItem(str: String) {
        self.memo.append(MemoData(content: str))
        self.memoItems.accept(self.memo)
    }

    init() {
        self.memoItems.accept(self.memo)
    }
}
