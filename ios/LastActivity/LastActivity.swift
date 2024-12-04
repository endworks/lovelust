//
//  LastActivity.swift
//  LastActivity
//
//  Created by ender on 31/7/23.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), widgetData: nil, configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), widgetData: nil, configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
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
        } else {
            print("empty sharedWidgetData")
        }

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, widgetData: widgetData, configuration: configuration)
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
    let configuration: ConfigurationIntent
}

enum DateError: String, Error {
    case invalidDate
}

struct LastActivityEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var widgetFamily
    
    private var WidgetView: some View {
        let moodString = LocalizedStringKey(entry.widgetData!.sexualActivity.mood ?? "NO_MOOD")
        let placeString = LocalizedStringKey(entry.widgetData!.sexualActivity.place ?? "NO_PLACE")
        let safetyString = LocalizedStringKey(entry.widgetData!.safety)
        let contraceptiveString = LocalizedStringKey( entry.widgetData!.sexualActivity.birthControl ?? "NO_CONTRACEPTIVE")
        let partnerContraceptiveString = LocalizedStringKey( entry.widgetData!.sexualActivity.partnerBirthControl ?? "NO_CONTRACEPTIVE")

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        let dateString = dateFormatter.string(from: entry.widgetData!.sexualActivity.date)
        dateFormatter.dateFormat = "EEEE"
        let weekdayString = dateFormatter.string(from: entry.widgetData!.sexualActivity.date)
        dateFormatter.dateFormat = "d"
        let dayString = dateFormatter.string(from: entry.widgetData!.sexualActivity.date)

        var safetyColor: Color = .primary
        if entry.widgetData!.safety == "UNSAFE" {
            safetyColor = .red
        } else if entry.widgetData!.safety == "PARTIALLY_UNSAFE" {
            safetyColor = .orange
        }
        
        var partnerString = String(localized: "UNKNOWN")
        if entry.widgetData!.partner != nil {
            partnerString = entry.widgetData!.partner!.name
        }
        
        
        return VStack {
            HStack(alignment: .top, spacing: 0) {
                VStack(alignment: .leading, spacing: -2) {
                    Text(weekdayString)
                        .font(.caption2)
                        .fontDesign(.rounded)
                        .fontWeight(.semibold)
                        .textCase(.uppercase)
                        .foregroundColor(.red)
                        .lineLimit(1)
                        .truncationMode(.tail)
                    Text(dayString)
                        .font(.largeTitle)
                        .fontWeight(.light)
                        .lineLimit(1)
                        .truncationMode(.tail)
                    Spacer()
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 0) {
                    Text(partnerString).font(.headline)
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .privacySensitive()
                        .redacted(reason: .privacy)
                        .redacted(reason: entry.widgetData!.sensitiveMode ? .placeholder : [])

                    if (widgetFamily != .systemSmall && entry.widgetData!.sexualActivity.mood != nil) {
                        Text(moodString)
                            .font(.caption2)
                            .fontDesign(.rounded)
                            .fontWeight(.semibold)
                            .textCase(.uppercase)
                            .foregroundColor(.pink)
                            .lineLimit(1)
                            .truncationMode(.tail)
                    }
                    
                }
            }
            Spacer()
            HStack(spacing: 4) {
                if widgetFamily != .systemSmall && entry.widgetData!.sexualActivity.place != nil {
                    Text(placeString)
                        .font(.caption)
                        .fontDesign(.rounded)
                        .fontWeight(.semibold)
                        .textCase(.uppercase)
                        .foregroundColor(.purple)
                }
                Text(dateString)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .font(.caption)
                    .fontDesign(.rounded)
                    .textCase(.uppercase)
                    .foregroundColor(.gray)
                Spacer()
            }
            HStack(alignment: .bottom, spacing: 0) {
                if widgetFamily == .systemSmall {
                    Text(safetyString)
                        .font(.headline)
                        .foregroundColor(safetyColor)
                } else {
                    Text(safetyString)
                        .font(.title)
                        .foregroundColor(safetyColor)
                    
                }
                Spacer()
            }
           if entry.widgetData?.sexualActivity.birthControl != nil || entry.widgetData?.sexualActivity.partnerBirthControl != nil {
               HStack(alignment: .top) {
                   if entry.widgetData?.sexualActivity.birthControl != nil {
                       Text(contraceptiveString)
                           .lineLimit(1)
                           .truncationMode(.tail)
                           .font(.caption)
                           .fontDesign(.rounded)
                           .fontWeight(.semibold)
                           .textCase(.uppercase)
                           .foregroundColor(.cyan)
                   }
                   if entry.widgetData?.sexualActivity.partnerBirthControl != nil && entry.widgetData?.sexualActivity.partnerBirthControl != entry.widgetData?.sexualActivity.birthControl{
                       Text(partnerContraceptiveString)
                           .lineLimit(1)
                           .truncationMode(.tail)
                           .font(.caption)
                           .fontDesign(.rounded)
                           .fontWeight(.semibold)
                           .textCase(.uppercase)
                           .foregroundColor(.cyan)
                   }
                   Spacer()
               }
           }
        }
        .containerBackground(for: .widget) {}
        .privacySensitive()
    }
    
    private var NoDataView: some View {
        VStack {
             HStack(alignment: .top, spacing: 0) {
                 VStack(alignment: .leading, spacing: -2) {
                     Text("Saturday")
                         .font(.caption2)
                         .fontDesign(.rounded)
                         .fontWeight(.semibold)
                         .textCase(.uppercase)
                         .foregroundColor(.red)
                     Text("1")
                         .font(.largeTitle)
                         .fontWeight(.light)
                     Spacer()
                 }
                 Spacer()
                 VStack(alignment: .trailing, spacing: 0) {
                    Text("Flavia").font(.headline)
                         .lineLimit(1)
                         .truncationMode(.tail)

                    if widgetFamily != .systemSmall {
                        Text("Horny")
                            .font(.caption2)
                            .fontDesign(.rounded)
                            .fontWeight(.semibold)
                            .textCase(.uppercase)
                            .foregroundColor(.pink)
                            .lineLimit(1)
                            .truncationMode(.tail)
                    }
                 }
             }
             Spacer()
             HStack(spacing: 4) {
                 if widgetFamily != .systemSmall {
                     Text("Bedroom")
                         .font(.caption)
                         .fontDesign(.rounded)
                         .fontWeight(.semibold)
                         .textCase(.uppercase)
                         .foregroundColor(.purple)
                 }
                 Text("a month ago")
                     .lineLimit(1)
                     .truncationMode(.tail)
                     .font(.caption)
                     .fontDesign(.rounded)
                     .textCase(.uppercase)
                     .foregroundColor(.gray)
                 Spacer()
             }
             HStack(alignment: .bottom, spacing: 0) {
                 if widgetFamily == .systemSmall {
                     Text("Protected sex")
                         .font(.headline)
                         .foregroundColor(.primary)
                 } else {
                     Text("Protected sex")
                         .font(.title)
                         .foregroundColor(.primary)
                     
                 }
                 Spacer()
             }
             HStack(alignment: .top) {
                Text("Condom")
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .font(.caption)
                    .fontDesign(.rounded)
                    .fontWeight(.semibold)
                    .textCase(.uppercase)
                    .foregroundColor(.cyan)
                Spacer()
             }
        }
        .containerBackground(for: .widget) {}
        .redacted(reason: .placeholder)
        
    }
    
    private var InlineView: some View {
        let safetyString = LocalizedStringKey(entry.widgetData!.safety)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        let dateString = dateFormatter.string(from: entry.widgetData!.sexualActivity.date)
        
        return Text("\(safetyString) \(dateString)")
            .containerBackground(for: .widget) {}
            .font(.caption)
            .fontDesign(.rounded)
            .foregroundColor(.gray)
    }
    
    private var InlineNoDataView: some View {
       Text("SAFE 3 Nov 2024")
            .containerBackground(for: .widget) {}
            .font(.caption)
            .fontDesign(.rounded)
            .foregroundColor(.gray)
            .redacted(reason: .placeholder)
    }
    
    private var RectangularView: some View {
        let safetyString = LocalizedStringKey(entry.widgetData!.safety)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        let dateString = dateFormatter.string(from: entry.widgetData!.sexualActivity.date)
        let contraceptiveString = LocalizedStringKey( entry.widgetData!.sexualActivity.birthControl ?? "NO_CONTRACEPTIVE")
        let partnerContraceptiveString = LocalizedStringKey( entry.widgetData!.sexualActivity.partnerBirthControl ?? "NO_CONTRACEPTIVE")
        
        return VStack() {
            HStack{
                Text(dateString)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .font(.caption)
                    .fontDesign(.rounded)
                    .textCase(.uppercase)
                    .foregroundColor(.gray)
                Spacer()
            }
            HStack{
                Text(safetyString)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .font(.headline)
                    .foregroundColor(.primary)
                Spacer()
            }
            if entry.widgetData?.sexualActivity.birthControl != nil || entry.widgetData?.sexualActivity.partnerBirthControl != nil {
                HStack(alignment: .top) {
                    if entry.widgetData?.sexualActivity.birthControl != nil {
                        Text(contraceptiveString)
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .font(.caption)
                            .fontDesign(.rounded)
                            .fontWeight(.semibold)
                            .textCase(.uppercase)
                    }
                    if entry.widgetData?.sexualActivity.partnerBirthControl != nil && entry.widgetData?.sexualActivity.partnerBirthControl != entry.widgetData?.sexualActivity.birthControl{
                        Text(partnerContraceptiveString)
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .font(.caption)
                            .fontDesign(.rounded)
                            .fontWeight(.semibold)
                            .textCase(.uppercase)
                    }
                    Spacer()
                }
            }
        }
        .containerBackground(for: .widget) {}
    }
    
    private var RectangularNoDataView: some View {
        return VStack() {
            HStack{
                Text("3 Nov 2024")
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .font(.caption)
                    .fontDesign(.rounded)
                    .textCase(.uppercase)
                    .foregroundColor(.gray)
                    .redacted(reason: .placeholder)
                Spacer()
            }
            HStack{
                Text("SAFE")
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .redacted(reason: .placeholder)
                Spacer()
            }
        }
        .containerBackground(for: .widget) {}
    }

    var body: some View {
        if (widgetFamily == .accessoryInline) {
            if (entry.widgetData != nil) {
                InlineView
            } else {
                InlineNoDataView
            }
        } else if (widgetFamily == .accessoryRectangular) {
            if (entry.widgetData != nil) {
                RectangularView
            } else {
                RectangularNoDataView
            }
        } else {
            if (entry.widgetData != nil) {
                WidgetView
            } else {
                NoDataView
            }
        }
    }
}

struct LastActivity: Widget {
    let kind: String = "LastActivity"
    let displayName: LocalizedStringKey = "lastActivity.displayName"
    let description: LocalizedStringKey = "lastActivity.description"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            LastActivityEntryView(entry: entry)
        }
        .configurationDisplayName(displayName)
        .description(description)
        .supportedFamilies([.systemSmall, .systemMedium, .accessoryInline, .accessoryRectangular])
    }
}

struct LastActivity_Previews: PreviewProvider {
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
        ejaculation: "IN_THE_ASS",
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
        LastActivityEntryView(entry: SimpleEntry(date: Date(), widgetData: widgetData, configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
