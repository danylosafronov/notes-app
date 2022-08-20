//
//  DispatchQueue.swift
//  Notes
//
//  Created by Danylo Safronov on 20.08.2022.
//

import Foundation

extension DispatchQueue {
    static var background: DispatchQueue {
        DispatchQueue(label: "app.notes.background")
    }
}
