//
//  NoteListView.swift
//  Notes
//
//  Created by Danylo Safronov on 19.08.2022.
//

import Foundation
import UIKit

final class NoteListView: UIView {
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    private typealias CellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Item>
    
    private var cellRegistration: CellRegistration!
    private var dataSource: DataSource!
    private var collectionView: UICollectionView!
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        setupCollectionView()
        setupCollectionViewCellRegistration()
        setupCollectionViewDataSource()
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeCollectionViewLayout())
        
        addSubview(collectionView)
        
        collectionView.collectionViewLayout = makeCollectionViewLayout()
        collectionView.backgroundColor = .systemBackground
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    private func setupCollectionViewCellRegistration() {
        cellRegistration = CellRegistration(handler: collectionViewCellRegistrationHandler)
    }
    
    private func setupCollectionViewDataSource() {
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

extension NoteListView {
    enum Section: Hashable {
        case main
    }
}

extension NoteListView {
    enum Item: Hashable {
        case note(note: Note)
    }
}

extension NoteListView {
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

extension NoteListView {
    func apply(_ items: [Item], to section: Section) {
        var snapshot = Snapshot()
        snapshot.appendSections([section])
        snapshot.appendItems(items, toSection: section)
        
        dataSource.apply(snapshot)
    }
}
