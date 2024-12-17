import 'package:flutter/material.dart';
import 'package:lovelust/models/partner.dart';

enum StatisticType {
  simple,
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
  safetyChart,
  timeDistributionChart,
  sexDistributionChart,
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

class PartnerStatisticData {
  PartnerStatisticData(
      {required this.title, required this.partner, required this.count});

  final String title;
  final Partner partner;
  final int count;
}

class WeeklyChartData {
  WeeklyChartData({required this.day, required this.activityCount});
  final String day;
  final double activityCount;
}

class SimpleStatisticData {
  SimpleStatisticData(
      {required this.title, required this.description, this.icon, this.count});

  final String title;
  final String description;
  IconData? icon;
  int? count;
}
