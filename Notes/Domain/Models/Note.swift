//
//  Note.swift
//  Notes
//
//  Created by Danylo Safronov on 18.08.2022.
//

import Foundation

struct Note: Hashable, Identifiable {
    let id: UUID
    let title: String
    let text: String
    let timestamp: Date
}


#if DEBUG

extension Note {
    static var sample: Note {
        .init(
            id: UUID(),
            title: .lipsum,
            text: .lipsum,
            timestamp: Date()
        )
    }
}

extension Array where Element == Note {
    static var sample: [Note] {
        [
            .sample,
            .sample,
            .sample,
            .sample,
            .sample,
        ]
    }
}

#endif
