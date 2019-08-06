//
//  AddToDoView.swift
//  RxTableView
//
//  Created by Milkyo on 05/08/2019.
//  Copyright © 2019 MilKyo. All rights reserved.
//

import CoreData
import RxCocoa
import RxSwift
import UIKit

class AddTodoView: UIViewController {
    var addToDoViewModel = AddToDoViewModel()
    var disposeBag = DisposeBag()

    var addOwnView: AddToDoLayout {
        return self.view as! AddToDoLayout
    }

    func dissmissView() {
        self.disposeBag = DisposeBag()
        self.dismiss(animated: true)
    }

    func activateButton(isData: Bool) {
        if isData != true {
            self.navigationItem.rightBarButtonItem = nil
        } else {
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: nil)
            self.navigationItem.rightBarButtonItem = doneButton

            doneButton.rx.tap.asDriver()
                .do(onNext: self.addToDoViewModel.saveData)
                .drive(onNext: self.dissmissView)
                .disposed(by: self.disposeBag)
        }
    }

    func bindNavigationBuutton() {
        let dismissButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: nil)
        self.navigationItem.leftBarButtonItem = dismissButton
        dismissButton.rx.tap.asDriver()
            .drive(onNext: self.dissmissView)
            .disposed(by: self.disposeBag)
    }

    func bindeTextField() {
        self.addOwnView.toDoTitleTextFiled.rx.text.orEmpty
            .bind(to: self.addToDoViewModel.textFieldData)
            .disposed(by: self.disposeBag)

        self.addToDoViewModel.isEmptyTextField
            .bind(onNext: self.activateButton)
            .disposed(by: self.disposeBag)
    }

    func bindUI() {
        self.addOwnView.addDateButton.rx.tap
            .bind(onNext: self.addDate)
            .disposed(by: self.disposeBag)
    }

    func addDate() {
        let alert = DatePickerAlertController(title: "날짜 지정", message: "날짜를 지정해주세요", preferredStyle: .actionSheet)
        let okAction: UIAlertAction = UIAlertAction(title: "확인", style: .default) { [weak self] _ in

            let selectedDate = alert.dateConvertToString()
            self?.addOwnView.addDateButton.setTitle(selectedDate, for: .normal)

            Observable.just(selectedDate)
                .filter { _ in self != nil }
                .bind(to: self!.addToDoViewModel.todoDateData)
                .disposed(by: self!.disposeBag)
        }

        alert.addAction(okAction)

        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(cancelAction)

        self.present(alert, animated: true, completion: nil)
    }

    override func loadView() {
        let view = AddToDoLayout()
        self.view = view
    }

    override func viewDidLoad() {
        self.navigationItem.title = "Add"
        self.bindNavigationBuutton()
        self.bindeTextField()
        self.bindUI()
    }
}
