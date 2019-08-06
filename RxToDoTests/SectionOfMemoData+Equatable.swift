//
//  SectionOfMemoData+Equatable.swift
//  RxToDoTests
//
//  Created by tskim on 06/08/2019.
//  Copyright © 2019 MilKyo. All rights reserved.
//

import Foundation
@testable import RxToDo

extension SectionOfMemoData: Equatable {
    public static func == (lhs: SectionOfMemoData, rhs: SectionOfMemoData) -> Bool {
        return lhs.items == rhs.items
    }
}
