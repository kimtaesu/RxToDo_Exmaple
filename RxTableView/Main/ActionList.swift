//
//  ActionList.swift
//  RxTableView
//
//  Created by Milkyo on 05/08/2019.
//  Copyright © 2019 MilKyo. All rights reserved.
//

import Foundation

enum ActionList {
    case apendItem(_ newData: String)
    case moveItem((indexList: IndexPath, destinationIndex: IndexPath))
    case deleteItem(_ index: IndexPath)
}

