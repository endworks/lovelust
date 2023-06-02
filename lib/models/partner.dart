import 'package:flutter/material.dart';
import 'package:lovelust/models/activity.dart';

class Partner {
  final String id;
  final String sex;
  final String gender;
  final String name;
  final DateTime meetingDate;
  final String? notes;
  final List<Activity>? activity;

  Partner({
    required this.id,
    required this.sex,
    required this.gender,
    required this.name,
    required this.meetingDate,
    required this.notes,
    required this.activity,
  });

  factory Partner.fromJson(Map<String, dynamic> json) {
    debugPrint(json.keys.toString());
    return Partner(
      id: json['id'],
      sex: json['sex'],
      gender: json['gender'],
      name: json['name'],
      meetingDate: DateTime.parse(json['meeting_date']),
      notes: json['notes'],
      activity: json['activity'] == null
          ? null
          : json['activity']
              .map<Activity>((map) => Activity.fromJson(map))
              .toList() as List<Activity>,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'sex': sex,
        'gender': gender,
        'name': name,
        'meeting_date': meetingDate.toIso8601String(),
        'notes': notes,
        'activity': activity?.map((e) => e.toJson()).toList(),
      };
}
