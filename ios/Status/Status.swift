//
//  Status.swift
//  Status
//
//  Created by ender on 29/7/23.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), flutterData: nil)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), flutterData: nil)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        let sharedDefaults = UserDefaults.init(suiteName: "group.LoveLust")
        
        var flutterData: FlutterData? = nil
        
        if(sharedDefaults != nil) {
            do {
                let shared = sharedDefaults?.string(forKey: "widgetData")
                if(shared != nil) {
                    let decoder = JSONDecoder()
                    flutterData = try decoder.decode(FlutterData.self, from: shared!.data(using: .utf8)!)
                }
                
            } catch {
                print(error)
            }
        }

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, flutterData: flutterData)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct FlutterData: Decodable, Hashable {
    let text: String
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let flutterData: FlutterData?
}

struct StatusEntryView : View {
    var entry: Provider.Entry
    
    private var FlutterDataView: some View {
        Text(entry.flutterData!.text)
    }
    
    private var NoDataView: some View {
        Text("No data")
    }

    var body: some View {
        if(entry.flutterData == nil) {
            NoDataView
        } else {
            FlutterDataView
        }
    }
}

struct Status: Widget {
    let kind: String = "Status"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            StatusEntryView(entry: entry)
        }
        .configurationDisplayName("Status")
        .description("This is an example widget.")
    }
}

struct Status_Previews: PreviewProvider {
    static var previews: some View {
        StatusEntryView(entry: SimpleEntry(date: Date(),flutterData: nil))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
