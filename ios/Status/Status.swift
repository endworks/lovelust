//
//  Status.swift
//  Status
//
//  Created by ender on 29/7/23.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SexualIntercourseEntry {
        SexualIntercourseEntry(date: Date(), widgetData: nil)
    }

    func getSnapshot(in context: Context, completion: @escaping (SexualIntercourseEntry) -> ()) {
        let entry = SexualIntercourseEntry(date: Date(), widgetData: nil)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SexualIntercourseEntry] = []
        
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
            let entry = SexualIntercourseEntry(date: entryDate, widgetData: widgetData)
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

struct SexualIntercourseEntry: TimelineEntry {
    let date: Date
    let widgetData: ActivityWidgetData?
}

enum DateError: String, Error {
    case invalidDate
}

struct StatusEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var widgetFamily
    
    struct Rating: View {
        var rating: Int
        private var color: Color
        
        init(rating: Int) {
            self.rating = rating
            color = .orange
        }
        
        var body: some View {
            let starIcon = "star"
            HStack {
                Image(systemName: rating < 1 ? starIcon : "\(starIcon).fill")
                    .resizable()
                    .foregroundColor(color)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 16, height: 16)
                Image(systemName: rating < 2 ? starIcon : "\(starIcon).fill")
                    .resizable()
                    .foregroundColor(color)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 16, height: 16)
                Image(systemName: rating < 3 ? starIcon : "\(starIcon).fill")
                    .resizable()
                    .foregroundColor(color)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 16, height: 16)
                Image(systemName: rating < 4 ? starIcon : "\(starIcon).fill")
                    .resizable()
                    .foregroundColor(color)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 16, height: 16)
                Image(systemName: rating < 5 ? starIcon : "\(starIcon).fill")
                    .resizable()
                    .foregroundColor(color)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 16, height: 16)
            }
        }
    }
    
    private var SexualIntercourseView: some View {
        var partnerColor: Color
        var safetyColor: Color
        
        if entry.widgetData!.partner != nil {
            if entry.widgetData!.partner?.sex == "M" {
                partnerColor = .blue
            } else {
                partnerColor = .red
            }
        } else {
            partnerColor = .purple
        }
        

        if entry.widgetData!.safety == "UNSAFE" {
            safetyColor = .red
        } else if entry.widgetData!.safety == "SAFE" {
            safetyColor = .primary
        } else {
            safetyColor = .orange
        }

        
       return VStack {
            HStack(alignment: .top, spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    Text(entry.widgetData!.partnerString).font(.headline)
                        .foregroundColor(partnerColor)
                        .privacySensitive()
                    if (entry.widgetData!.activity.rating > 0) {
                        if widgetFamily == .systemSmall {
                            HStack(spacing: 2) {
                                Text(entry.widgetData!.activity.rating.description)
                                    .privacySensitive()
                                Image(systemName: "star.fill")
                                    .resizable()
                                    .foregroundColor(.yellow)
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 16, height: 16)
                            }
                        } else {
                            Rating(rating: entry.widgetData!.activity.rating)
                                .privacySensitive()
                        }
                    }
                    Spacer()
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 0) {
                    Text(entry.widgetData!.weekdayString)
                        .font(.caption2)
                        .fontDesign(.rounded)
                        .fontWeight(.semibold)
                        .textCase(.uppercase)
                        .foregroundColor(.red)
                    Text(entry.widgetData!.dayString)
                        .font(.largeTitle)
                        .fontWeight(.light)
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
                }
                Text(entry.widgetData!.dateString)
                    .font(.caption)
                    .fontDesign(.rounded)
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
        }
        .privacySensitive()
        .padding()
    }
    
    private var NoDataView: some View {
        VStack {
            HStack(alignment: .top, spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Barbie")
                        .font(.headline)
                        .foregroundColor(.black)
                    if widgetFamily == .systemSmall {
                        HStack(spacing: 2) {
                            Text("4")
                            Image(systemName: "star.fill")
                                .resizable()
                                .foregroundColor(.yellow)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 16, height: 16)
                        }
                    } else {
                        Rating(rating: 4)
                    }
                    Spacer()
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 0) {
                    Text("sunday")
                        .font(.caption2)
                        .fontDesign(.rounded)
                        .fontWeight(.semibold)
                        .textCase(.uppercase)
                        .foregroundColor(.red)
                    Text("30")
                        .font(.largeTitle)
                        .fontWeight(.light)
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
                }
                Text("a day ago")
                    .font(.caption)
                    .fontDesign(.rounded)
                    .foregroundColor(.gray)
                Spacer()
            }
            HStack(alignment: .bottom, spacing: 0) {
                if widgetFamily == .systemSmall {
                    Text("Safe sex")
                        .font(.headline)
                        .foregroundColor(.primary)
                } else {
                    Text("Safe sex")
                        .font(.title)
                        .foregroundColor(.primary)
                    
                }
                Spacer()
            }
        }
        .redacted(reason: .placeholder)
        .padding()
        
    }

    var body: some View {
        if(entry.widgetData != nil) {
            SexualIntercourseView
        } else {
            NoDataView
        }
    }
}

struct Status: Widget {
    let kind: String = "Status"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            StatusEntryView(entry: entry)
        }
        .configurationDisplayName("Sexual intercourse")
        .description("Shows data of last sexual intercourse")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct Status_Previews: PreviewProvider {
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
        mood: nil,
        practices: []
    )
    
    static var widgetData = ActivityWidgetData(
        activity: lastSexualIntercourse, partner: nil, safety: "PARTIALLY", partnerString: "Barbie", safetyString: "Partially unsafe sex", dateString: "a day ago", dayString: "30", weekdayString: "Sunday", placeString: "Bedroom", contraceptiveString: "Condom", partnerContraceptiveString: "Pill")

    static var previews: some View {
        StatusEntryView(entry: SexualIntercourseEntry(date: Date(), widgetData: widgetData))
                    .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
