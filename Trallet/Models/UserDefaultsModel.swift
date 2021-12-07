//
//  UserDefaultsModel.swift
//  Trallet
//
//  Created by Nicholas on 05/09/21.
//

import Foundation

class UserDefaultsModel {
    static var shared = UserDefaultsModel()
    
    // Defaults model
    var defaults = UserDefaults.standard
    
    // MARK: - GET Function for Currency
    func getHomeCurrency() -> String {
        guard let homeCurrency = defaults
                .string(forKey: "homeCurrency")
        else { return "" }
        return homeCurrency
    }
    
    // MARK: - SET Function for Currency
    func setHomeCurrency(code currency: String) {
        defaults.set(currency, forKey: "homeCurrency")
    }
    
    // MARK: - GET Function for Grid or List
    func isGrid() -> Bool {
        return false
    }
    
    func setIsGrid(_ viewAsGrid: Bool) {
        
    }
    
    // MARK: - SOON: GET and SET Function for Recently seen wallet (for showing recent wallet on Widget)
}
