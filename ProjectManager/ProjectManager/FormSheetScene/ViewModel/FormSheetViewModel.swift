//
//  CreateTodoListViewModel.swift
//  ProjectManager
//
//  Created by 이원빈 on 2022/09/19.
//

import Foundation

final class FormSheetViewModel {
    let dataStore: DataStore
    let mode: PageMode
    private(set) var currentTodo: Todo?
    
    init(
        dataStore: DataStore,
        mode: PageMode,
        category: String?,
        index: Int?
    ) {
        self.dataStore = dataStore
        self.mode = mode
        guard let category = category,
              let index = index else {
            return
        }
        self.currentTodo = dataStore.read(category: category)[index]
    }
    
    func edit(to nextTodo: TodoModel) {
        guard let currentTodo = currentTodo else {
            return
        }
        dataStore.update(todo: currentTodo, with: nextTodo)
    }
    
    func create(_ todoModel: TodoModel) {
        dataStore.create(with: todoModel)
    }
}
