//
//  ViewController.swift
//  RxTableView
//
//  Created by Milkyo on 29/07/2019.
//  Copyright © 2019 MilKyo. All rights reserved.
//

import RxCocoa
import RxDataSources
import RxSwift
import UIKit

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

class MainViewController: UIViewController {
    var memo = [MemoData]()
    var disposeBag = DisposeBag()

    var mainOwnView: MainView {
        return self.view as! MainView
    }

    var memoItems = BehaviorRelay<[MemoData]>(value: [])

    func addItem() {
        let alert = UIAlertController(title: "입력", message: "내용입력", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { _ in

            alert.textFields?[0].rx.text.orEmpty.asDriver()
                .filter { $0 != "" }
                .drive(onNext: { str in
                    print(str)
                    self.memo.append(MemoData(content: str))
                    self.memoItems.accept(self.memo)
                })
                .disposed(by: self.disposeBag)
        }
        alert.addTextField()
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }

    override func loadView() {
        let view = MainView()
        self.view = view
    }

    override func viewDidLoad() {
        self.navigationItem.title = "MEMO"

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = addButton

        addButton.rx.tap
            .bind(onNext: self.addItem)
            .disposed(by: self.disposeBag)

        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: nil)
        self.navigationItem.leftBarButtonItem = editButton

        let dataSource = RxTableViewSectionedReloadDataSource<SectionOfCustomData>(
            configureCell: { _, _, indexPath, item in
                let mainCell = self.mainOwnView.mainTableView.dequeueReusableCell(withIdentifier: "MainCell", for: indexPath)

                if let cell = mainCell as? MainCell {
                    cell.mainTitleLabel.text = item.content

                    return cell
                }

                return mainCell
            }
        )

        editButton.rx.tap.asDriver()
            .drive(onNext: { _ in
                self.mainOwnView.mainTableView.setEditing(true, animated: true)
                self.navigationItem.leftBarButtonItem = doneButton
            })
            .disposed(by: self.disposeBag)

        doneButton.rx.tap.asDriver()
            .drive(onNext: { _ in
                self.mainOwnView.mainTableView.setEditing(false, animated: true)
                self.navigationItem.leftBarButtonItem = editButton
            })
            .disposed(by: self.disposeBag)

        dataSource.canEditRowAtIndexPath = { _, _ in
            true
        }

        dataSource.canMoveRowAtIndexPath = { _, _ in
            true
        }

        self.memoItems.accept(self.memo)

        self.memoItems.asDriver()
            .map { [SectionOfCustomData(items: $0)] }
            .drive(self.mainOwnView.mainTableView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)

        self.mainOwnView.mainTableView.rx.itemDeleted.asDriver()
            .drive(onNext: { indexPath in
                self.memo.remove(at: indexPath.row)
                self.memoItems.accept(self.memo)
            })
            .disposed(by: self.disposeBag)

        self.mainOwnView.mainTableView.rx.itemSelected.asDriver()
            .drive(onNext: { indexPath in
                print(indexPath.row)
                self.mainOwnView.mainTableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: self.disposeBag)

        self.mainOwnView.mainTableView.rx.itemMoved.asDriver()
            .drive(onNext: { sourceIndexPath, destinationIndexPath in
                let targetData = self.memo[sourceIndexPath.row]
                self.memo.remove(at: sourceIndexPath.row)
                self.memo.insert(targetData, at: destinationIndexPath.row)
                self.memoItems.accept(self.memo)
            })
            .disposed(by: self.disposeBag)

        self.mainOwnView.mainTableView.rx
            .setDelegate(self)
            .disposed(by: self.disposeBag)
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteButton = UITableViewRowAction(style: .default, title: "DELETE") { _, indexPath in
            tableView.dataSource?.tableView!(tableView, commit: .delete, forRowAt: indexPath)
        }

        return [deleteButton]
    }
}
