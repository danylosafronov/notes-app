//
//  NoteListViewController.swift
//  Notes
//
//  Created by Danylo Safronov on 18.08.2022.
//

import UIKit

final class NoteListViewController: UICollectionViewController {
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    private typealias CellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Item>
    
    private var cellRegistration: CellRegistration! = nil
    private var dataSource: DataSource! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems([Note].sample.map { .note(note: $0) })
                
        dataSource.apply(snapshot)
    }
    
    private func setup() {
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        collectionView.collectionViewLayout = makeCollectionViewLayout()
        
        cellRegistration = CellRegistration(handler: collectionViewCellRegistrationHandler)
        dataSource = DataSource(collectionView: collectionView) { [weak self] collectionView, indexPath, item in
            guard let self = self else { return nil }
            return collectionView.dequeueConfiguredReusableCell(using: self.cellRegistration, for: indexPath, item: item)
        }
    }
    
    private func makeCollectionViewLayout() -> UICollectionViewLayout {
        var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        configuration.showsSeparators = true
        
        return UICollectionViewCompositionalLayout.list(using: configuration)
    }
}

extension NoteListViewController {
    private enum Section: Hashable {
        case main
    }
}

extension NoteListViewController {
    private enum Item: Hashable {
        case note(note: Note)
    }
}

extension NoteListViewController {
    private func collectionViewCellRegistrationHandler(cell: UICollectionViewListCell, indexPath: IndexPath, item: Item) {
        switch item {
        case .note(let note):
            var configuration = cell.defaultContentConfiguration()
            configuration.text = note.title
            configuration.textProperties.numberOfLines = 1
            configuration.textProperties.font = .boldSystemFont(ofSize: 18.0)
            configuration.secondaryText = note.text
            configuration.secondaryTextProperties.numberOfLines = 3
            
            cell.contentConfiguration = configuration
        }
    }
}
