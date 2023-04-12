//
//  Constants.swift
//  Devote
//
//  Created by Pham Nguyen Phu on 12/04/2023.
//

import SwiftUI

// MARK: - FORMATTER

let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()