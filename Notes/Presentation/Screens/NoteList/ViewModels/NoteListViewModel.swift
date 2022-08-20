//
//  NoteListViewModel.swift
//  Notes
//
//  Created by Danylo Safronov on 20.08.2022.
//

import Foundation

@MainActor
final class NoteListViewModel {
    @Published private (set) var notes: [Note] = []
    @Published private (set) var loading: Bool = false
    
    private var loadTask: Task<Void, Never>?
    
    func load(refresh: Bool = false) {
        loadTask = Task(priority: .high) {
            loading = true
            
            notes = .sample
            
            loading = false
        }
    }
}
