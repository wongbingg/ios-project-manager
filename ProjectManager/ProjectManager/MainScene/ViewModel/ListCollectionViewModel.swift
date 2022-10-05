//
//  ListCollectionViewModel.swift
//  ProjectManager
//
//  Created by 이원빈 on 2022/09/19.
//

final class ListCollectionViewModel {
    var dataStore: DataStore
    let category: String

    init(dataStore: DataStore, category: String) {
        self.dataStore = dataStore
        self.category = category
    }

    func bindList(_ completion: @escaping ([Todo]) -> Void) {
        dataStore.didChangedData.append { [weak self] in
            guard let self = self else { return }
            let changedList = self.fetchList()
            completion(changedList)
        }
    }
    
    func fetchList() -> [Todo] {
        return dataStore.read(category: self.category)
    }
    
    func delete(todo: Todo) {
        dataStore.delete(todo)
    }
}
