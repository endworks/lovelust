import 'package:lovelust/models/activity.dart';
import 'package:lovelust/models/partner.dart';

class Stats {
  final DateTime date;
  final Activity? lastSexualActivity;
  final int daysSinceLastSexualActivity;
  final Activity? lastMasturbation;
  final int daysSinceLastMasturbation;
  final int daysSinceLastSexualStimulation;
  final int totalSexualActivity;
  final int totalSexualActivityWithMale;
  final int totalSexualActivityWithFemale;
  final int totalSexualActivityWithUnknown;
  final int totalMasturbation;
  final StatsCountPartner? mostPopularPartner;
  final StatsCount? mostPopularPractice;
  final StatsCount? mostPopularMood;
  final StatsCount? mostPopularEjaculationPlace;
  final StatsCount? mostPopularPlace;
  final num safetyPercentSafe;
  final num safetyPercentUnsafe;
  final num safetyPercentPartlyUnsafe;
  final StatsCount? mostActiveYear;
  final StatsCount? mostActiveMonth;
  final StatsCount? mostActiveDay;
  final StatsCount? mostActiveWeekday;
  final StatsCount? mostActiveHour;
  final num orgasmRatio;
  final num averageDuration;
  final Map<String, StatsCountTimeData> weeklyStats;
  final Map<String, StatsCountTimeData> monthlyStats;
  final Map<String, StatsCountTimeData> yearlyStats;
  final Map<String, StatsCountTimeData> globalStats;
  final Map<String, StatsCount> timeDistributionStats;

  const Stats({
    required this.date,
    required this.lastSexualActivity,
    required this.daysSinceLastSexualActivity,
    required this.lastMasturbation,
    required this.daysSinceLastMasturbation,
    required this.daysSinceLastSexualStimulation,
    required this.totalSexualActivity,
    required this.totalSexualActivityWithMale,
    required this.totalSexualActivityWithFemale,
    required this.totalSexualActivityWithUnknown,
    required this.totalMasturbation,
    required this.mostPopularPartner,
    required this.mostPopularPractice,
    required this.mostPopularMood,
    required this.mostPopularEjaculationPlace,
    required this.mostPopularPlace,
    required this.safetyPercentSafe,
    required this.safetyPercentUnsafe,
    required this.safetyPercentPartlyUnsafe,
    required this.mostActiveYear,
    required this.mostActiveMonth,
    required this.mostActiveDay,
    required this.mostActiveWeekday,
    required this.mostActiveHour,
    required this.orgasmRatio,
    required this.averageDuration,
    required this.weeklyStats,
    required this.globalStats,
    required this.monthlyStats,
    required this.yearlyStats,
    required this.timeDistributionStats,
  });

  factory Stats.fromJson(Map<String, dynamic> json) {
    return Stats(
      date: DateTime.parse(json['date']).toLocal(),
      lastSexualActivity: json['lastSexualActivity'] != null
          ? Activity.fromJson(json['lastSexualActivity'])
          : null,
      daysSinceLastSexualActivity: json['daysSinceLastSexualActivity'],
      lastMasturbation: json['lastMasturbation'] != null
          ? Activity.fromJson(json['lastMasturbation'])
          : null,
      daysSinceLastMasturbation: json['daysSinceLastMasturbation'],
      daysSinceLastSexualStimulation: json['daysSinceLastSexualStimulation'],
      totalSexualActivity: json['totalSexualActivity'],
      totalSexualActivityWithMale: json['totalSexualActivityWithMale'],
      totalSexualActivityWithFemale: json['totalSexualActivityWithFemale'],
      totalSexualActivityWithUnknown: json['totalSexualActivityWithUnknown'],
      totalMasturbation: json['totalMasturbation'],
      mostPopularPartner: json['mostPopularPartner'] != null
          ? StatsCountPartner.fromJson(json['mostPopularPartner'])
          : null,
      mostPopularPractice: json['mostPopularPractice'] != null
          ? StatsCount.fromJson(json['mostPopularPractice'])
          : null,
      mostPopularMood: json['mostPopularMood'] != null
          ? StatsCount.fromJson(json['mostPopularMood'])
          : null,
      mostPopularEjaculationPlace: json['mostPopularEjaculationPlace'] != null
          ? StatsCount.fromJson(json['mostPopularEjaculationPlace'])
          : null,
      mostPopularPlace: json['mostPopularPlace'] != null
          ? StatsCount.fromJson(json['mostPopularPlace'])
          : null,
      safetyPercentSafe: json['safetyPercentSafe'],
      safetyPercentUnsafe: json['safetyPercentUnsafe'],
      safetyPercentPartlyUnsafe: json['safetyPercentPartlyUnsafe'],
      mostActiveYear: json['mostActiveYear'] != null
          ? StatsCount.fromJson(json['mostActiveYear'])
          : null,
      mostActiveMonth: json['mostActiveMonth'] != null
          ? StatsCount.fromJson(json['mostActiveMonth'])
          : null,
      mostActiveDay: json['mostActiveDay'] != null
          ? StatsCount.fromJson(json['mostActiveDay'])
          : null,
      mostActiveWeekday: json['mostActiveWeekday'] != null
          ? StatsCount.fromJson(json['mostActiveWeekday'])
          : null,
      mostActiveHour: json['mostActiveHour'] != null
          ? StatsCount.fromJson(json['mostActiveHour'])
          : null,
      orgasmRatio: json['orgasmRatio'],
      averageDuration: json['averageDuration'],
      weeklyStats: json['weeklyStats'],
      monthlyStats: json['monthlyStats'],
      yearlyStats: json['yearlyStats'],
      globalStats: json['globalStats'],
      timeDistributionStats: json['timeDistributionStats'],
    );
  }

  Map<String, dynamic> toJson() => {
        'date': date.toUtc().toIso8601String(),
        'lastSexualActivity': lastSexualActivity?.toJson(),
        'daysSinceLastSexualActivity': daysSinceLastSexualActivity,
        'lastMasturbation': lastMasturbation?.toJson(),
        'daysSinceLastMasturbation': daysSinceLastMasturbation,
        'daysSinceLastSexualStimulation': daysSinceLastSexualStimulation,
        'totalSexualActivity': totalSexualActivity,
        'totalSexualActivityWithMale': totalSexualActivityWithMale,
        'totalSexualActivityWithFemale': totalSexualActivityWithFemale,
        'totalSexualActivityWithUnknown': totalSexualActivityWithUnknown,
        'totalMasturbation': totalMasturbation,
        'mostPopularPartner': mostPopularPartner?.toJson(),
        'mostPopularPractice': mostPopularPractice?.toJson(),
        'mostPopularMood': mostPopularMood?.toJson(),
        'mostPopularEjaculationPlace': mostPopularEjaculationPlace?.toJson(),
        'mostPopularPlace': mostPopularPlace?.toJson(),
        'safetyPercentSafe': safetyPercentSafe,
        'safetyPercentUnsafe': safetyPercentUnsafe,
        'safetyPercentPartlyUnsafe': safetyPercentPartlyUnsafe,
        'mostActiveYear': mostActiveYear?.toJson(),
        'mostActiveMonth': mostActiveMonth?.toJson(),
        'mostActiveDay': mostActiveDay?.toJson(),
        'mostActiveWeekday': mostActiveWeekday?.toJson(),
        'mostActiveHour': mostActiveHour?.toJson(),
        'orgasmRatio': orgasmRatio,
        'averageDuration': averageDuration,
        'weeklyStats': weeklyStats,
        'monthlyStats': monthlyStats,
        'yearlyStats': yearlyStats,
        'globalStats': globalStats,
        'timeDistributionStats': timeDistributionStats,
      };
}

class StatsCount {
  final String id;
  final num count;

  const StatsCount({
    required this.id,
    required this.count,
  });

  factory StatsCount.fromJson(Map<String, dynamic> json) {
    return StatsCount(
      id: json['id'],
      count: json['count'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'count': count,
      };
}

class StatsCountPartner {
  final Partner partner;
  final num count;

  const StatsCountPartner({
    required this.partner,
    required this.count,
  });

  factory StatsCountPartner.fromJson(Map<String, dynamic> json) {
    return StatsCountPartner(
      partner: json['partner'],
      count: json['count'],
    );
  }

  Map<String, dynamic> toJson() => {
        'partner': partner,
        'count': count,
      };
}

class StatsCountTimeData {
  final String id;
  final num count;
  final num male;
  final num female;
  final num unknown;
  final num masturbation;

  const StatsCountTimeData({
    required this.id,
    required this.count,
    required this.male,
    required this.female,
    required this.unknown,
    required this.masturbation,
  });

  factory StatsCountTimeData.fromJson(Map<String, dynamic> json) {
    return StatsCountTimeData(
      id: json['id'],
      count: json['count'],
      male: json['male'],
      female: json['female'],
      unknown: json['unknown'],
      masturbation: json['masturbation'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'count': count,
        'male': male,
        'female': female,
        'unknown': unknown,
        'masturbation': masturbation,
      };
}
