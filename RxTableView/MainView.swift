//
//  MainView.swift
//  RxTableView
//
//  Created by Milkyo on 29/07/2019.
//  Copyright © 2019 MilKyo. All rights reserved.
//

import UIKit

class MainView: UIView {
    let mainTableView: UITableView = {
        let mainTableView = UITableView()
        mainTableView.tableFooterView = UIView()
        return mainTableView
    }()

    func makeMainTableViewConstraint() {
        self.mainTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainTableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            mainTableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            mainTableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            mainTableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(self.mainTableView)
        self.makeMainTableViewConstraint()
        self.mainTableView.register(MainCell.self, forCellReuseIdentifier: "MainCell")
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
