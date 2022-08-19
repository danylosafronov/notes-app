//
//  NoteListViewController.swift
//  Notes
//
//  Created by Danylo Safronov on 18.08.2022.
//

import UIKit

final class NoteListViewController: UIViewController {
    private lazy var nestedView = NoteListView()
    
    override func loadView() {
        view = nestedView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nestedView.apply([Note].sample.map { .note(note: $0) }, to: .main)
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
    
    private func makeCreateNoteBarButton() -> UIBarButtonItem {
        UIBarButtonItem(
            image: UIImage(systemName: "square.and.pencil"),
            style: .plain,
            target: .none,
            action: .none
        )
    }
}
