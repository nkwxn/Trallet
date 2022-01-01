//
//  JSONModel.swift
//  Trallet
//
//  Created by Nicholas on 01/05/21.
//

import Foundation

struct ExchangeRate: Codable {
    var result: String
    var time_last_update_unix: Int
    var conversion_rate: Double
}
