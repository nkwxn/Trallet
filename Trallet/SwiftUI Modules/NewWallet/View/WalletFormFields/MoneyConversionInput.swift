//
//  MoneyConversionInput.swift
//  Trallet
//
//  Created by Nicholas on 03/09/21.
//

import SwiftUI

struct MoneyConversionInput: View {
    @Binding var homeCurrency: String
    @Binding var homeAmount: Double
    @Binding var baseCurrency: String
    @Binding var baseAmount: Double
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Amount of cash before")
            CurrencyTextField(currencyCode: $homeCurrency, amountOfMoney: $homeAmount)
            Text("Amount of cash after exchange")
            CurrencyTextField(currencyCode: $baseCurrency, amountOfMoney: $baseAmount)
            Text("Exchange Rate")
            
            // Isi text field nya sesuai penghitungan
            HStack {
                Text(homeCurrency)
                TextField("Currency", text: $homeCurrency)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                Image(systemName: "arrow.left.arrow.right")
                    .foregroundColor(.accentColor)
                Text(baseCurrency)
                TextField("Currency", text: $baseCurrency)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
            }
        }
        .listRowBackground(Color("app_background"))
        .padding(.vertical, 7)
    }
}

struct MoneyConversionInput_Previews: PreviewProvider {
    static var previews: some View {
        MoneyConversionInput(
            homeCurrency: .constant("IDR"),
            homeAmount: .constant(50000),
            baseCurrency: .constant("USD"),
            baseAmount: .constant(5.43)
        )
    }
}
