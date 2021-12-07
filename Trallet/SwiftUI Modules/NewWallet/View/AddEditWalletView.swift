//
//  NewWalletView.swift
//  Trallet
//
//  Created by Nicholas on 23/08/21.
//

import SwiftUI

struct AddEditWalletView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var viewModel: AddEditWalletViewModel
    
    init(wallet forUpdate: Wallet?) {
        self.viewModel = AddEditWalletViewModel(wallet: forUpdate)
    }
        
    var body: some View {
        NavigationView {
            Form {
                ThumbAndName(
                    walletName: $viewModel.walletName,
                    thumbIcn: $viewModel.thumbnailString,
                    thumbBG: $viewModel.thumbnailColor
                ) {
                    viewModel.isEditingThumb.toggle()
                }
                Toggle("Going overseas?", isOn: $viewModel.isGoingOverseas)
                    .listRowBackground(Color("app_background"))
                    .padding(.vertical, 7)
                if viewModel.isGoingOverseas {
                    // Show base currency and home currency
                    MoneyConversionInput(
                        homeCurrency: $viewModel.homeCurrency,
                        homeAmount: $viewModel.cashAmount,
                        baseCurrency: $viewModel.exchangeCurrency,
                        baseAmount: $viewModel.cashExchange
                    )
                } else {
                    // Base currency as home
                    AmountMoneyInput(labelValue: "Amount of Cash", baseCurrency: $viewModel.homeCurrency, amount: $viewModel.cashAmount)
                }
                Toggle("Planning to use Credit Card?", isOn: $viewModel.isUsingCreditCard)
                    .listRowBackground(Color("app_background"))
                    .padding(.vertical, 7)
                if viewModel.isUsingCreditCard {
                    AmountMoneyInput(labelValue: "Credit Card Limit", baseCurrency: $viewModel.homeCurrency, amount: $viewModel.ccLimit)
                }
            }
            .navigationBarTitle(
                viewModel.walletToUpdate != nil ? "Update Wallet" : "New Wallet",
                displayMode: .inline
            )
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        // add syntax to add / update
                        viewModel.onDoneButtonPressed()
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .sheet(
                isPresented: $viewModel
                    .isEditingThumb
            ) {
                EditThumbView(thumbTxt: viewModel.thumbnailString, background: viewModel.thumbnailColor)
            }
        }
    }
}

struct NewWalletView_Previews: PreviewProvider {
    static var previews: some View {
        AddEditWalletView(wallet: nil)
    }
}
