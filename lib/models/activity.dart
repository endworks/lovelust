import 'package:lovelust/models/enum.dart';
import 'package:lovelust/models/id_name.dart';
import 'package:lovelust/services/shared_service.dart';

class Activity {
  final String? id;
  final String? partner;
  final Contraceptive? birthControl;
  final Contraceptive? partnerBirthControl;
  final DateTime date;
  final String? location;
  final String? notes;
  final int duration;
  final int orgasms;
  final int partnerOrgasms;
  final Place? place;
  final Initiator? initiator;
  final int rating;
  final ActivityType? type;
  final List<Practice>? practices;

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
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'],
      partner: json['partner'],
      birthControl:
          SharedService.getContraceptiveByValue(json['birth_control']),
      partnerBirthControl:
          SharedService.getContraceptiveByValue(json['partner_birth_control']),
      date: DateTime.parse(json['date']),
      location: json['location'],
      notes: json['notes'],
      duration: json['duration'],
      orgasms: json['orgasms'],
      partnerOrgasms: json['partner_orgasms'],
      place: SharedService.getPlaceByValue(json['place']),
      initiator: SharedService.getInitiatorByValue(json['initiator']),
      rating: json['rating'],
      type: SharedService.getActivityTypeByValue(json['type']),
      practices: json['practices'] == null
          ? null
          : json['practices']
              .map<Practice>((map) =>
                  SharedService.getPracticeByValue(IdName.fromJson(map).id)!)
              .toList() as List<Practice>,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id ?? '',
        'partner': partner ?? '',
        'birth_control':
            SharedService.setValueByContraceptive(birthControl) ?? '',
        'partner_birth_control':
            SharedService.setValueByContraceptive(partnerBirthControl) ?? '',
        'date': date.toIso8601String(),
        'location': location ?? '',
        'notes': notes ?? '',
        'duration': duration.toString(),
        'orgasms': orgasms.toString(),
        'partner_orgasms': partnerOrgasms.toString(),
        'place': SharedService.setValueByPlace(place) ?? '',
        'initiator': SharedService.setValueByInitiator(initiator) ?? '',
        'rating': rating.toString(),
        'type': SharedService.setValueByActivityType(type) ?? '',
        'practices': practices
            ?.map(
              (e) => IdName(
                id: SharedService.setValueByPractice(e) ?? '',
                name: SharedService.setValueByPractice(e) ?? '',
              ).toJson(),
            )
            .toList()
            .toString(),
      };
}
