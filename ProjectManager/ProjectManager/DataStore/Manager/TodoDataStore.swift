//
//  TodoDataManager.swift
//  ProjectManager
//
//  Created by 이원빈 on 2022/09/14.
//

import Foundation
import UserNotifications

final class TodoDataStore: DataStore, HistoryRecordable, NotificationProtocol {
    
    var notificationCenter = UNUserNotificationCenter.current()
    var histories: [History] = []
    
    private let localDataManager = LocalDataManager()
    private let remoteDataManager = RemoteDataManager()
    private let undoManager = UndoManager()
    
    var didChangedData: [(() -> Void)?] = []
    
    init() {
        localDataManager.delegate = remoteDataManager
    }
    
    // MARK: - UndoManager
    func undo() {
        undoManager.undo()
    }
    
    func redo() {
        undoManager.redo()
    }
    
    func canUndo() -> Bool {
        undoManager.canUndo
    }
    
    func canRedo() -> Bool {
        undoManager.canRedo
    }
    
    // MARK: - DataSync
    func synchronizeData() {
        localDataManager.synchronizeData {
            self.didChangedData.forEach { $0?() }
        }
    }
    
    // MARK: - CRUD (Realm + FireBase + HistoryManager + UndoManager)
    func create(with todoModel: TodoModel) {
        let todo = Todo(
            id: UUID(),
            category: todoModel.category,
            title: todoModel.title,
            body: todoModel.body,
            date: todoModel.date
        )
        localDataManager.create(with: todo)
        addHistory(todo: todo, with: .added)
        requestSendNoti(with: todo)
        undoManager.registerUndo(withTarget: self) { selfType in
            selfType.delete(todo)
        }
        didChangedData.forEach { $0?() }
    }
    
    func read(category: String) -> [Todo] {
        localDataManager.read(category: category)
    }
    
    func update(todo: Todo, with model: TodoModel) {
        let oldModel = TodoModel(
            category: todo.category,
            title: todo.title,
            body: todo.body,
            date: todo.date
        )
        requestCancelNoti(with: todo.id.uuidString)
        localDataManager.update(todo: todo, with: model)
        requestSendNoti(with: todo)
        undoManager.registerUndo(withTarget: self) { selfType in
            selfType.update(todo: todo, with: oldModel)
        }
        didChangedData.forEach { $0?() }
    }
    
    func move(todo: Todo, to target: String) {
        let oldTarget = todo.category
        localDataManager.move(todo: todo, to: target)
        addHistory(todo: todo,
                   moveTarget: target,
                   with: .moved)
        undoManager.registerUndo(withTarget: self) { selfType in
            selfType.move(todo: todo, to: oldTarget)
        }
        didChangedData.forEach { $0?() }
    }
    
    func delete(_ todo: Todo) {
        let oldTodo = TodoModel(
            id: todo.id,
            category: todo.category,
            title: todo.title,
            body: todo.body,
            date: todo.date
        )
        addHistory(todo: todo,
                   with: .removed)
        requestCancelNoti(with: todo.id.uuidString)
        undoManager.registerUndo(withTarget: self) { selfType in
            selfType.create(with: oldTodo)
        }
        localDataManager.delete(todo)
        didChangedData.forEach { $0?() }
    }
}
