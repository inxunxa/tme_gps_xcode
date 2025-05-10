//
//  Item.swift
//  tme_gps_xcode
//
//  Created by Tools de México on 5/9/25.
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
