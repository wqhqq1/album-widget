//
//  AlbumWidget.swift
//  AlbumWidget
//
//  Created by wqh on 2020/11/21.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = [], album = (configuration.Album?.index ?? 0) as! Int
        let currentDate = Date()
        let data = PhotoData(path: defaultPath) ?? PhotoData()
        for (index, photo) in data.Photo[album].enumerated() {
            let entryDate = Calendar.current.date(byAdding: .hour, value: index, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, photo: photo.data, album: data.data[album].index)
            entries.append(entry)
        }
        if entries.count == 0 {
            entries.append(SimpleEntry(date: currentDate, album: configuration.Album?.displayString ?? ""))
        }

        let timeline = Timeline(entries: entries, policy: .after(Calendar.current.date(byAdding: .hour, value: data.Photo[album].count, to: currentDate)!))
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    var photo: UIImage? = nil
    var album: String = ""
}

struct AlbumWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            Text("There's no photo in the album \(entry.album).")
            if let photo = entry.photo {
                Image(uiImage: photo).resizable().scaledToFill()
            }
        }
    }
}

@main
struct AlbumWidget: Widget {
    let kind: String = "AlbumWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            AlbumWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Album Widget")
        .description("This widget shows photos from your customized album.")
    }
}

