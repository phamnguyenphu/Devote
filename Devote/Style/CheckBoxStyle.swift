//
//  CheckBoxStyle.swift
//  Devote
//
//  Created by Pham Nguyen Phu on 13/04/2023.
//

import SwiftUI

struct CheckBoxStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        return HStack(spacing: 10) {
            Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "circle")
                .foregroundColor(configuration.isOn ? .pink : .primary)
                .font(.system(size: 30, weight: .semibold, design: .rounded))
                .onTapGesture {
                    configuration.isOn.toggle()
                    feedback.notificationOccurred(.success)
                    if configuration.isOn {
                        playSound(sound: "sound-rise", type: "mp3")
                    }
                    else {
                        playSound(sound: "sound-tap", type: "mp3")
                    }
                }
            configuration.label
        } //: HSTACK
    }
}

struct CheckBoxStyle_Previews: PreviewProvider {
    static var previews: some View {
        Toggle("Placeholder", isOn: .constant(true))
            .toggleStyle(CheckBoxStyle())
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
