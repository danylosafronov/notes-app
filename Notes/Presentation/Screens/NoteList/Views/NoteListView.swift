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
    
    private lazy var contentLayoutGuide = UILayoutGuide()
    private lazy var loadIndicatorView = LoadIndicatorView()
    
    var loading: Bool = false {
        didSet {
            setupLoadIndicaorViewLoading(loading)
            setupLoadIndicatorVisibility(loading)
        }
    }
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        setupContentLayoutGuide()
        setupCollectionView()
        setupCollectionViewCellRegistration()
        setupCollectionViewDataSource()
        setupLoadIndicaorView()
    }
    
    private func setupContentLayoutGuide() {
        addLayoutGuide(contentLayoutGuide)
        
        NSLayoutConstraint.activate([
            contentLayoutGuide.topAnchor.constraint(equalTo: topAnchor),
            contentLayoutGuide.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentLayoutGuide.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentLayoutGuide.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeCollectionViewLayout())
        
        addSubview(collectionView)
        
        collectionView.collectionViewLayout = makeCollectionViewLayout()
        collectionView.backgroundColor = .systemBackground
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentLayoutGuide.trailingAnchor),
        ])
    }
    
    private func setupCollectionViewCellRegistration() {
        cellRegistration = CellRegistration { cell, indexPath, item in
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
    
    private func setupCollectionViewDataSource() {
        dataSource = DataSource(collectionView: collectionView) { [weak self] collectionView, indexPath, item in
            guard let self = self else { return nil }
            return collectionView.dequeueConfiguredReusableCell(using: self.cellRegistration, for: indexPath, item: item)
        }
    }
    
    private func setupLoadIndicaorView() {
        addSubview(loadIndicatorView)
        
        loadIndicatorView.text = NSLocalizedString("Loading", comment: "A load indicator text")
        loadIndicatorView.backgroundColor = .systemBackground
        loadIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        setupLoadIndicaorViewLoading(false)
        setupLoadIndicatorVisibility(false)
        
        NSLayoutConstraint.activate([
            loadIndicatorView.topAnchor.constraint(equalTo: contentLayoutGuide.topAnchor),
            loadIndicatorView.bottomAnchor.constraint(equalTo: contentLayoutGuide.bottomAnchor),
            loadIndicatorView.leadingAnchor.constraint(equalTo: contentLayoutGuide.leadingAnchor),
            loadIndicatorView.trailingAnchor.constraint(equalTo: contentLayoutGuide.trailingAnchor),
        ])
    }

    private func setupLoadIndicaorViewLoading(_ loading: Bool) {
        loadIndicatorView.loading = loading
    }
    
    private func setupLoadIndicatorVisibility(_ state: Bool) {
        loadIndicatorView.isHidden = !state
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
    func apply(_ items: [Item], to section: Section) {
        var snapshot = Snapshot()
        snapshot.appendSections([section])
        snapshot.appendItems(items, toSection: section)
        
        dataSource.apply(snapshot)
    }
}
