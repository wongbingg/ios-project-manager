//
//  DataStore.swift
//  ProjectManager
//
//  Created by 이원빈 on 2022/10/01.
//

protocol DataStore {
    var didChangedData: [(() -> Void)?] { get set }
    
    func undo()
    func redo()
    func canUndo() -> Bool
    func canRedo() -> Bool
    
    func synchronizeData()
    func create(with todoModel: TodoModel)
    func read(category: String) -> [Todo]
    func update(todo: Todo, with model: TodoModel)
    func move(todo: Todo, to target: String)
    func delete(_ todo: Todo)
}
