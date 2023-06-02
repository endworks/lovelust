import 'package:lovelust/models/id_name.dart';

class Activity {
  final String id;
  final String? partner;
  final String? birthControl;
  final String? partnerBirthControl;
  final DateTime date;
  final String? location;
  final String? notes;
  final int duration;
  final int orgasms;
  final int partnerOrgasms;
  final String? place;
  final String? initiator;
  final int rating;
  final String? type;
  final List<IdName>? practices;
  final String? safety;
  final int encounters;

  const Activity({
    required this.id,
    required this.partner,
    required this.birthControl,
    required this.partnerBirthControl,
    required this.date,
    required this.location,
    required this.notes,
    required this.duration,
    required this.orgasms,
    required this.partnerOrgasms,
    required this.place,
    required this.initiator,
    required this.rating,
    required this.type,
    required this.practices,
    required this.safety,
    required this.encounters,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'],
      partner: json['partner'],
      birthControl: json['birth_control'],
      partnerBirthControl: json['partner_birth_control'],
      date: DateTime.parse(json['date']),
      location: json['location'],
      notes: json['notes'],
      duration: json['duration'],
      orgasms: json['orgasms'],
      partnerOrgasms: json['partner_orgasms'],
      place: json['place'],
      initiator: json['initiator'],
      rating: json['rating'],
      type: json['type'],
      practices: json['practices'] == null
          ? null
          : json['practices']
              .map<IdName>((map) => IdName.fromJson(map))
              .toList() as List<IdName>,
      safety: json['safety'],
      encounters: json['encounters'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'partner': partner,
        'birth_control': birthControl,
        'partner_birth_control': partnerBirthControl,
        'date': date.toIso8601String(),
        'location': location,
        'notes': notes,
        'duration': duration,
        'orgasms': orgasms,
        'partner_orgasms': partnerOrgasms,
        'place': place,
        'initiator': initiator,
        'rating': rating,
        'type': type,
        'practices': practices?.map((e) => e.toJson()).toList(),
        'safety': safety,
        'encounters': encounters,
      };
}
