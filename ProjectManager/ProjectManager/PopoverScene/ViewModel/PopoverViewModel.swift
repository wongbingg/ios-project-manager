//
//  PopoverViewModel.swift
//  ProjectManager
//
//  Created by 이원빈 on 2022/09/19.
//

final class PopoverViewModel {
    let dataStore: DataStore
    let selectedTodo: Todo
    
    init(dataStore: DataStore, selectedTodo: Todo) {
        self.dataStore = dataStore
        self.selectedTodo = selectedTodo
    }
    
    func move(to target: String) {
        dataStore.move(todo: selectedTodo, to: target)
    }
}
