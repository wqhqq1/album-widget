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
        SimpleEntry(date: Date(), displayStr: NSLocalizedString("noContent", comment: ""))
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        var entry = SimpleEntry(date: Date())
        let data = PhotoData()
        let albumRange = Int(try! String(contentsOf: defaultPath.appendingPathComponent("range"), encoding: .utf8))!
        if albumRange == 0 {
            completion(SimpleEntry(date: Date(), displayStr: "Failed"))
            return
        }
        let albumIndex = (0..<albumRange).random
        let photoRange = Int(try! String(contentsOf: defaultPath.appendingPathComponent("range\(albumIndex)"), encoding: .utf8))!
        if photoRange == 0 {
            completion(SimpleEntry(date: Date(), displayStr: NSLocalizedString("noContent", comment: "")))
            return
        }
        let photoIndex = (0..<photoRange).random
        let photo = data.getData(in: albumIndex, at: photoIndex) as? Data
        if let photo = photo {
            entry = SimpleEntry(date: Date(), photo: photo)
        }
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
        if rangeInt == 0 {
            print("empty")
            entry = SimpleEntry(date: currentDate,
                                displayStr: "\(NSLocalizedString("noContent", comment: ""))(\(configuration.Album?.displayString ?? ""))")
        } else {
            let idxInt = (0..<rangeInt).random
            let photo = data.getData(in: album, at: idxInt) as! Data
//            let name = data.getData(in: album, at: nil) as! String
            let preferredColorFloat = UIImage(data: photo)!.getPreferredColor()!
            let preferredColor = Color(.displayP3, white: 1-Double(preferredColorFloat), opacity: 1)
            entry = SimpleEntry(date: currentDate, photo: photo, displayStr: configuration.Album?.displayString ?? NSLocalizedString("neverSet", comment: ""), preferredColor: preferredColor)
            try! "\(idxInt + 1)".write(to: defaultPath.appendingPathComponent("idx")
                              , atomically: true, encoding: .utf8)
        }
        var refreshAfter = Int((try? String(contentsOf: defaultPath.appendingPathComponent("refreshTime"), encoding: .utf8)) ?? "1")!
        if refreshAfter <= 0 || refreshAfter >= 24 {
            refreshAfter = 1
        }
        let timeline = Timeline(entries: [entry], policy: .after(Calendar.current.date(byAdding: .hour, value: refreshAfter
                                                                                       , to: currentDate)!))
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    var photo: Data? = nil
    var displayStr: String = ""
    var preferredColor = Color.gray
}

struct AlbumWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        GeometryReader { geo in
            ZStack {
                if let photo = entry.photo {
                    Image(uiImage: UIImage(data: photo)!).resizable().scaledToFill()
                        .frame(width: geo.size.width, height: geo.size.height)
                        .overlay(VStack {
                            Spacer()
                            HStack {
                                Text(entry.displayStr)
                                    .font(entry.displayStr.count>3 ? .headline:.custom("", size: 50))
                                    .fontWeight(.bold)
                                    .padding(.leading)
                                    .foregroundColor(entry.preferredColor)
                                Spacer()
                            }
                        })
                }
                VStack {
                    Spacer()
                    HStack {
                        Text(entry.displayStr)
                            .font(entry.displayStr.count>3 ? .headline:.custom("", size: 50))
                            .fontWeight(.bold)
                            .padding(.leading)
                            .foregroundColor(entry.preferredColor)
                        Spacer()
                    }
                }
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
        .configurationDisplayName(NSLocalizedString("widgetName", comment: ""))
        .description(NSLocalizedString("widgetDiscription", comment: ""))
    }
}

