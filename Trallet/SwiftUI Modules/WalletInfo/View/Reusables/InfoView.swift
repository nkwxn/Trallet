//
//  InfoView.swift
//  Trallet
//
//  Created by Nicholas on 24/09/21.
//

import SwiftUI

struct InfoView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            VStack(alignment: .leading, spacing: 0) {
                Text("Wallet Status")
                    .font(.title)
                    .fontWeight(.bold)
                Text("Cash")            }
            VStack(alignment: .leading, spacing: 0) {
                Text("Balance")
                    .font(.subheadline)
                Text("KRW 500,000.00")
                    .font(.title3)
            }
            VStack(alignment: .leading, spacing: 0) {
                Text("Amount of Cash Exchanged")
                    .font(.subheadline)
                Text("KRW 500,000.00")
                    .font(.title3)
            }
            HStack {
                VStack {
                    Text("Total Income")
                        .font(.subheadline)
                    Text("DEFG")
                        .font(.title3)
                }
                Spacer()
                Divider()
                Spacer()
                VStack {
                    Text("Total Expense")
                        .font(.subheadline)
                    Text("DEFGHIJKL")
                        .font(.title3)
                }
            }
            .frame(minHeight: 25, maxHeight: 100)
            Spacer()
        }
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}
