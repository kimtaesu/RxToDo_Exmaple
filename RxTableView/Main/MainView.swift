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

class MainView: UIViewController {
    let viewModel = MainViewModel()
    var disposeBag = DisposeBag()

    var mainOwnView: MainLayout {
        return self.view as! MainLayout
    }

    func addItem() {
        let addView = AddTodoView()
        addView.delegate = viewModel
        self.navigationController?.pushViewController(addView, animated: true)
    }

    func bindUI() {
        let dataSource = RxTableViewSectionedReloadDataSource<SectionOfMemoData>(
            configureCell: { [weak self]_, _, indexPath, item in
                
                guard let self = self else {
                    fatalError()
                }
                
                let mainCell = self.mainOwnView.mainTableView.dequeueReusableCell(withIdentifier: "MainCell", for: indexPath)
                if let cell = mainCell as? MainCell {
                    cell.mainTitleLabel.text = item.content
                    return cell
                }
                
                return mainCell
        })
        
        dataSource.canEditRowAtIndexPath = { _, _ in
            true
        }
        
        dataSource.canMoveRowAtIndexPath = { _, _ in
            true
        }
        
        self.viewModel.memoData.asDriver()
            .drive(self.mainOwnView.mainTableView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)
        
        self.mainOwnView.mainTableView.rx.itemDeleted
            .map{ActionList.deleteItem($0)}
            .bind(to: self.viewModel.value)
            .disposed(by: self.disposeBag)
        
        self.mainOwnView.mainTableView.rx.itemMoved
            .map{ ActionList.moveItem($0)}
            .bind(to: viewModel.value)
            .disposed(by: self.disposeBag)
        
        self.mainOwnView.mainTableView.rx
            .setDelegate(self)
            .disposed(by: self.disposeBag)
    }
    
    func bindNavigationButton() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: nil)
        
        self.navigationItem.rightBarButtonItem = addButton
        self.navigationItem.leftBarButtonItem = editButton
        
        addButton.rx.tap.asDriver()
            .drive(onNext: self.addItem)
            .disposed(by: self.disposeBag)
        
        editButton.rx.tap.asDriver()
            .drive(onNext: { [weak self] _ in
                self?.mainOwnView.mainTableView.setEditing(true, animated: true)
                self?.navigationItem.leftBarButtonItem = doneButton
            })
            .disposed(by: self.disposeBag)
        
        doneButton.rx.tap.asDriver()
            .drive(onNext: { [weak self] _ in
                self?.mainOwnView.mainTableView.setEditing(false, animated: true)
                self?.navigationItem.leftBarButtonItem = editButton
            })
            .disposed(by: self.disposeBag)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        disposeBag = DisposeBag()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        bindUI()
        bindNavigationButton()
    }
    
    override func loadView() {
        let view = MainLayout()
        self.view = view
    }

    override func viewDidLoad() {
        self.navigationItem.title = "ToDo"
        self.mainOwnView.mainTableView.rowHeight = 44
    }
}

extension MainView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteButton = UITableViewRowAction(style: .default, title: "삭제") { _, indexPath in
            tableView.dataSource?.tableView!(tableView, commit: .delete, forRowAt: indexPath)
        }
        return [deleteButton]
    }
}
