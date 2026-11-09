//
//  TabContainerView.swift
//  Trallet
//
//  Created by Nicholas on 09/11/26.
//

import SwiftUI

struct TabContainerView: View {
    var body: some View {
        TabView {
            Tab("Wallets", systemImage: "creditcard.fill") {
                TripWalletsSwiftUIWrapper()
            }
            Tab("Profile", systemImage: "person.fill") {
                Text("Feature under development")
            }
        }.background(Color("BackgroundColor"))
    }
}

#Preview {
    TabContainerView()
}
