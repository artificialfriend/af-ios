//
//  AFView.swift
//  af-ios
//
//  Created by Ashutosh Narang on 08/01/23.
//

import SwiftUI

struct AFView: View {
    @EnvironmentObject var af: AFOO
    @State private var shadowRadius = UIScreen.main.bounds.width * 0.075
    @State private var afImage: TraitInstanceImage = .green1
    
    var body: some View {
        ZStack {
            ZStack {
                Circle()
                    .background {
                        GeometryReader { geo in
                            Color.clear
                                .onAppear {
                                    shadowRadius = geo.size.width / 12
                                }
                        }
                    }
                    .shadow(
                        color: af.af.interface.bubbleColor.opacity(0.3),
                        radius: shadowRadius,
                        x: s0,
                        y: shadowRadius / 1
                    )
                    
                Circle()
                    .blendMode(.destinationOut)
            }
            .compositingGroup()
            
            Circle()
                .fill(af.af.interface.bubbleColor).opacity(0.3)
                .background(Blur())
                .clipShape(Circle())
                
            //af.af.interface.afImage
            setAFImage()
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            af.af.interface.bubbleImage
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
        //.animation(.linear(duration: 0.5), value: af.af.skinColor)
        .frame(maxWidth: 400)
        .aspectRatio(contentMode: .fit)
    }
    
    func setAFImage() -> Image {
        if af.af.skinColor == .green && af.af.hairstyle == .one { return TraitInstanceImage.green1.image }
        else if af.af.skinColor == .green && af.af.hairstyle == .two { return TraitInstanceImage.green2.image }
        else if af.af.skinColor == .green && af.af.hairstyle == .three { return TraitInstanceImage.green3.image }
        else if af.af.skinColor == .green && af.af.hairstyle == .four { return TraitInstanceImage.green4.image }
        else if af.af.skinColor == .blue && af.af.hairstyle == .one { return TraitInstanceImage.blue1.image }
        else if af.af.skinColor == .blue && af.af.hairstyle == .two { return TraitInstanceImage.blue2.image }
        else if af.af.skinColor == .blue && af.af.hairstyle == .three { return TraitInstanceImage.blue3.image }
        else if af.af.skinColor == .blue && af.af.hairstyle == .four { return TraitInstanceImage.blue4.image }
        else if af.af.skinColor == .purple && af.af.hairstyle == .one { return TraitInstanceImage.purple1.image }
        else if af.af.skinColor == .purple && af.af.hairstyle == .two { return TraitInstanceImage.purple2.image }
        else if af.af.skinColor == .purple && af.af.hairstyle == .three { return TraitInstanceImage.purple3.image }
        else if af.af.skinColor == .purple && af.af.hairstyle == .four { return TraitInstanceImage.purple4.image }
        else if af.af.skinColor == .pink && af.af.hairstyle == .one { return TraitInstanceImage.pink1.image }
        else if af.af.skinColor == .pink && af.af.hairstyle == .two { return TraitInstanceImage.pink2.image }
        else if af.af.skinColor == .pink && af.af.hairstyle == .three { return TraitInstanceImage.pink3.image }
        else if af.af.skinColor == .pink && af.af.hairstyle == .four { return TraitInstanceImage.pink4.image }
        else { return TraitInstanceImage.green1.image }
    }
}

struct AFView_Previews: PreviewProvider {
    static var previews: some View {
        AFView()
            .environmentObject(AFOO())
            .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro"))
    }
}
