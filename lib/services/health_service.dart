import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_health_connect/flutter_health_connect.dart';
import 'package:health_kit_reporter/health_kit_reporter.dart';
import 'package:health_kit_reporter/model/predicate.dart';
import 'package:health_kit_reporter/model/type/category_type.dart';
import 'package:lovelust/models/activity.dart';
import 'package:lovelust/models/enum.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/shared_service.dart';
import 'package:uuid/uuid.dart';

class HealthService {
  final SharedService _shared = getIt<SharedService>();
  final List<HealthConnectDataType> healthConnectTypes = [
    HealthConnectDataType.SexualActivity,
  ];
  final healthKitTypes = <String>[CategoryType.sexualActivity.identifier];
  bool readOnly = false;
  DateTime startTime = DateTime.now().subtract(const Duration(days: 365 * 10));
  DateTime endTime = DateTime.now();

  Future<bool> isApiSupported() async {
    if (!kIsWeb) {
      if (Platform.isAndroid) {
        return await HealthConnectFactory.isApiSupported();
      } else if (Platform.isIOS) {
        return Future.value(true);
      }
    }
    return Future.value(false);
  }

  Future<bool> isAvailable() async {
    if (!kIsWeb) {
      if (Platform.isAndroid) {
        return await HealthConnectFactory.isAvailable();
      } else if (Platform.isIOS) {
        return Future.value(true);
      }
    }
    return Future.value(false);
  }

  Future<void> installHealthApp() async {
    if (!kIsWeb) {
      if (Platform.isAndroid) {
        await HealthConnectFactory.installHealthConnect();
      }
    }
  }

  Future<void> openHealthApp() async {
    if (!kIsWeb) {
      if (Platform.isAndroid) {
        await HealthConnectFactory.openHealthConnectSettings();
      }
    }
  }

  Future<bool> hasPermissions() async {
    if (!kIsWeb) {
      if (Platform.isAndroid) {
        return await HealthConnectFactory.hasPermissions(
          healthConnectTypes,
          readOnlyTypes: readOnly ? healthConnectTypes : null,
        );
      } else if (Platform.isIOS) {
        final requests = <Future>[];
        for (var type in healthKitTypes) {
          requests.add(
            HealthKitReporter.isAuthorizedToWrite(type),
          );
        }
        return await Future.wait(requests).then((results) {
          for (var result in results) {
            if (!result) {
              return false;
            }
          }
          return true;
        });
      }
    }
    return Future.value(false);
  }

  Future<bool> requestPermissions() async {
    if (!kIsWeb) {
      if (Platform.isAndroid) {
        return await HealthConnectFactory.requestPermissions(
          healthConnectTypes,
          readOnlyTypes: readOnly ? healthConnectTypes : null,
        );
      } else if (Platform.isIOS) {
        return HealthKitReporter.requestAuthorization(
          healthKitTypes,
          healthKitTypes,
        );
      }
    }
    return Future.value(false);
  }

  Future<List<dynamic>> readSexualActivity() async {
    debugPrint('readSexualActivity');
    if (!kIsWeb) {
      if (Platform.isAndroid) {
        try {
          final requests = <Future>[];
          List<Activity> journal = [..._shared.activity];
          for (var type in healthConnectTypes) {
            requests.add(
              HealthConnectFactory.getRecords(
                type: type,
                startTime: startTime,
                endTime: endTime,
              ).then((value) {
                for (SexualActivityRecord record in value) {
                  debugPrint(
                    "${type.name}: ${record.time} - ${record.protectionUsed} - ${record.metadata.id}",
                  );
                  Activity? activity;
                  bool matchedRecord = false;
                  bool needsSaving = false;

                  for (Activity a in journal) {
                    if (a.date.year == record.time.year &&
                        a.date.month == record.time.month &&
                        a.date.day == record.time.day &&
                        a.date.hour == record.time.hour &&
                        a.date.minute == record.time.minute &&
                        a.date.second == record.time.second) {
                      activity = a;
                      matchedRecord = true;
                    }
                  }

                  if (activity != null) {
                    debugPrint("matched record");
                    if (activity.healthRecordId != record.metadata.id) {
                      needsSaving = true;
                      activity = Activity(
                        id: activity.id,
                        birthControl: activity.birthControl,
                        date: activity.date,
                        duration: activity.duration,
                        initiator: activity.initiator,
                        location: activity.location,
                        orgasms: activity.orgasms,
                        partner: activity.partner,
                        partnerBirthControl: activity.partnerBirthControl,
                        partnerOrgasms: activity.partnerOrgasms,
                        place: activity.place,
                        practices: activity.practices,
                        rating: activity.rating,
                        notes: activity.notes,
                        type: activity.type,
                        mood: activity.mood,
                        healthRecordId: record.metadata.id,
                      );
                    }
                  } else {
                    activity = Activity(
                      id: const Uuid().v4(),
                      partner: null,
                      birthControl:
                          record.protectionUsed == Protection.protected
                              ? Contraceptive.condom
                              : null,
                      partnerBirthControl: null,
                      date: record.time,
                      location: null,
                      notes: null,
                      duration: 0,
                      orgasms: 0,
                      partnerOrgasms: 0,
                      place: null,
                      initiator: null,
                      rating: 0,
                      type: ActivityType.sexualIntercourse,
                      practices: null,
                      mood: null,
                      healthRecordId: record.metadata.id,
                    );
                  }

                  if (matchedRecord) {
                    if (needsSaving) {
                      Activity? element =
                          journal.firstWhere((e) => e.id == activity!.id);
                      journal[journal.indexOf(element)] = activity;
                    }
                  } else {
                    journal.add(activity);
                  }
                  journal.sort((a, b) => a.date.isAfter(b.date) ? -1 : 1);
                }
              }),
            );
          }
          return await Future.wait(requests).then(
            (value) => _shared.activity = journal,
          );
        } catch (e) {
          debugPrint(e.toString());
          return Future.error(e);
        }
      } else if (Platform.isIOS) {
        Predicate predicate = Predicate(startTime, endTime);
        await HealthKitReporter.categoryQuery(
          CategoryType.sexualActivity,
          predicate,
        ).then((categories) {
          debugPrint("categories: ${categories.map((e) => e.map).toList()}");
        });
      }
    }
    return Future.value([]);
  }

  Future<List<dynamic>> writeSexualActivity() async {
    debugPrint('writeSexualActivity');
    if (!kIsWeb) {
      if (Platform.isAndroid) {
        try {
          final requests = <Future>[];
          List<Activity> journal = [..._shared.activity];
          for (var activity in journal) {
            ActivitySafety safety = _shared.calculateSafety(activity);
            SexualActivityRecord record = SexualActivityRecord(
              time: activity.date,
              protectionUsed: safety == ActivitySafety.unsafe
                  ? Protection.unprotected
                  : Protection.protected,
            );
            if (!readOnly) {
              if (activity.healthRecordId == null) {
                requests.add(
                  HealthConnectFactory.writeData(
                    type: HealthConnectDataType.SexualActivity,
                    data: [record],
                  ).then(
                    (value) {
                      debugPrint(
                        "$HealthConnectDataType.SexualActivity.name: $record",
                      );
                      Activity updatedActivity = Activity(
                        id: activity.id,
                        birthControl: activity.birthControl,
                        date: activity.date,
                        duration: activity.duration,
                        initiator: activity.initiator,
                        location: activity.location,
                        orgasms: activity.orgasms,
                        partner: activity.partner,
                        partnerBirthControl: activity.partnerBirthControl,
                        partnerOrgasms: activity.partnerOrgasms,
                        place: activity.place,
                        practices: activity.practices,
                        rating: activity.rating,
                        notes: activity.notes,
                        type: activity.type,
                        mood: activity.mood,
                        healthRecordId: record.metadata.id,
                      );
                      journal[journal.indexOf(activity)] = updatedActivity;
                      journal.sort((a, b) => a.date.isAfter(b.date) ? -1 : 1);
                    },
                  ),
                );
              }
            } else {
              debugPrint(
                "$HealthConnectDataType.SexualActivity.name: $record",
              );
            }
          }

          return await Future.wait(requests).then(
            (value) => _shared.activity = journal,
          );
        } catch (e, s) {
          debugPrint("$e:$s".toString());
          return Future.error(e);
        }
      }
    }
    return Future.value([]);
  }
}
