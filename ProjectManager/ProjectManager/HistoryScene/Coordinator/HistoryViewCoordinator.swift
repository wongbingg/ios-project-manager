//
//  HistoryViewCoordinator.swift
//  ProjectManager
//
//  Created by 이원빈 on 2022/09/19.
//

import UIKit

final class HistoryViewCoordinator: Coordinator {
    let dataStore: TodoDataStore
    let viewController: TodoListViewController
    
    init(dataStore: TodoDataStore,
         viewController: TodoListViewController) {
        self.dataStore = dataStore
        self.viewController = viewController
    }

    func start() -> UIViewController {
        let historyVM = HistoryViewModel(histories: dataStore.fetchHistories())
        let historyVC = HistoryTableViewController(viewModel: historyVM)
        historyVC.modalPresentationStyle = .popover
        historyVC.popoverPresentationController?.permittedArrowDirections = .up
        historyVC.popoverPresentationController?.delegate = viewController
        historyVC.popoverPresentationController?.barButtonItem = viewController
            .navigationBar
            .topItem?
            .leftBarButtonItem
        return historyVC
    }
}
