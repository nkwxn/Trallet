//
//  ThumbnailSquare.swift
//  Trallet
//
//  Created by Nicholas on 22/08/21.
//

import SwiftUI

// MARK: - Thumbnail size mode
enum ThumbMode: CGFloat {
    case inline = 35
    case grid = 90.0
}

struct ThumbnailSquare: View {
    var thumbSize: ThumbMode
    @Binding var imgDisplay: String
    @Binding var color: UIColor
    
    init(_ mode: ThumbMode, disp: Binding<String>, color: Binding<UIColor>) {
        self.thumbSize = mode
        self._imgDisplay = disp
        self._color = color
    }
    
    var body: some View {
        ZStack {
            Color(color)
            Text(imgDisplay)
                .font(.system(size: thumbSize.rawValue))
                .foregroundColor(.white)
                .padding(10)
        }
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .circular))
        .aspectRatio(1, contentMode: .fill)
    }
}

struct ThumbnailSquare_Previews: PreviewProvider {
    static var previews: some View {
        ThumbnailSquare(.inline, disp: .constant("AN"), color: .constant(UIColor.systemBlue))
    }
}
