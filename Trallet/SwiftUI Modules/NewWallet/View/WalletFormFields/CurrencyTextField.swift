//
//  CurrencyTextField.swift
//  Trallet
//
//  Created by Nicholas on 03/09/21.
//

import SwiftUI
import Combine

struct CurrencyTextField: View {
    @Binding var currencyCode: String
    @Binding var amountOfMoney: Double
    
    let formatter = NumberFormatter()
    
    init(currencyCode: Binding<String>, amountOfMoney: Binding<Double>) {
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ""
        formatter.maximumFractionDigits = 2
        self._currencyCode = currencyCode
        self._amountOfMoney = amountOfMoney
    }
    
    var body: some View {
        HStack {
            TextField("Currency", text: $currencyCode)
                .multilineTextAlignment(.center)
                .frame(width: 90)
            TextField("Amount", value: $amountOfMoney, formatter: formatter) {
                print("onEditingChanged \($0)")
                if $0 {
                    amountOfMoney = amountOfMoney
                }
            } onCommit: {
                print("onCommit")
            }
            .keyboardType(.decimalPad)
        }
        .textFieldStyle(RoundedBorderTextFieldStyle())
    }
}

struct CurrencyTextField_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyTextField(currencyCode: .constant(""), amountOfMoney: .constant(1000))
    }
}
