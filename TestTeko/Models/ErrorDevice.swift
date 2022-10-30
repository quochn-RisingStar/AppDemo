//
//  ErrorDevice.swift
//  TestTeko
//
//  Created by ERT_Macbook_123 on 10/30/22.
//

import Foundation
struct ProductError: Codable {
    var errorDescription: String?
    var id: Int?
    var sku: String?
    var image: String?
    var color: Int?
    var name: String?
}
