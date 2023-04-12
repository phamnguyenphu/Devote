//
//  BackgroundImageView.swift
//  Devote
//
//  Created by Pham Nguyen Phu on 12/04/2023.
//

import SwiftUI

struct BackgroundImageView: View {
    var body: some View {
        Image("rocket")
            .antialiased(true)
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
            .background(
                backgroundGradient
            )
    }
}

struct BackgroundImageView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundImageView()
    }
}
