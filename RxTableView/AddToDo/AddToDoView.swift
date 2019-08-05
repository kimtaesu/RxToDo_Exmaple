//
//  AddToDoView.swift
//  RxTableView
//
//  Created by Milkyo on 05/08/2019.
//  Copyright © 2019 MilKyo. All rights reserved.
//

import UIKit

protocol SendDataDelegate {
    func sendData(_ data: MemoData)
}
class AddTodoView: UIViewController {
    
    var delegate: SendDataDelegate?
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        self.view = view
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let memo = MemoData(content: "AA")
        delegate?.sendData(memo)
    }
}
