//
//  Item.swift
//  MemoDash
//
//  Created by Umut on 1.05.2025.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date

    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
