//
//  NoteListViewController.swift
//  Notes
//
//  Created by Danylo Safronov on 18.08.2022.
//

import UIKit

final class NoteListViewController: UIViewController {
    private let viewModel: NoteListViewModel
    private lazy var nestedView = NoteListView()
    private var cancellable = CancellableBag()
    
    init(dependency: Dependency) {
        viewModel = dependency.viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = nestedView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.load(refresh: false)
    }
    
    private func setup() {
        setupNavigationItem()
        setupNavigationItemBarButtons()
    }
    
    private func setupNavigationItem() {
        navigationItem.title = NSLocalizedString("Notes", comment: "A notes screen title")
        navigationItem.largeTitleDisplayMode = .automatic
    }
    
    private func setupNavigationItemBarButtons() {
        navigationItem.rightBarButtonItems = [makeCreateNoteBarButton()]
    }
    
    private func setupNestedView(with notes: [Note]) {
        nestedView.apply(notes.map { .note(note: $0) }, to: .main)
    }
    
    private func bind() {
        bindViewModelNotes()
    }
    
    private func bindViewModelNotes() {
        viewModel
            .$notes
            .subscribe(on: DispatchQueue.background)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] notes in
                self?.didChangeViewModelNotes(notes)
            }
            .store(in: &cancellable)
    }
    
    private func makeCreateNoteBarButton() -> UIBarButtonItem {
        UIBarButtonItem(
            image: UIImage(systemName: "square.and.pencil"),
            style: .plain,
            target: .none,
            action: .none
        )
    }
    
    private func didChangeViewModelNotes(_ notes: [Note]) {
        setupNestedView(with: notes)
    }
}

extension NoteListViewController {
    struct Dependency {
        let viewModel: NoteListViewModel
    }
}
