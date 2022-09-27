//
//  ListCollectionView.swift
//  ProjectManager
//
//  Created by 이원빈 on 2022/09/09.
//

import UIKit

final class ListCollectionView: UICollectionView {
    
    private enum Section {
        case main
    }
    weak var transitionDelegate: TodoListViewControllerDelegate?
    private var todoDataSource: UICollectionViewDiffableDataSource<Section, Todo>?
    private var snapshot = NSDiffableDataSourceSnapshot<Section, Todo>()
    let category: String
    let viewModel: ListCollectionViewModel
    var currentLongPressedCell: ListCell?
    
    // MARK: Initializer
    init(category: String) {
        self.category = category
        self.viewModel = ListCollectionViewModel(category: category)
        super.init(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        setupInitialView()
        configureDataSource()
        setupDataSource(with: viewModel.list)
        setupLongGestureRecognizerOnCollection()
        bindUpdateBehavior()
        bindMoveBehavior()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ListCollectionView {
    
    private func setupInitialView() {
        showsVerticalScrollIndicator = false
        setCollectionViewLayout(createListLayout(), animated: false)
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundColor = .systemGray6
    }
    
    private func createListLayout() -> UICollectionViewLayout {
        let sectionProvider = { (_: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let section: NSCollectionLayoutSection
            
            var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
            configuration.trailingSwipeActionsConfigurationProvider = { [weak self] (indexPath) in
                guard let self = self else { return nil }
                guard let item = self.todoDataSource?.itemIdentifier(for: indexPath) else { return nil }
                return self.trailingSwipeActionConfigurationForListCellItem(item)
            }
            section = NSCollectionLayoutSection.list(
                using: configuration,
                layoutEnvironment: layoutEnvironment
            )
            section.contentInsets = NSDirectionalEdgeInsets(
                top: 0,
                leading: 0,
                bottom: 0,
                trailing: 0
            )
            section.interGroupSpacing = 10
            return section
        }
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
    }
    
    private func trailingSwipeActionConfigurationForListCellItem(_ item: Todo) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "delete") { (_, _, completion) in
            TodoDataManager.shared.delete(item)
            completion(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<ListCell, Todo> { (cell, _, todo) in
            cell.setup(with: todo)
        }
        todoDataSource = UICollectionViewDiffableDataSource<Section, Todo>(collectionView: self) { (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: Todo) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: itemIdentifier
            )
        }
    }
    
    private func setupDataSource(with items: [Todo]?) {
        guard let items = items else { return }
        snapshot.deleteAllItems()
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        todoDataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    // MARK: - Bind
    private func bindUpdateBehavior() {
        viewModel.performAdd.append({ [weak self] (todo) in
            self?.add(todo: [todo], in: todo.category)
        })
        viewModel.performDelete.append({ [weak self] (todo) in
            self?.delete(todo: [todo], in: todo.category)
        })
    }
    
    private func bindMoveBehavior() {
        viewModel.didMovedList.append { [weak self] (list) in
            guard list?.first?.category == self?.category else { return }
            self?.setupDataSource(with: list)
        }
    }
    
    private func add(todo: [Todo], in category: String) {
        guard category == self.category else { return }
        snapshot.appendItems(todo, toSection: .main)
        todoDataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    private func delete(todo: [Todo], in category: String) {
        guard category == self.category else { return }
        snapshot.deleteItems(todo)
        todoDataSource?.apply(snapshot, animatingDifferences: true)
    }
}
