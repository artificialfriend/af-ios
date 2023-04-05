//
//  BuilderConnectorView.swift
//  AF
//
//  Created by Cam Crain on 2023-04-04.
//

import SwiftUI

struct BuilderConnectorView: View {
    @EnvironmentObject var af: AFOO
    
    var body: some View {
        af.af.interface.lineColor
            .frame(width: 3, height: 16)
            .cornerRadius(1.5)
    }
}

struct BuilderConnectorView_Previews: PreviewProvider {
    static var previews: some View {
        BuilderConnectorView()
    }
}
