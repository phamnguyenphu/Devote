//
//  ListRowItemView.swift
//  Devote
//
//  Created by Pham Nguyen Phu on 13/04/2023.
//

import SwiftUI

struct ListRowItemView: View {
    // MARK: - PROPERTY

    @Environment(\.managedObjectContext) var viewContext
    @ObservedObject var item: Item

    // MARK: - BODY

    var body: some View {
        Toggle(isOn: $item.completion) {
            Text(item.task ?? "")
                .font(.system(.title2))
                .fontWeight(.heavy)
                .foregroundColor(item.completion ? .pink : .primary)
                .padding(.vertical, 12)
                .animation(.default, value: item.completion)
        }
        .toggleStyle(CheckBoxStyle())
        .onReceive(item.objectWillChange, perform: {
            if self.viewContext.hasChanges {
                try? self.viewContext.save()
            }
        })
    }
}
