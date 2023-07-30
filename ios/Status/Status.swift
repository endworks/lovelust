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
    
    struct ActivityType: View {
        private var text: String
        
        init(safety: String) {
            if (safety == "SAFE") {
                text = "Protected sex"
            } else if (safety == "UNSAFE") {
                text = "Very unsafe sex"
            } else {
                text = "Partially unsafe sex"
            }
        }
        var body: some View {
            Text(text).font(.headline)
        }
    }
    
    struct CircleBigIcon: View {
        var systemName: String
        var circleColor: Color
        
        var body: some View {
            ZStack(alignment: .center) {
                Circle()
                    .fill(circleColor)
                    .frame(width: 28, height:28)
                Image(systemName: systemName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 16, height: 16)
                    .foregroundColor(.white)
            }
        }
    }
    
    struct Rating: View {
        var rating: Int
        private var color: Color
        
        init(rating: Int) {
            self.rating = rating
            if (rating <= 2) {
                color = .red
            } else if (rating <= 3) {
                color = .orange
            } else {
                color = .yellow
            }
        }
        
        var body: some View {
            let starIcon = "star"
            HStack(spacing: 2) {
                Image(systemName: rating < 1 ? starIcon : "\(starIcon).fill")
                    .resizable()
                    .foregroundColor(rating < 1 ? .gray : color)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 16, height: 16)
                Image(systemName: rating < 2 ? starIcon : "\(starIcon).fill")
                    .resizable()
                    .foregroundColor(rating < 2 ? .gray : color)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 16, height: 16)
                Image(systemName: rating < 3 ? starIcon : "\(starIcon).fill")
                    .resizable()
                    .foregroundColor(rating < 3 ? .gray : color)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 16, height: 16)
                Image(systemName: rating < 4 ? starIcon : "\(starIcon).fill")
                    .resizable()
                    .foregroundColor(rating < 4 ? .gray : color)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 16, height: 16)
                Image(systemName: rating < 5 ? starIcon : "\(starIcon).fill")
                    .resizable()
                    .foregroundColor(rating < 5 ? .gray : color)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 16, height: 16)
            }
        }
    }
    
    struct PartnerInfo: View {
        private var name: String
        private var systemName: String
        private var circleColor: Color
        
        init(partner: Partner?) {
            if (partner != nil) {
                name = partner!.name
                systemName = partner!.sex == "F" ? "person" : "person"
                circleColor = partner!.gender == "F" ? Color.red : Color.blue
            } else {
                name = "Unknown"
                systemName = "person"
                circleColor = Color.gray
            }
        }
        var body: some View {
            HStack {
                CircleBigIcon(systemName: systemName, circleColor: circleColor)
                Text(name).font(.body)
                Spacer()
            }
        }
    }
    
    private var SexualIntercourseView: some View {
        VStack {
            HStack {
                PartnerInfo(partner: entry.widgetData!.partner)
                Spacer()
            }
            Spacer()
            HStack {
                Text(entry.widgetData!.activity.date.formatted(.relative(presentation: .numeric)))
                    .font(.caption)
                Spacer()
            }
            HStack {
                ActivityType(safety: entry.widgetData!.safety)
                Spacer()
            }
            HStack {
                Rating(rating: entry.widgetData!.activity.rating)
                Spacer()
            }
        }
        .padding()
    }
    
    private var NoDataView: some View {
        VStack {
            HStack {
                PartnerInfo(partner: nil)
                    .redacted(reason: .placeholder)
                Spacer()
            }
            Spacer()
            HStack {
                Text("Some time ago")
                    .font(.caption)
                    .redacted(reason: .placeholder)
                Spacer()
            }
            HStack {
                ActivityType(safety: "SAFE")
                    .redacted(reason: .placeholder)
                Spacer()
            }
            HStack {
                Rating(rating: 4).redacted(reason: .placeholder)
                Spacer()
            }
        }
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
        activity: lastSexualIntercourse, partner: nil, safety: "SAFE")

    static var previews: some View {
        StatusEntryView(entry: SexualIntercourseEntry(date: Date(), widgetData: widgetData))
                    .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
