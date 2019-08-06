//
//  ToDoData+Equatable.swift
//  RxToDoTests
//
//  Created by tskim on 06/08/2019.
//  Copyright © 2019 MilKyo. All rights reserved.
//

import Foundation
@testable import RxToDo

extension ToDoData: Equatable {
    public static func == (lhs: ToDoData, rhs: ToDoData) -> Bool {
        return lhs.date == rhs.date &&
            lhs.isCheck == rhs.isCheck &&
            lhs.title == rhs.title
    }
}
