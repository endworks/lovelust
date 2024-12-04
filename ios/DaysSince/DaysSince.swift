//
//  DaysSince.swift
//  DaysSince
//
//  Created by ender on 1/8/23.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), widgetData: nil)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), widgetData: nil)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        let sharedDefaults = UserDefaults.init(suiteName: "group.LoveLust")
        
        var widgetData: ActivityWidgetData? = nil
        
        if(sharedDefaults != nil) {
            do {
                let sharedWidgetData = sharedDefaults?.string(forKey: "lastActivity")
                
                if (sharedWidgetData != nil) {
                    let formatter = DateFormatter()
                    formatter.calendar = Calendar(identifier: .iso8601)
                    formatter.locale = Locale(identifier: "en_US_POSIX")
                    formatter.timeZone = TimeZone(secondsFromGMT: 0)
                    
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
                        let container = try decoder.singleValueContainer()
                        let dateStr = try container.decode(String.self)

                        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
                        if let date = formatter.date(from: dateStr) {
                            return date
                        }
                        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
                        if let date = formatter.date(from: dateStr) {
                            return date
                        }
                        return Date()
                    })
                    
                    widgetData = try decoder.decode(ActivityWidgetData.self, from: sharedWidgetData!.data(using: .utf8)!)
                    
                }
                
            } catch {
                print(error)
            }
        }

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, widgetData: widgetData)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct ActivityWidgetData: Decodable, Hashable {
    let soloActivity: Activity
    let sexualActivity: Activity
    let partner: Partner?
    let safety: String
    let moodEmoji: String
    let sensitiveMode: Bool
}

struct Activity: Decodable, Hashable {
    let id: String
    let partner: String?
    let birthControl: String?
    let partnerBirthControl: String?
    let date: Date
    let location: String?
    let notes: String?
    let duration: Int
    let orgasms: Int
    let partnerOrgasms: Int
    let place: String?
    let initiator: String?
    let rating: Int
    let type: String?
    let mood: String?
    let ejaculation: String?
    let practices: [IdName]?
    let watchedPorn: Bool?
    let healthRecordId: String?
}

struct Partner: Decodable, Hashable {
    let id: String
    let sex: String
    let gender: String
    let name: String
    let meetingDate: Date
    let birthDay: Date?
    let notes: String?
    let phone: String?
    let instagram: String?
    let x: String?
    let snapchat: String?
    let onlyfans: String?
}

struct IdName: Decodable, Hashable {
    let id: String
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let widgetData: ActivityWidgetData?
}

enum DateError: String, Error {
    case invalidDate
}

struct DaysSinceEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var widgetFamily
    @Environment(\.widgetRenderingMode) var widgetRenderingMode
    private var days: Int
    private var daysString: String
    private var fontDays: Font
    private var fontTitle: Font
    private var fontSubtitle: Font
    private var widgetBackground: Color
    private var widgetForeground: Color
    private var widgetForegroundTitle: Color
    private var widgetForegroundSubtitle: Color
    
    init(entry: Provider.Entry) {
        self.entry = entry
        if (entry.widgetData != nil) {
            days = Calendar
                .current
                .dateComponents(
                    [.day],
                    from: entry.widgetData!.sexualActivity.date,
                    to: Date()
                ).day!
        } else {
            days = 0
        }
        daysString = days == 1 ? "day" : "days"
        
        widgetBackground = .clear
        widgetForeground = .primary
        widgetForegroundTitle = .primary
        widgetForegroundSubtitle = .gray
        
        if (days == 0) {
            widgetForeground = .green
        } else  if (days >= 30) {
            widgetBackground = .red
            widgetForeground = .white
            widgetForegroundTitle = .white
            widgetForegroundSubtitle = .white
        } else  if (days >= 14) {
            widgetBackground = .orange
            widgetForeground = .white
            widgetForegroundTitle = .white
            widgetForegroundSubtitle = .yellow
        } else  if (days >= 7) {
            widgetForeground = .orange
        }

        fontDays = Font.system(size: 16)
        fontTitle = Font.system(size: 8)
        fontSubtitle = Font.system(size: 8)
        if (widgetFamily == .systemSmall || widgetFamily == .systemMedium) {
            fontDays = Font.system(size: 64)
            fontTitle = Font.system(size: 24)
            fontSubtitle = Font.system(size: 8)
        } else if (widgetFamily == .systemLarge) {
            fontDays = Font.system(size: 128)
            fontTitle = Font.system(size: 48)
            fontSubtitle = Font.system(size: 16)
        }
        
    }
    
    private var WidgetView: some View {
        ZStack {
            VStack(spacing: 0) {
                Text(days.description)
                    .font(fontDays)
                    .fontWeight(.bold)
                    .fontDesign(.rounded)
                    .foregroundColor(widgetForeground)
                Text(daysString)
                    .font(fontTitle)
                    .fontDesign(.rounded)
                    .fontWeight(.semibold)
                    .textCase(.uppercase)
                    .foregroundColor(widgetForegroundTitle)
                if (widgetFamily == .systemSmall || widgetFamily == .systemMedium || widgetFamily == .systemLarge) {
                    Text("without sex")
                        .font(fontSubtitle)
                        .fontDesign(.rounded)
                        .fontWeight(.semibold)
                        .textCase(.uppercase)
                        .foregroundColor(widgetForegroundSubtitle)
                }
            }
        }
        .containerBackground(for: .widget) {
            widgetBackground
        }
    }
    
    private var NoDataView: some View {
        VStack(spacing: 0) {
            Text("7")
                .font(fontDays)
                .fontWeight(.bold)
                .fontDesign(.rounded)
                .foregroundColor(widgetForeground)
                .redacted(reason: .placeholder)
            Text("days")
                .font(fontTitle)
                .fontDesign(.rounded)
                .fontWeight(.semibold)
                .textCase(.uppercase)
                .foregroundColor(widgetForegroundTitle)
            Text("without sex")
                .font(fontSubtitle)
                .fontDesign(.rounded)
                .fontWeight(.semibold)
                .textCase(.uppercase)
                .foregroundColor(widgetForegroundSubtitle)
        }
        .containerBackground(for: .widget) {
            widgetBackground
        }
    }
    
    private var AccessoryView: some View {
        VStack(spacing: 0) {
            Text(days.description)
                .font(.title)
                .fontWeight(.bold)
                .fontDesign(.rounded)
            Text(daysString)
                .font(.caption)
                .fontDesign(.rounded)
                .fontWeight(.semibold)
                .textCase(.uppercase)
            if (widgetFamily == .systemSmall || widgetFamily == .systemMedium || widgetFamily == .systemLarge) {
                Text("without sex")
                    .font(.caption2)
                    .fontDesign(.rounded)
                    .fontWeight(.semibold)
                    .textCase(.uppercase)
            }
        }
        .containerBackground(for: .widget) {}
    }
    
    private var AccessoryNoDataView: some View {
        VStack(spacing: 0) {
            Text("7")
                .font(.title)
                .fontWeight(.bold)
                .fontDesign(.rounded)
            Text("days")
                .font(.caption)
                .fontDesign(.rounded)
                .fontWeight(.semibold)
                .textCase(.uppercase)
            if (widgetFamily == .systemSmall || widgetFamily == .systemMedium || widgetFamily == .systemLarge) {
                Text("without sex")
                    .font(.caption2)
                    .fontDesign(.rounded)
                    .fontWeight(.semibold)
                    .textCase(.uppercase)
            }
        }
        .redacted(reason: .placeholder)
        .containerBackground(for: .widget) {}
    }
    
    private var InlineView: some View {
        Text("\(days) \(daysString) without sex")
            .font(fontTitle)
            .fontDesign(.rounded)
            .fontWeight(.semibold)
            .privacySensitive()
            .containerBackground(for: .widget) {}
    }
    
    private var InlineNoDataView: some View {
        Text("7 days without sex")
            .font(fontTitle)
            .fontDesign(.rounded)
            .fontWeight(.semibold)
            .redacted(reason: .placeholder)
            .containerBackground(for: .widget) {}
    }
    
    var body: some View {
        if(widgetFamily == .accessoryInline) {
            if(entry.widgetData != nil) {
                InlineView
            } else {
                InlineNoDataView
            }
        } else if(widgetFamily == .accessoryCircular || widgetFamily == .accessoryRectangular) {
            if(entry.widgetData != nil) {
                AccessoryView
            } else {
                AccessoryNoDataView
            }
        } else {
            if(entry.widgetData != nil) {
                if (widgetFamily == .systemSmall || widgetFamily == .systemMedium || widgetFamily == .systemLarge) {
                    ZStack {
                        widgetBackground
                        WidgetView
                    }
                } else {
                    WidgetView
                }
            } else {
                NoDataView
            }
    }
    }
}

struct DaysSince: Widget {
    let kind: String = "DaysSince"
    let displayName: LocalizedStringKey = "daysSince.displayName"
    let description: LocalizedStringKey = "daysSince.description"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            DaysSinceEntryView(entry: entry)
        }
        .configurationDisplayName(displayName)
        .description(description)
        .supportedFamilies([.systemSmall, .accessoryInline, .accessoryRectangular, .accessoryCircular])
    }
}


    struct DaysSince_Previews: PreviewProvider {
        static var partner = Partner(
            id: "11545aaf-0b8f-41a5-8b53-7464f2e931aa",
            sex: "F",
            gender: "F",
            name: "Flavia",
            meetingDate: Date(),
            birthDay: Date(),
            notes: nil,
            phone: nil,
            instagram: nil,
            x: nil,
            snapchat: nil,
            onlyfans: nil
        )

        static var lastSexualActivity = Activity(
            id: "1d934cb5-efe0-41d6-a0bc-6d6c6f567843",
            partner: "11545aaf-0b8f-41a5-8b53-7464f2e931aa",
            birthControl: "CONDOM",
            partnerBirthControl: nil,
            date: Date(),
            location: "",
            notes: "",
            duration: 10,
            orgasms: 1,
            partnerOrgasms: 1,
            place: "BEDROOM",
            initiator: "ME",
            rating: 5,
            type: "SEXUAL_INTERCOURSE",
            mood: "HORNY",
            ejaculation: "IN_THE_ASS",
            practices: [],
            watchedPorn: false,
            healthRecordId: nil
        )

        static var lastSoloActivity = Activity(
            id: "e29341fa-e09b-444b-a42a-69f9d7c21682",
            partner: nil,
            birthControl: nil,
            partnerBirthControl: nil,
            date: Date(),
            location: "",
            notes: "",
            duration: 20,
            orgasms: 1,
            partnerOrgasms: 0,
            place: "BEDROOM",
            initiator: "ME",
            rating: 4,
            type: "MASTURBATION",
            mood: "HORNY",
            ejaculation: nil,
            practices: [],
            watchedPorn: false,
            healthRecordId: nil
        )
        
        static var widgetData = ActivityWidgetData(
            soloActivity: lastSexualActivity,
            sexualActivity: lastSexualActivity,
            partner: partner,
            safety: "SAFE",
            moodEmoji: "🥵",
            sensitiveMode: false
        )
        
        static var previews: some View {
            DaysSinceEntryView(entry: SimpleEntry(date: Date(), widgetData: widgetData))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
        }
    }
