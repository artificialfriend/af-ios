//
//  AIImageView.swift
//  AF
//
//  Created by Cam Crain on 2023-03-31.
//

import SwiftUI

struct AIImageView: View {
    @EnvironmentObject var af: AFOO
    let image: Image
    
    var body: some View {
        image
            .resizable()
            .cornerRadius(32)
            .padding(.horizontal, s12)
    }
}
