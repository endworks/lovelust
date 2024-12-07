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
        SimpleEntry(date: Date(), widgetData: nil, configuration: LastActivityConfigurationIntent())
    }

    func getSnapshot(for configuration: LastActivityConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), widgetData: nil, configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: LastActivityConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
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
    let soloActivity: Activity?
    let sexualActivity: Activity?
    let partner: Partner?
    let safety: String
    let moodEmoji: String
    let privacyMode: Bool
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
    let configuration: LastActivityConfigurationIntent
}

enum DateError: String, Error {
    case invalidDate
}

struct LastActivityEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var widgetFamily
    @Environment(\.redactionReasons) var redactionReasons
    
    private var WidgetView: some View {
        let dateFormatter = DateFormatter()
        let moodString: LocalizedStringKey
        var partnerString: String
        let placeString: LocalizedStringKey
        let safetyString: LocalizedStringKey
        let contraceptiveString: LocalizedStringKey
        let partnerContraceptiveString: LocalizedStringKey
        let dateString: String
        let weekdayString: String
        let dayString: String
        var activity: Activity?
        let partner: Partner?
        var safety: String
        var safetyColor: Color
        var privacyMode: Bool
        var redactionReason: RedactionReasons
        
        if entry.widgetData != nil {
            if entry.configuration.type.rawValue == 2 {
                activity = entry.widgetData?.soloActivity
            } else {
                activity = entry.widgetData?.sexualActivity
            }

            partner = entry.widgetData!.partner
            safety = entry.widgetData!.safety
            privacyMode = entry.widgetData!.privacyMode
        } else {
            activity = nil
            partner = nil
            safety = "UNSAFE"
            privacyMode = false
        }
        
        if activity != nil {
            moodString = LocalizedStringKey(activity!.mood ?? "NO_MOOD")
            placeString = LocalizedStringKey(activity!.place ?? "NO_PLACE")
            contraceptiveString = LocalizedStringKey( activity!.birthControl ?? "NO_CONTRACEPTIVE")
            partnerContraceptiveString = LocalizedStringKey( activity!.partnerBirthControl ?? "NO_CONTRACEPTIVE")
            
            dateFormatter.dateStyle = .medium
            dateString = dateFormatter.string(from: activity!.date)
            dateFormatter.dateFormat = "EEEE"
            weekdayString = dateFormatter.string(from: activity!.date)
            dateFormatter.dateFormat = "d"
            dayString = dateFormatter.string(from: activity!.date)
            
            if entry.configuration.type.rawValue == 2 {
                safetyString = LocalizedStringKey("Masturbation")
                safetyColor = .pink
                partnerString = ""
                privacyMode = false
            } else {
                safetyString = LocalizedStringKey(safety)
                safetyColor = .primary
                if safety == "UNSAFE" {
                    safetyColor = .red
                } else if entry.widgetData!.safety == "PARTIALLY_UNSAFE" {
                    safetyColor = .orange
                }

                partnerString = String(localized: "UNKNOWN")
                if partner != nil {
                    partnerString = entry.widgetData!.partner!.name
                }
            }
            
            redactionReason = redactionReasons
        } else {
            moodString = LocalizedStringKey("NO_MOOD")
            placeString = LocalizedStringKey("NO_PLACE")
            safetyString = LocalizedStringKey("SAFE")
            contraceptiveString = LocalizedStringKey("NO_CONTRACEPTIVE")
            partnerContraceptiveString = LocalizedStringKey("NO_CONTRACEPTIVE")
            dateFormatter.dateStyle = .medium
            dateString = dateFormatter.string(from: Date())
            dateFormatter.dateFormat = "EEEE"
            weekdayString = dateFormatter.string(from: Date())
            dateFormatter.dateFormat = "d"
            dayString = dateFormatter.string(from: Date())
            safetyColor = .primary
            partnerString = String(localized: "UNKNOWN")
            redactionReason = [.placeholder]
        }
        
        
        return VStack {
            HStack(alignment: .top, spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    Text(weekdayString)
                        .font(.caption2)
                        .fontDesign(.rounded)
                        .fontWeight(.semibold)
                        .textCase(.uppercase)
                        .foregroundColor(.red)
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .redacted(reason: redactionReason)
                    Text(dayString)
                        .font(.largeTitle)
                        .fontWeight(.light)
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .redacted(reason: redactionReason)
                    Spacer()
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 0) {
                    if entry.configuration.type.rawValue != 2 && !privacyMode {
                        Text(partnerString).font(.headline)
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .privacySensitive()
                            .redacted(reason: redactionReason)
                    }

                    if (widgetFamily != .systemSmall && activity != nil && activity!.mood != nil) {
                        Text(moodString)
                            .font(.caption2)
                            .fontDesign(.rounded)
                            .fontWeight(.semibold)
                            .textCase(.uppercase)
                            .foregroundColor(.pink)
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .redacted(reason: redactionReason)
                    }
                    
                }
            }
            Spacer()
            HStack(spacing: 4) {
                if widgetFamily != .systemSmall && activity != nil && activity!.place != nil {
                    Text(placeString)
                        .font(.caption)
                        .fontDesign(.rounded)
                        .fontWeight(.semibold)
                        .textCase(.uppercase)
                        .foregroundColor(.purple)
                        .redacted(reason: redactionReason)
                }
                Text(dateString)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .font(.caption)
                    .fontDesign(.rounded)
                    .textCase(.uppercase)
                    .foregroundColor(.gray)
                    .redacted(reason: redactionReason)
                Spacer()
            }
            HStack(alignment: .bottom, spacing: 0) {
                if widgetFamily == .systemSmall {
                    Text(safetyString)
                        .font(.headline)
                        .foregroundColor(safetyColor)
                        .redacted(reason: redactionReason)
                } else {
                    Text(safetyString)
                        .font(.title)
                        .foregroundColor(safetyColor)
                        .redacted(reason: redactionReason)
                    
                }
                Spacer()
            }
            if entry.configuration.type.rawValue != 2 && widgetFamily == .systemMedium {
                if activity!.birthControl != nil || activity!.partnerBirthControl != nil {
                    HStack(alignment: .top) {
                        if activity!.birthControl != nil {
                            Text(contraceptiveString)
                                .lineLimit(1)
                                .truncationMode(.tail)
                                .font(.caption)
                                .fontDesign(.rounded)
                                .fontWeight(.semibold)
                                .textCase(.uppercase)
                                .foregroundColor(.cyan)
                                .redacted(reason: redactionReason)
                        }
                        if activity!.partnerBirthControl != nil && activity!.partnerBirthControl != activity!.birthControl {
                            Text(partnerContraceptiveString)
                                .lineLimit(1)
                                .truncationMode(.tail)
                                .font(.caption)
                                .fontDesign(.rounded)
                                .fontWeight(.semibold)
                                .textCase(.uppercase)
                                .foregroundColor(.cyan)
                                .redacted(reason: redactionReason)
                        }
                        Spacer()
                    }
                }
           }
        }
        .containerBackground(for: .widget) {
            Color(UIColor.systemBackground)
        }
        .privacySensitive()
    }
    
    private var InlineView: some View {
        let activity: Activity?
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        let dateString: String
        let safety: String
        let safetyIcon: String
        var redactionReason: RedactionReasons = []
        
        if entry.widgetData != nil {
            if entry.configuration.type.rawValue == 2 {
                activity = entry.widgetData!.soloActivity
            } else {
                activity = entry.widgetData!.sexualActivity
            }
            safety = entry.widgetData!.safety
        } else {
            activity = nil
            safety = "SAFE"
        }

        if (activity != nil) {
            dateString = dateFormatter.string(from: activity!.date)
            if entry.configuration.type.rawValue != 2 {
                if safety == "SAFE" {
                    safetyIcon = "checkmark.shield"
                } else if safety == "UNSAFE" {
                    safetyIcon = "shield.slash"
                } else {
                    safetyIcon = "exclamationmark.shield"
                }
            } else {
                safetyIcon = "hand.raised"
            }
        } else {
            dateString = dateFormatter.string(from: Date())
            safetyIcon = "shield"
            redactionReason.insert(.placeholder)
        }

        return (Text(Image(systemName: safetyIcon)) + Text(" ") + Text(dateString))
            .privacySensitive()
            .redacted(reason: redactionReason)
    }
    
    private var RectangularView: some View {
        let activity: Activity?
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        let dateString: String
        let safety: String
        let safetyString: LocalizedStringKey
        let safetyIcon: String
        let contraceptiveString: LocalizedStringKey
        let partnerContraceptiveString: LocalizedStringKey
        var redactionReason: RedactionReasons = []
        
        if entry.widgetData != nil {
            if entry.configuration.type.rawValue == 2 {
                activity = entry.widgetData!.soloActivity
            } else {
                activity = entry.widgetData!.sexualActivity
            }
            safety = entry.widgetData!.safety
        } else {
            activity = nil
            safety = "SAFE"
        }
        
        if (activity != nil) {
            dateString = dateFormatter.string(from: activity!.date)
            contraceptiveString = LocalizedStringKey( activity!.birthControl ?? "NO_CONTRACEPTIVE")
            partnerContraceptiveString = LocalizedStringKey( activity!.partnerBirthControl ?? "NO_CONTRACEPTIVE")
            safetyString = LocalizedStringKey(safety)
            if safety == "SAFE" {
                safetyIcon = "checkmark.shield"
            } else if safety == "UNSAFE" {
                safetyIcon = "shield.slash"
            } else {
                safetyIcon = "exclamationmark.shield"
            }
        } else {
            dateString = dateFormatter.string(from: Date())
            contraceptiveString = "CONDOM"
            partnerContraceptiveString = "NO_CONTRACEPTIVE"
            safetyString = "SAFE"
            safetyIcon = "shield"
            redactionReason.insert(.placeholder)
        }
        
        return HStack{
            VStack {
                HStack{
                    Text(dateString)
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .font(.caption)
                        .fontDesign(.rounded)
                        .textCase(.uppercase)
                        .foregroundColor(.gray)
                        .redacted(reason: redactionReason)
                    Spacer()
                }
                HStack{
                    Text(safetyString)
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .font(.headline)
                        .foregroundColor(.primary)
                        .redacted(reason: redactionReason)
                    Spacer()
                }
                if activity != nil && entry.configuration.type.rawValue == 2 {
                    if activity!.birthControl != nil || activity!.partnerBirthControl != nil {
                        HStack(alignment: .top) {
                            if activity!.birthControl != nil {
                                Text(contraceptiveString)
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                                    .font(.caption)
                                    .fontDesign(.rounded)
                                    .fontWeight(.semibold)
                                    .textCase(.uppercase)
                                    .redacted(reason: redactionReason)
                            }
                            if activity!.partnerBirthControl != nil && activity!.partnerBirthControl != activity!.birthControl{
                                Text(partnerContraceptiveString)
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                                    .font(.caption)
                                    .fontDesign(.rounded)
                                    .fontWeight(.semibold)
                                    .textCase(.uppercase)
                                    .redacted(reason: redactionReason)
                            }
                            Spacer()
                        }
                    }
                }
            }
            Spacer()
            Text("\(Image(systemName: safetyIcon))").font(.title3)
        }
        .containerBackground(for: .widget) {}
    }

    var body: some View {
        if (widgetFamily == .accessoryInline) {
            InlineView
        } else if (widgetFamily == .accessoryRectangular) {
            RectangularView
        } else {
            WidgetView
        }
    }
}

struct LastActivity: Widget {
    let kind: String = "LastActivity"
    let displayName: LocalizedStringKey = "lastActivity.displayName"
    let description: LocalizedStringKey = "lastActivity.description"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: LastActivityConfigurationIntent.self, provider: Provider()) { entry in
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
        watchedPorn: false
    )
    
    static var widgetData = ActivityWidgetData(
        soloActivity: lastSexualActivity,
        sexualActivity: lastSexualActivity,
        partner: partner,
        safety: "SAFE",
        moodEmoji: "🥵",
        privacyMode: true
    )
    
    static var previews: some View {
        LastActivityEntryView(entry: SimpleEntry(date: Date(), widgetData: widgetData, configuration: LastActivityConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
