//
//  SliderForm.swift
//  Trallet
//
//  Created by Nicholas on 25/08/21.
//

import SwiftUI

struct SliderForm: View {
    @State var sliderName: String
    @Binding var isØn: Bool
    
    var body: some View {
        HStack {
            Text(sliderName)
            Spacer()
            Toggle()
        }
    }
}

struct SliderForm_Previews: PreviewProvider {
    static var previews: some View {
        SliderForm()
    }
}
