//
//  DatePickerAlertController.swift
//  RxTableView
//
//  Created by Milkyo on 06/08/2019.
//  Copyright © 2019 MilKyo. All rights reserved.
//

import UIKit

class DatePickerAlertController: UIAlertController {
    lazy var targetView: UIView = {
        guard let targetView = view.subviews.first else {
            return UIView()
        }

        return targetView
    }()

    let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.timeZone = TimeZone.autoupdatingCurrent
        picker.datePickerMode = .date
        return picker
    }()

    func makeDatePickerConstraint() {
        self.datePicker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            datePicker.heightAnchor.constraint(equalToConstant: 250),
            datePicker.widthAnchor.constraint(equalTo: targetView.widthAnchor),
            datePicker.centerXAnchor.constraint(equalTo: targetView.centerXAnchor),
            datePicker.topAnchor.constraint(equalTo: targetView.topAnchor, constant: 85),
        ])
    }

    func getPreferredLocale() -> Locale {
        guard let preferredIdentifier = Locale.preferredLanguages.first else {
            return Locale.current
        }
        return Locale(identifier: preferredIdentifier)
    }

    func dateConvertToString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.locale = self.getPreferredLocale()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none

        return dateFormatter.string(from: self.datePicker.date)
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        self.targetView.addSubview(self.datePicker)
        self.datePicker.locale = self.getPreferredLocale()
        self.makeDatePickerConstraint()

        guard let backView = view else {
            return
        }

        backView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backView.heightAnchor.constraint(equalTo: datePicker.heightAnchor, multiplier: 1.0, constant: 200),
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
