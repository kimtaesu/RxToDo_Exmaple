//
//  MainTableViewCell.swift
//  RxTableView
//
//  Created by Milkyo on 29/07/2019.
//  Copyright © 2019 MilKyo. All rights reserved.
//

import UIKit

class MainCell: UITableViewCell {
    let mainTitleLabel: UILabel = {
        let mainTitleLabel = UILabel()
        mainTitleLabel.textColor = .black
        mainTitleLabel.font = UIFont.systemFont(ofSize: 16)
        return mainTitleLabel
    }()

    func makeMainTitleLabelConstraint() {
        self.mainTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainTitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            mainTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainTitleLabel.heightAnchor.constraint(equalToConstant: 20),
        ])
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(self.mainTitleLabel)
        self.makeMainTitleLabelConstraint()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
