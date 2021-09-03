//
//  AmountMoneyInput.swift
//  Trallet
//
//  Created by Nicholas on 03/09/21.
//

import SwiftUI

struct AmountMoneyInput: View {
    var labelValue: String
    @Binding var baseCurrency: String
    @Binding var amount: Double
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(labelValue)
            CurrencyTextField(currencyCode: $baseCurrency, amountOfMoney: $amount)
        }
        .listRowBackground(Color("app_background"))
        .padding(.vertical, 7)
    }
}

struct AmountMoneyInput_Previews: PreviewProvider {
    static var previews: some View {
        AmountMoneyInput(labelValue: "Amount of Cash", baseCurrency: .constant("IDR"), amount: .constant(0))
    }
}
