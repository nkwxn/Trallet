//
//  ThumbAndName.swift
//  Trallet
//
//  Created by Nicholas on 25/08/21.
//

import SwiftUI
import Combine

struct ThumbAndName: View {
    @Binding var walletName: String
    @Binding var thumbIcn: String
    @Binding var thumbBG: UIColor
    var onPressAction: () -> Void
    
    var body: some View {
        VStack {
            VStack {
                ThumbnailSquare(.inline, disp: $thumbIcn, color: $thumbBG)
                    .frame(width: 80)
                Text("Edit")
                    .foregroundColor(.accentColor)
            }
            .onTapGesture {
                onPressAction()
            }
            TextField("Wallet Name", text: $walletName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
        .listRowBackground(Color("app_background"))
        .padding(.vertical, 7)
    }
}

struct ThumbAndName_Previews: PreviewProvider {
    static var previews: some View {
        ThumbAndName(walletName: .constant(""), thumbIcn: .constant("a"), thumbBG: .constant(UIColor.blue)) {
            print("Pressed")
        }
    }
}
