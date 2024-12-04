import 'package:lovelust/models/activity.dart';
import 'package:lovelust/models/partner.dart';

class ActivityWidgetData {
  final Activity? soloActivity;
  final Activity? sexualActivity;
  final Partner? partner;
  final String? safety;
  final String? moodEmoji;
  final bool sensitiveMode;

  const ActivityWidgetData({
    required this.soloActivity,
    required this.sexualActivity,
    required this.partner,
    required this.safety,
    required this.moodEmoji,
    required this.sensitiveMode,
  });

  factory ActivityWidgetData.fromJson(Map<String, dynamic> json) {
    return ActivityWidgetData(
      soloActivity: json['soloActivity'],
      sexualActivity: json['sexualActivity'],
      partner: json['partner'],
      safety: json['safety'],
      moodEmoji: json['moodEmoji'],
      sensitiveMode: json['sensitiveMode'],
    );
  }

  Map<String, dynamic> toJson() => {
        'soloActivity': soloActivity,
        'sexualActivity': sexualActivity,
        'partner': partner,
        'safety': safety,
        'moodEmoji': moodEmoji,
        'sensitiveMode': sensitiveMode,
      };
}
