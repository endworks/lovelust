import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_health_connect/flutter_health_connect.dart';
import 'package:health_kit_reporter/health_kit_reporter.dart' as HKR;
import 'package:health_kit_reporter/model/payload/category.dart' as HKRCategory;
import 'package:health_kit_reporter/model/payload/source.dart';
import 'package:health_kit_reporter/model/payload/source_revision.dart';
import 'package:health_kit_reporter/model/predicate.dart';
import 'package:health_kit_reporter/model/type/category_type.dart';
import 'package:lovelust/models/activity.dart';
import 'package:lovelust/models/enum.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/shared_service.dart';
import 'package:uuid/uuid.dart';

class HealthService {
  final SharedService _shared = getIt<SharedService>();
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
          [HealthConnectDataType.SexualActivity],
          readOnlyTypes: null,
        );
      } else if (Platform.isIOS) {
        return await HKR.HealthKitReporter.isAuthorizedToWrite(
          CategoryType.sexualActivity.identifier,
        ).then((result) {
          return result;
        });
      }
    }
    return Future.value(false);
  }

  Future<bool> requestPermissions() async {
    if (!kIsWeb) {
      if (Platform.isAndroid) {
        return await HealthConnectFactory.requestPermissions(
          [HealthConnectDataType.SexualActivity],
          readOnlyTypes: null,
        );
      } else if (Platform.isIOS) {
        return HKR.HealthKitReporter.requestAuthorization(
          [CategoryType.sexualActivity.identifier],
          [CategoryType.sexualActivity.identifier],
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
          requests.add(
            HealthConnectFactory.getRecords(
              type: HealthConnectDataType.SexualActivity,
              startTime: startTime,
              endTime: endTime,
            ).then((value) {
              for (SexualActivityRecord record in value) {
                debugPrint(
                  "${HealthConnectDataType.SexualActivity.name}: ${record.time} - ${record.protectionUsed} - ${record.metadata.id}",
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
                      watchedPorn: activity.watchedPorn,
                      ejaculation: activity.ejaculation,
                      healthRecordId: record.metadata.id,
                    );
                  }
                } else {
                  activity = Activity(
                    id: const Uuid().v4(),
                    partner: null,
                    birthControl: record.protectionUsed == Protection.protected
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
                    watchedPorn: null,
                    ejaculation: null,
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
          return await Future.wait(requests).then(
            (value) => _shared.activity = journal,
          );
        } catch (e) {
          debugPrint(e.toString());
          return Future.error(e);
        }
      } else if (Platform.isIOS) {
        Predicate predicate = Predicate(startTime, endTime);
        await HKR.HealthKitReporter.categoryQuery(
          CategoryType.sexualActivity,
          predicate,
        ).then((categories) {
          List<Activity> journal = [..._shared.activity];
          for (var record in categories) {
            bool protectionUsed = record.harmonized.metadata!['double']
                        ['dictionary']['HKSexualActivityProtectionUsed'] ==
                    1 ||
                false;
            DateTime startDate = DateTime.fromMillisecondsSinceEpoch(
              record.startTimestamp.toInt() * 1000,
            );
            DateTime endDate = DateTime.fromMillisecondsSinceEpoch(
              record.endTimestamp.toInt() * 1000,
            );

            Activity? activity;
            bool matchedRecord = false;
            bool needsSaving = false;

            for (Activity a in journal) {
              if (a.date.year == startDate.year &&
                  a.date.month == startDate.month &&
                  a.date.day == startDate.day &&
                  a.date.hour == startDate.hour &&
                  a.date.minute == startDate.minute &&
                  a.date.second == startDate.second) {
                activity = a;
                matchedRecord = true;
              }
            }

            if (activity != null) {
              debugPrint("matched record");
              if (activity.healthRecordId != record.uuid) {
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
                  watchedPorn: activity.watchedPorn,
                  ejaculation: activity.ejaculation,
                  healthRecordId: record.uuid,
                );
              }
            } else {
              activity = Activity(
                id: record.uuid,
                partner: null,
                birthControl: protectionUsed ? Contraceptive.condom : null,
                partnerBirthControl: null,
                date: startDate,
                location: null,
                notes: null,
                duration: endDate.difference(startDate).inMinutes,
                orgasms: 0,
                partnerOrgasms: 0,
                place: null,
                initiator: null,
                rating: 0,
                type: ActivityType.sexualIntercourse,
                practices: null,
                mood: null,
                watchedPorn: null,
                ejaculation: null,
                healthRecordId: record.uuid,
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
          }
          journal.sort((a, b) => a.date.isAfter(b.date) ? -1 : 1);
          _shared.activity = journal;
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
            if (activity.type == ActivityType.sexualIntercourse) {
              SexualActivityRecord record = SexualActivityRecord(
                time: activity.date,
                protectionUsed: _shared.isProtectionUsed(activity)
                    ? Protection.protected
                    : Protection.unprotected,
              );

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
                        watchedPorn: activity.watchedPorn,
                        ejaculation: activity.ejaculation,
                        healthRecordId: record.metadata.id,
                      );
                      journal[journal.indexOf(activity)] = updatedActivity;
                      journal.sort((a, b) => a.date.isAfter(b.date) ? -1 : 1);
                    },
                  ),
                );
              }
            }
          }
          if (requests.isNotEmpty) {
            return await Future.wait(requests).then(
              (value) => _shared.activity = journal,
            );
          }
        } catch (e) {
          debugPrint("$e");
          return Future.error(e);
        }
      } else if (Platform.isIOS) {
        try {
          final source = Source(
            'LoveLust',
            'works.end.LoveLust',
          );
          final operatingSystem = OperatingSystem(
            18,
            1,
            0,
          );
          final sourceRevision = SourceRevision(
            source,
            "${operatingSystem.majorVersion}.${operatingSystem.minorVersion}",
            'iPhone14,2',
            "${operatingSystem.majorVersion}.${operatingSystem.minorVersion}.${operatingSystem.patchVersion}",
            operatingSystem,
          );

          final canWrite = await HKR.HealthKitReporter.isAuthorizedToWrite(
              CategoryType.sexualActivity.identifier);
          if (canWrite) {
            final requests = <Future>[];
            List<Activity> journal = [..._shared.activity];
            for (var activity in journal) {
              if (activity.type == ActivityType.sexualIntercourse) {
                if (activity.healthRecordId == null) {
                  final endDate =
                      activity.date.add(Duration(minutes: activity.duration));
                  final harmonized = HKRCategory.CategoryHarmonized(
                    0,
                    'HKCategoryValue',
                    'Not Applicable',
                    {
                      'HKSexualActivityProtectionUsed':
                          _shared.isProtectionUsed(activity) ? 1 : 0,
                      'HKWasUserEntered': 1,
                    },
                  );
                  final sexualActivity = HKRCategory.Category(
                    Uuid().v4(),
                    CategoryType.sexualActivity.identifier,
                    activity.date.millisecondsSinceEpoch,
                    endDate.millisecondsSinceEpoch,
                    null,
                    sourceRevision,
                    harmonized,
                  );
                  debugPrint('try to save: ${sexualActivity.map}');
                  requests.add(
                      HKR.HealthKitReporter.save(sexualActivity).then((value) {
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
                      watchedPorn: activity.watchedPorn,
                      ejaculation: activity.ejaculation,
                      healthRecordId: sexualActivity.uuid,
                    );
                    journal[journal.indexOf(activity)] = updatedActivity;
                    journal.sort((a, b) => a.date.isAfter(b.date) ? -1 : 1);
                  }));
                }
              }
            }
            if (requests.isNotEmpty) {
              return await Future.wait(requests).then(
                (value) => _shared.activity = journal,
              );
            }
          } else {
            debugPrint('error canWrite sexualActivity: $canWrite');
          }
        } catch (e) {
          debugPrint("$e");
        }
      }
    }
    return Future.value([]);
  }

  Future<bool> deleteSexualActivityFromHealth(Activity activity) async {
    if (!kIsWeb) {
      if (activity.type == ActivityType.sexualIntercourse) {
        final endDate = activity.date.add(Duration(minutes: activity.duration));
        if (Platform.isAndroid) {
          return HealthConnectFactory.deleteRecordsByTime(
            type: HealthConnectDataType.SexualActivity,
            startTime: activity.date,
            endTime: endDate,
          ).then(
            (value) {
              debugPrint(
                "delete ${HealthConnectDataType.SexualActivity.name}: $value",
              );
              return value;
            },
          );
        } else if (Platform.isIOS) {
          Predicate predicate = Predicate(activity.date, endTime);
          return HKR.HealthKitReporter.deleteObjects(
            CategoryType.sexualActivity.identifier,
            predicate,
          ).then((value) {
            debugPrint(
              "delete ${CategoryType.sexualActivity.identifier}: $value",
            );
            return value;
          });
        }
      }
    }
    return Future.value(false);
  }

  Future<dynamic> writeSexualActivityToHealth(Activity activity) async {
    if (!kIsWeb) {
      if (activity.type == ActivityType.sexualIntercourse) {
        if (Platform.isAndroid) {
          SexualActivityRecord record = SexualActivityRecord(
            time: activity.date,
            protectionUsed: _shared.isProtectionUsed(activity)
                ? Protection.protected
                : Protection.unprotected,
          );
          HealthConnectFactory.writeData(
            type: HealthConnectDataType.SexualActivity,
            data: [record],
          ).then(
            (value) {
              debugPrint(
                "$HealthConnectDataType.SexualActivity.name: $record",
              );
            },
          );
        }
      }
    }
  }
}
