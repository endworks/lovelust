import 'package:lovelust/models/enum.dart';
import 'package:lovelust/services/shared_service.dart';

class Partner {
  final String? id;
  final BiologicalSex sex;
  final Gender gender;
  final String name;
  final DateTime meetingDate;
  final DateTime? birthDay;
  final String? notes;
  final String? phone;
  final String? instagram;
  final String? x;
  final String? snapchat;
  final String? onlyfans;

  Partner({
    required this.id,
    required this.sex,
    required this.gender,
    required this.name,
    required this.meetingDate,
    required this.birthDay,
    required this.notes,
    required this.phone,
    required this.instagram,
    required this.x,
    required this.snapchat,
    required this.onlyfans,
  });

  factory Partner.fromJson(Map<String, dynamic> json) {
    return Partner(
      id: json['id'],
      sex: SharedService.getBiologicalSexByValue(json['sex']),
      gender: SharedService.getGenderByValue(json['gender']),
      name: json['name'],
      meetingDate: DateTime.parse(json['meeting_date']),
      birthDay: DateTime.parse(json['birth_day']),
      notes: SharedService.emptyStringToNull(json['notes']),
      phone: SharedService.emptyStringToNull(json['phone']),
      instagram: SharedService.emptyStringToNull(json['instagram']),
      x: SharedService.emptyStringToNull(json['x']),
      snapchat: SharedService.emptyStringToNull(json['snapchat']),
      onlyfans: SharedService.emptyStringToNull(json['onlyfans']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'sex': SharedService.setValueByBiologicalSex(sex),
        'gender': SharedService.setValueByGender(gender),
        'name': name.toString(),
        'meeting_date': meetingDate.toIso8601String(),
        'birth_day': birthDay?.toIso8601String(),
        'notes': notes ?? '',
        'phone': phone ?? '',
        'instagram': instagram ?? '',
        'x': x ?? '',
        'snapchat': snapchat ?? '',
        'onlyfans': onlyfans ?? '',
      };

  @override
  String toString() {
    return "{[$id] $name}";
  }
}
