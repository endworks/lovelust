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
                let sharedWidgetData = sharedDefaults?.string(forKey: "lastSexualIntercourse")
                
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
                        throw DateError.invalidDate
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
            let entry = SimpleEntry(date: entryDate, widgetData: widgetData, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct ActivityWidgetData: Decodable, Hashable {
    let activity: Activity
    let partner: Partner?
    let safety: String
    let partnerString: String
    let safetyString: String
    let dateString: String
    let dayString: String
    let weekdayString: String
    let placeString: String
    let contraceptiveString: String
    let partnerContraceptiveString: String
    let moodString: String
    let moodEmoji: String
    let feelingsStrings: [String]
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
    let practices: [IdName]
}

struct Partner: Decodable, Hashable {
    let id: String
    let sex: String
    let gender: String
    let name: String
    let meetingDate: Date
    let notes: String?
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
        var safetyColor: Color = .primary

        if entry.widgetData!.safety == "UNSAFE" {
            safetyColor = .red
        } else if entry.widgetData!.safety == "PARTIALLY_UNSAFE" {
            safetyColor = .orange
        }

        
       return VStack {
            HStack(alignment: .top, spacing: 0) {
                VStack(alignment: .leading, spacing: -2) {
                    Text(entry.widgetData!.weekdayString)
                        .font(.caption2)
                        .fontDesign(.rounded)
                        .fontWeight(.semibold)
                        .textCase(.uppercase)
                        .foregroundColor(.red)
                        .lineLimit(1)
                        .truncationMode(.tail)
                    Text(entry.widgetData!.dayString)
                        .font(.largeTitle)
                        .fontWeight(.light)
                        .lineLimit(1)
                        .truncationMode(.tail)
                    Spacer()
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 0) {
                    Text(entry.widgetData!.partnerString).font(.headline)
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .privacySensitive()

                    if (widgetFamily != .systemSmall && entry.widgetData!.activity.mood != nil) {
                        Text(entry.widgetData!.moodString)
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
                if widgetFamily != .systemSmall && entry.widgetData!.activity.place != nil {
                    Text(entry.widgetData!.placeString)
                        .font(.caption)
                        .fontDesign(.rounded)
                        .fontWeight(.semibold)
                        .textCase(.uppercase)
                        .foregroundColor(.purple)
                }
                Text(entry.widgetData!.dateString)
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
                    Text(entry.widgetData!.safetyString)
                        .font(.headline)
                        .foregroundColor(safetyColor)
                } else {
                    Text(entry.widgetData!.safetyString)
                        .font(.title)
                        .foregroundColor(safetyColor)
                    
                }
                Spacer()
            }
           if entry.widgetData?.activity.birthControl != nil || entry.widgetData?.activity.partnerBirthControl != nil {
               HStack(alignment: .top) {
                   if entry.widgetData?.activity.birthControl != nil {
                       Text(entry.widgetData!.contraceptiveString)
                           .lineLimit(1)
                           .truncationMode(.tail)
                           .font(.caption)
                           .fontDesign(.rounded)
                           .fontWeight(.semibold)
                           .textCase(.uppercase)
                           .foregroundColor(.cyan)
                   }
                   if entry.widgetData?.activity.partnerBirthControl != nil && entry.widgetData?.activity.partnerBirthControl != entry.widgetData?.activity.birthControl{
                       Text(entry.widgetData!.partnerContraceptiveString)
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
        .privacySensitive()
        .padding()
    }
    
    private var NoDataView: some View {
        return VStack {
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
                Text(entry.widgetData!.contraceptiveString)
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
        .redacted(reason: .placeholder)
        .padding()
        
    }
    
    private var InlineView: some View {
        Text("\(entry.widgetData!.safetyString.uppercased()) \(entry.widgetData!.dateString)")
            .font(.caption)
            .fontDesign(.rounded)
            .foregroundColor(.gray)
    }
    
    private var RectangularView: some View {
        VStack() {
            HStack{
                Text(entry.widgetData!.dateString)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .font(.caption)
                    .fontDesign(.rounded)
                    .textCase(.uppercase)
                    .foregroundColor(.gray)
                Spacer()
            }
            HStack{
                Text(entry.widgetData!.safetyString)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .font(.headline)
                    .foregroundColor(.primary)
                Spacer()
            }
            if entry.widgetData?.activity.birthControl != nil || entry.widgetData?.activity.partnerBirthControl != nil {
                HStack(alignment: .top) {
                    if entry.widgetData?.activity.birthControl != nil {
                        Text(entry.widgetData!.contraceptiveString)
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .font(.caption)
                            .fontDesign(.rounded)
                            .fontWeight(.semibold)
                            .textCase(.uppercase)
                    }
                    if entry.widgetData?.activity.partnerBirthControl != nil && entry.widgetData?.activity.partnerBirthControl != entry.widgetData?.activity.birthControl{
                        Text(entry.widgetData!.partnerContraceptiveString)
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
    }

    var body: some View {
        if(widgetFamily == .accessoryInline) {
            InlineView
        } else if(widgetFamily == .accessoryRectangular) {
            RectangularView
        } else {
            if(entry.widgetData != nil) {
                WidgetView
            } else {
                NoDataView
            }
        }
    }
}

struct LastActivity: Widget {
    let kind: String = "LastActivity"
    let displayName:LocalizedStringKey = "lastActivity.displayName"
    let description:LocalizedStringKey = "lastActivity.description"

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
    static var lastSexualIntercourse = Activity(
        id: "1d934cb5-efe0-41d6-a0bc-6d6c6f567843",
        partner: nil,
        birthControl: "CONDOM",
        partnerBirthControl: nil,
        date: Date(),
        location: nil,
        notes: nil,
        duration: 10,
        orgasms: 1,
        partnerOrgasms: 1,
        place: "BEDROOM",
        initiator: "ME",
        rating: 4,
        type: "SEXUAL_INTERCOURSE",
        mood: "HORNY",
        practices: []
    )
    
    static var widgetData = ActivityWidgetData(
        activity: lastSexualIntercourse,
        partner: nil,
        safety: "SAFE",
        partnerString: "Flavia",
        safetyString: "Protected sex",
        dateString: "a month ago",
        dayString: "1",
        weekdayString: "Saturday",
        placeString: "Bedroom",
        contraceptiveString: "Condom",
        partnerContraceptiveString: "No contraceptive",
        moodString: "Horny",
        moodEmoji: "🥵",
        feelingsStrings: ["Safe", "Adventurous"]
    )
    
    static var previews: some View {
        LastActivityEntryView(entry: SimpleEntry(date: Date(), widgetData: widgetData, configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
