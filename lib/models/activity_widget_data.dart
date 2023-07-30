import 'package:lovelust/models/activity.dart';
import 'package:lovelust/models/partner.dart';

class ActivityWidgetData {
  final Activity? activity;
  final Partner? partner;
  final String? safety;

  const ActivityWidgetData({
    required this.activity,
    required this.partner,
    required this.safety,
  });

  factory ActivityWidgetData.fromJson(Map<String, dynamic> json) {
    return ActivityWidgetData(
      activity: json['activity'],
      partner: json['partner'],
      safety: json['safety'],
    );
  }

  Map<String, dynamic> toJson() => {
        'activity': activity,
        'partner': partner,
        'safety': safety,
      };
}
