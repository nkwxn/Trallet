//
//  EditThumbView.swift
//  Trallet
//
//  Created by Nicholas on 06/09/21.
//

import SwiftUI
import Combine

struct EditThumbView: View {
    @Environment(\.presentationMode) var x
    
    @State var thumbTxt: String
    @State var background: UIColor
    @State var picked = "Text / Emoji"
    var pickerSegment = ["Text / Emoji", "Background"]
    
    var colorSelections: [UIColor] = [
        UIColor(named: "thumb_gray") ?? #colorLiteral(red: 0.5882352941, green: 0.6078431373, blue: 0.6470588235, alpha: 1),
        UIColor(named: "thumb_pink") ?? #colorLiteral(red: 0.9215686275, green: 0.5058823529, blue: 0.6078431373, alpha: 1),
        UIColor(named: "thumb_red") ?? #colorLiteral(red: 0.9887960553, green: 0.3790351152, blue: 0.3456936777, alpha: 1),
        UIColor(named: "thumb_orange") ?? #colorLiteral(red: 0.9902636409, green: 0.6475216746, blue: 0.1861487329, alpha: 1),
        UIColor(named: "thumb_yellow") ?? #colorLiteral(red: 0.9869917035, green: 0.7966763377, blue: 0.1788059771, alpha: 1),
        UIColor(named: "thumb_green") ?? #colorLiteral(red: 0.4765319228, green: 0.8803042173, blue: 0.5395016074, alpha: 1),
        UIColor(named: "thumb_blue") ?? #colorLiteral(red: 0.5225894451, green: 0.8275025487, blue: 0.9676052928, alpha: 1),
        UIColor(named: "thumb_purple") ?? #colorLiteral(red: 0.6694304347, green: 0.581161797, blue: 0.9623679519, alpha: 1)
    ]
    
    func limitText() {
        let lengthLimit: Int = thumbTxt.containsEmoji ? 1 : 2
        thumbTxt = thumbTxt.uppercased()
        if thumbTxt.count > lengthLimit {
             thumbTxt = String(thumbTxt.prefix(lengthLimit))
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("app_background")
                    .ignoresSafeArea()
                VStack {
                    ZStack {
                        Color(background.cgColor)
                        TextField("", text: $thumbTxt)
                            .font(.system(size: 90))
                            .onReceive(Just(thumbTxt)) { _ in
                                limitText()
                            }
                            .multilineTextAlignment(.center)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .circular))
                    .frame(width: 200, height: 200)
                    .padding()
                    Picker(
                        "What do you want to edit?",
                        selection: $picked
                    ) {
                        ForEach(
                            pickerSegment,
                            id: \.self
                        ) {
                            Text($0)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    if picked == "Background" {
                        LazyVGrid(columns: [GridItem(), GridItem(), GridItem(), GridItem()]) {
                            ForEach(colorSelections, id: \.self) { color in
                                ThumbnailSquare(.inline, disp: $thumbTxt, color: .constant(color))
                                    .onTapGesture {
                                        self.background = color
                                    }
                            }
                        }
                    }
                    Spacer()
                }
                .padding()
            }
            .navigationBarTitle(
                "Select Icon",
                displayMode: .inline
            )
            .toolbar {
                ToolbarItem(
                    placement: .navigationBarTrailing
                ) {
                    Button("Done") {
                        x.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

struct EditThumbView_Previews: PreviewProvider {
    static var previews: some View {
        EditThumbView(thumbTxt: "AS", background: #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1))
    }
}
