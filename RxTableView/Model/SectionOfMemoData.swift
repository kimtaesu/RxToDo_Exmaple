//
//  SectionOfMemoData.swift
//  RxTableView
//
//  Created by Milkyo on 05/08/2019.
//  Copyright © 2019 MilKyo. All rights reserved.
//

import Foundation
import RxDataSources

struct SectionOfMemoData {
    var items: [Item]
}

extension SectionOfMemoData: SectionModelType {
    typealias Item = ToDoData

    init(original: SectionOfMemoData, items: [Item]) {
        self = original
        self.items = items
    }
}
