//
//  HeaderViewModel.swift
//  ProjectManager
//
//  Created by 이원빈 on 2022/09/19.
//

final class HeaderViewModel {
    var dataStore: DataStore
    let category: String

    init(dataStore: DataStore, category: String) {
        self.dataStore = dataStore
        self.category = category
    }
    
    func bindListCount(_ completion: @escaping (Int) -> Void) {
        dataStore.didChangedData.append { [weak self] in
            guard let self = self else { return }
            let count = self.fetchCount()
            completion(count)
        }
    }
    
    func fetchCount() -> Int {
        dataStore.read(category: category).count
    }
}
