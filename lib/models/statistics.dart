enum StatisticType {
  lastRelationship,
  lastMasturbation,
  daysWithoutSex,
  mostPopularPartner,
  mostPopularPractices,
  mostPopularContraception,
  mostPopularMood,
  safetyPercent,
  orgasmRatio,
  totalSexByGender,
  weeklyChart,
  monthlyChart,
  yearlyChart,
  globalChart,
  overview,
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

class DaysWithoutSexData {
  DaysWithoutSexData(
    this.daysWithoutRelationship,
    this.daysWithoutMasturbation,
  );

  int daysWithoutRelationship;
  int daysWithoutMasturbation;
}

class WeeklyChartData {
  WeeklyChartData({required this.day, required this.activityCount});
  final String day;
  final double activityCount;
}
