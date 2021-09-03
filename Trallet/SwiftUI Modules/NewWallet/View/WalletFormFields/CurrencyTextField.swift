//
//  CurrencyTextField.swift
//  Trallet
//
//  Created by Nicholas on 03/09/21.
//

import SwiftUI

struct CurrencyTextField: View {
    @Binding var currencyCode: String
    @Binding var amountOfMoney: Double
    
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    var body: some View {
        HStack {
            TextField("Currency", text: $currencyCode)
                .multilineTextAlignment(.center)
                .frame(width: 90)
            TextField("Amount", value: $amountOfMoney, formatter: formatter)
                .keyboardType(.numberPad)
        }
        .textFieldStyle(RoundedBorderTextFieldStyle())
    }
}

struct CurrencyTextField_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyTextField(currencyCode: .constant(""), amountOfMoney: .constant(1000))
    }
}
