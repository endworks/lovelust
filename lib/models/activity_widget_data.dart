import 'package:lovelust/models/activity.dart';
import 'package:lovelust/models/partner.dart';

class ActivityWidgetData {
  final Activity? activity;
  final Partner? partner;
  final String? safety;
  final String partnerString;
  final String safetyString;
  final String dateString;
  final String dayString;
  final String weekdayString;
  final String placeString;
  final String contraceptiveString;
  final String partnerContraceptiveString;
  final String moodString;
  final String moodEmoji;
  final List<String> feelingsStrings;

  const ActivityWidgetData({
    required this.activity,
    required this.partner,
    required this.safety,
    required this.partnerString,
    required this.safetyString,
    required this.dateString,
    required this.dayString,
    required this.weekdayString,
    required this.placeString,
    required this.contraceptiveString,
    required this.partnerContraceptiveString,
    required this.moodString,
    required this.moodEmoji,
    required this.feelingsStrings,
  });

  factory ActivityWidgetData.fromJson(Map<String, dynamic> json) {
    return ActivityWidgetData(
      activity: json['activity'],
      partner: json['partner'],
      safety: json['safety'],
      partnerString: json['partnerString'],
      safetyString: json['safetyString'],
      dateString: json['dateString'],
      dayString: json['dayString'],
      weekdayString: json['weekdayString'],
      placeString: json['placeString'],
      contraceptiveString: json['contraceptiveString'],
      partnerContraceptiveString: json['partnerContraceptiveString'],
      moodString: json['moodString'],
      moodEmoji: json['moodEmoji'],
      feelingsStrings: json['feelingsStrings'],
    );
  }

  Map<String, dynamic> toJson() => {
        'activity': activity,
        'partner': partner,
        'safety': safety,
        'partnerString': partnerString,
        'safetyString': safetyString,
        'dateString': dateString,
        'dayString': dayString,
        'weekdayString': weekdayString,
        'placeString': placeString,
        'contraceptiveString': contraceptiveString,
        'partnerContraceptiveString': partnerContraceptiveString,
        'moodString': moodString,
        'moodEmoji': moodEmoji,
        'feelingsStrings': feelingsStrings,
      };
}
