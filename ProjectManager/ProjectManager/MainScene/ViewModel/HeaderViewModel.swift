//
//  HeaderViewModel.swift
//  ProjectManager
//
//  Created by 이원빈 on 2022/09/19.
//

protocol HeaderViewModel {
    func bindListCount(_ completion: @escaping (Int) -> Void)
    func fetchCount() -> Int
    func fetchCategory() -> String
}

final class HeaderViewModelImp: HeaderViewModel {
    private var dataStore: DataStore
    private let category: String

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
    
    func fetchCategory() -> String {
        return category
    }
}
