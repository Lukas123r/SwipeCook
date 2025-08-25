//
//  Item.swift
//  SwipeCook
//
//  Created by Lena Marie Maier on 25.08.25.
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
