//
//  EditTodoListCoordinator.swift
//  ProjectManager
//
//  Created by 이원빈 on 2022/09/15.
//

import UIKit

final class FormSheetViewCoordinator: Coordinator {
    var mode: PageMode
    var dataStore: DataStore
    var category: String?
    var index: Int?
    
    init(
        dataStore: DataStore,
        mode: PageMode,
        category: String? = nil,
        index: Int? = nil
    ) {
        self.dataStore = dataStore
        self.mode = mode
        self.category = category
        self.index = index
    }
    
    func start() -> UIViewController {
        let formSheetVM = FormSheetViewModel(
            dataStore: dataStore,
            mode: mode,
            category: category,
            index: index
        )
        let formSheetVC = FormSheetViewController(viewModel: formSheetVM)
        formSheetVC.modalPresentationStyle = .formSheet
        return formSheetVC
    }
}
