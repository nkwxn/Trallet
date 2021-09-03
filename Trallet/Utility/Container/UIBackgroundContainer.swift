//
//  UIBackgroundContainer.swift
//  Trallet
//
//  Created by Nicholas on 21/08/21.
//

import SwiftUI

struct UIBackgroundContainer<Content>: View where Content: View {
    var content: () -> Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        ZStack {
            Color("app_background")
                .ignoresSafeArea()
            
        }
    }
}

struct UIBackgroundContainer_Previews: PreviewProvider {
    static var previews: some View {
        UIBackgroundContainer {
            Text("asdf")
        }
    }
}
