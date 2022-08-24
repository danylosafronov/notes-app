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
    
    func load(refresh: Bool = false) async {
        loading = true
        
        guard notes.isEmpty else {
            loading = false
            return
        }
        
#if DEBUG
        do {
            try await Task.sleep(nanoseconds: 3_000_000_000)
        } catch {
            // ignore
        }
#endif
        
        notes = .sample
        loading = false
    }
}
