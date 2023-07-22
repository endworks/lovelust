import 'package:lovelust/models/enum.dart';
import 'package:lovelust/services/shared_service.dart';

class Partner {
  final String id;
  final BiologicalSex sex;
  final Gender gender;
  final String name;
  final DateTime meetingDate;
  final String? notes;

  Partner({
    required this.id,
    required this.sex,
    required this.gender,
    required this.name,
    required this.meetingDate,
    required this.notes,
  });

  factory Partner.fromJson(Map<String, dynamic> json) {
    return Partner(
      id: json['id'],
      sex: SharedService.getBiologicalSexByValue(json['sex']),
      gender: SharedService.getGenderByValue(json['gender']),
      name: json['name'],
      meetingDate: DateTime.parse(json['meeting_date']),
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'sex': SharedService.setValueByBiologicalSex(sex),
        'gender': SharedService.setValueByGender(gender),
        'name': name,
        'meeting_date': meetingDate.toIso8601String(),
        'notes': notes,
      };

  @override
  String toString() {
    return "{[$id] $name}";
  }
}
