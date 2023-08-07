import 'package:lovelust/models/activity.dart';

enum StatisticType {
  lastRelationship,
  lastMasturbation,
  daysWithoutSex,
  daysWithoutMasturbation,
  mostPopularPartner,
  mostPopularPractices,
  mostPopularContraception,
  mostPopularMood,
  safetyPercent,
  orgasmRatio,
  totalSexByGender,
}

class DynamicStatisticData {
  DynamicStatisticData({required this.type, required this.date, this.data});

  StatisticType type;
  DateTime date;
  dynamic data;
}

class StatisticData {
  StatisticData(this.type, this.date);

  StatisticType type;
  DateTime date;
}

class LastRelationshipData extends StatisticData {
  LastRelationshipData(StatisticType type, DateTime date, this.activity)
      : super(type, date);

  Activity activity;
}
