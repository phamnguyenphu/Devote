//
//  DevoteWidget.swift
//  DevoteWidget
//
//  Created by Pham Nguyen Phu on 14/04/2023.
//

import SwiftUI
import WidgetKit

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct DevoteWidgetEntryView: View {
    var entry: Provider.Entry
    
    @Environment(\.widgetFamily) var widgetFamily
    
    var fontStyle: Font {
        if widgetFamily == .systemSmall {
            return .system(.footnote, design: .rounded)
        }
        else {
            return .system(.headline, design: .rounded)
        }
    }
    
    var body: some View {
        ZStack {
            backgroundGradient
            Image("rocket-small")
                .resizable()
                .scaledToFit()
        } //: ZSTACK
        .overlay(alignment: .topTrailing) {
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(width: widgetFamily != .systemSmall ? 56 : 36, height: widgetFamily != .systemSmall ? 56 : 36)
                .padding(widgetFamily != .systemSmall ? 14 : 12)
        }
        .overlay(alignment: widgetFamily != .systemSmall ? .bottomLeading : .bottom) {
            Text("Just do it")
                .padding(.horizontal, 12)
                .padding(.vertical, 5)
                .foregroundColor(.white)
                .font(fontStyle)
                .fontWeight(.bold)
                .background(.black.opacity(0.5).blendMode(.overlay))
                .clipShape(Capsule())
                .padding(widgetFamily != .systemSmall ? 15 : 10)
        }
    }
}

struct DevoteWidget: Widget {
    let kind: String = "DevoteWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            DevoteWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Devote Launcher")
        .description("This is an example widget for the personal task manager app.")
    }
}

struct DevoteWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DevoteWidgetEntryView(entry: SimpleEntry(date: Date()))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            DevoteWidgetEntryView(entry: SimpleEntry(date: Date()))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            DevoteWidgetEntryView(entry: SimpleEntry(date: Date()))
                .previewContext(WidgetPreviewContext(family: .systemLarge))
        }
    }
}
