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
        var entry: SimpleEntry, album = (configuration.Album?.index ?? 0) as! Int
        let currentDate = Date()
        let data = PhotoData()
        let range = try? String(contentsOf: defaultPath.appendingPathComponent("range\(album)")
                                , encoding: .utf8)
        guard let rge = range else { return }
        let rangeInt = Int(rge)!
        let idx = try? String(contentsOf: defaultPath.appendingPathComponent("idx")
                              , encoding: .utf8)
        var idxInt = Int(idx ?? "0")!
        if idxInt >= rangeInt { idxInt = 0 }
        let photo = data.getData(in: album, at: idxInt) as! Data
        let name = data.getData(in: album, at: nil) as! String
        entry = SimpleEntry(date: currentDate, photo: photo, album: name)
        try! "\(idxInt + 1)".write(to: defaultPath.appendingPathComponent("idx")
                          , atomically: true, encoding: .utf8)
        if rangeInt == 0 {
            entry = SimpleEntry(date: currentDate, album: configuration.Album?.displayString ?? "")
        }

        let timeline = Timeline(entries: [entry], policy: .after(Calendar.current.date(byAdding: .hour, value: 1
                                                                                       , to: currentDate)!))
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    var photo: Data? = nil
    var album: String = ""
}

struct AlbumWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            Text("There's no photo in the album \(entry.album).")
            if let photo = entry.photo {
                Image(uiImage: UIImage(data: photo)!).resizable().scaledToFill()
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

