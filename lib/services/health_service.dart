import 'dart:convert';
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

  int get daysToRead {
    return 365 * 10;
  }

  DateTime get endTime {
    return DateTime.now();
  }

  DateTime get startTime {
    return endTime.subtract(Duration(days: daysToRead));
  }

  Source get source {
    return Source(
      'LoveLust',
      'works.end.LoveLust',
    );
  }

  OperatingSystem get operatingSystem {
    return OperatingSystem(
      18,
      1,
      0,
    );
  }

  SourceRevision get sourceRevision {
    return SourceRevision(
      source,
      "${operatingSystem.majorVersion}.${operatingSystem.minorVersion}",
      'iPhone14,2',
      "${operatingSystem.majorVersion}.${operatingSystem.minorVersion}.${operatingSystem.patchVersion}",
      operatingSystem,
    );
  }

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

  Future<bool> get hasPermissions async {
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

  Future<List<dynamic>> importSexualActivity() async {
    debugPrint('importSexualActivity');
    /*if (!kIsWeb) {
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
              if (activity.id != record.harmonized.metadata.) {
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
    }*/
    return Future.value([]);
  }

  Future<List<dynamic>> exportSexualActivity() async {
    debugPrint('exportSexualActivity');
    if (!kIsWeb) {
      try {
        Iterable<Future<bool>> requests = _shared.activity
            .where(
                (activity) => activity.type == ActivityType.sexualIntercourse)
            .map(
              (activity) => writeSexualActivity(activity),
            );
        if (requests.isNotEmpty) {
          await Future.wait(requests);
        }
      } catch (e) {
        debugPrint("$e");
        return Future.error(e);
      }
    }
    return Future.value([]);
  }

  Future<bool> deleteSexualActivity(Activity activity) async {
    debugPrint(
      "deleteSexualActivity: ${jsonEncode(activity)}",
    );
    if (!kIsWeb) {
      if (activity.type == ActivityType.sexualIntercourse) {
        final endDate = activity.date.add(
          Duration(minutes: activity.duration > 0 ? activity.duration : 1),
        );
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

  Future<bool> writeSexualActivity(Activity activity) async {
    debugPrint(
      "writeSexualActivity: ${jsonEncode(activity)}",
    );
    if (!kIsWeb) {
      ActivitySafety safety = _shared.calculateSafety(activity);
      if (activity.type == ActivityType.sexualIntercourse) {
        if (Platform.isAndroid) {
          Protection protectionUsed = Protection.unknown;
          if (safety == ActivitySafety.safe) {
            protectionUsed = Protection.protected;
          } else if (safety == ActivitySafety.unsafe) {
            protectionUsed = Protection.unprotected;
          }
          Metadata metadata = Metadata(
            clientRecordId: activity.id!,
            recordingMethod: RecordingMethod.manualEntry,
          );
          SexualActivityRecord sexualActivity = SexualActivityRecord(
            time: activity.date,
            protectionUsed: protectionUsed,
            metadata: metadata,
          );
          return HealthConnectFactory.writeData(
            type: HealthConnectDataType.SexualActivity,
            data: [sexualActivity],
          ).then(
            (value) {
              debugPrint(
                "${HealthConnectDataType.SexualActivity.name}: ${sexualActivity.toMap().toString()}",
              );
              return value;
            },
          );
        } else if (Platform.isIOS) {
          try {
            final canWrite = await HKR.HealthKitReporter.isAuthorizedToWrite(
                CategoryType.sexualActivity.identifier);
            if (canWrite) {
              if (activity.type == ActivityType.sexualIntercourse) {
                final endDate =
                    activity.date.add(Duration(minutes: activity.duration));
                Map<String, dynamic> metadata = {
                  'HKMetadataKeyExternalUUID': activity.id!,
                  'HKWasUserEntered': 1,
                  'Contraceptive': activity.birthControl,
                  'PartnerContraceptive': activity.partnerBirthControl,
                  'Partner': activity.partner,
                };
                if (safety == ActivitySafety.safe) {
                  metadata.update(
                      'HKSexualActivityProtectionUsed', (value) => value = 1);
                } else if (safety == ActivitySafety.unsafe) {
                  metadata.update(
                      'HKSexualActivityProtectionUsed', (value) => value = 0);
                }
                final harmonized = HKRCategory.CategoryHarmonized(
                  0,
                  'HKCategoryValue',
                  'Not Applicable',
                  metadata,
                );
                final sexualActivity = HKRCategory.Category(
                  activity.id!,
                  CategoryType.sexualActivity.identifier,
                  activity.date.millisecondsSinceEpoch,
                  endDate.millisecondsSinceEpoch,
                  null,
                  sourceRevision,
                  harmonized,
                );
                debugPrint('try to save: ${sexualActivity.map}');
                return HKR.HealthKitReporter.save(sexualActivity).then((value) {
                  debugPrint(
                    "${HealthConnectDataType.SexualActivity.name}: ${jsonEncode(sexualActivity.map)}",
                  );
                  return value;
                });
              }
            } else {
              debugPrint('error canWrite sexualActivity: $canWrite');
            }
          } catch (e) {
            debugPrint("$e");
          }
        }
      }
    }
    return Future.value(false);
  }

  Future<bool> updateSexualActivity(Activity activity) async {
    await deleteSexualActivity(activity);
    return writeSexualActivity(activity);
  }
}
