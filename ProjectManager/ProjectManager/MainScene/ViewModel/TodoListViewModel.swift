//
//  TodoListViewModel.swift
//  ProjectManager
//
//  Created by 이원빈 on 2022/10/01.
//

protocol TodoListViewModel {
    var dataStore: TodoDataStore { get }
    
    func undo()
    func redo()
    func canUndo() -> Bool
    func canRedo() -> Bool
    func requestAuthNoti()
    func bind(_ completion: @escaping () -> Void)
}

final class TodoListViewModelImp: TodoListViewModel {
    var dataStore: TodoDataStore
    
    init(dataStore: TodoDataStore) {
        self.dataStore = dataStore
        dataStore.synchronizeData()
    }
    
    func undo() {
        dataStore.undo()
    }
    
    func redo() {
        dataStore.redo()
    }
    
    func canUndo() -> Bool {
        dataStore.canUndo()
    }
    
    func canRedo() -> Bool {
        dataStore.canRedo()
    }
    
    func requestAuthNoti() {
        dataStore.requestAuthNoti()
    }
    
    func bind(_ completion: @escaping () -> Void) {
        dataStore.didChangedData.append(completion)
    }
}
