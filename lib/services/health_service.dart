import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_health_connect/flutter_health_connect.dart';
import 'package:health_kit_reporter/health_kit_reporter.dart' as hkr;
import 'package:health_kit_reporter/model/payload/category.dart'
    as hkr_category;
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

  List<dynamic> sexualActivity = [];

  int get daysToRead {
    return 365 * 10;
  }

  DateTime get endTime {
    return DateTime.now().add(Duration(days: daysToRead));
  }

  DateTime get startTime {
    return DateTime.now().subtract(Duration(days: daysToRead));
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
        return await hkr.HealthKitReporter.isAuthorizedToWrite(
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
        return hkr.HealthKitReporter.requestAuthorization(
          [CategoryType.sexualActivity.identifier],
          [CategoryType.sexualActivity.identifier],
        );
      }
    }
    return Future.value(false);
  }

  Future<List<Activity>> importSexualActivity() async {
    debugPrint('importSexualActivity');
    if (!kIsWeb) {
      List<Activity> journal = [..._shared.activity];
      List<Activity> importedRecords = [];
      Activity sampleActivity = Activity(
        id: null,
        partner: null,
        birthControl: null,
        partnerBirthControl: null,
        date: DateTime.now(),
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
      );

      try {
        List<dynamic> records = await readSexualActivity();

        if (Platform.isAndroid) {
          for (SexualActivityRecord record in records) {
            debugPrint(
              "${HealthConnectDataType.SexualActivity.name}: ${record.time} - ${record.protectionUsed} - ${record.metadata.id}",
            );

            bool matchedRecord = false;
            for (Activity activity in journal) {
              matchedRecord = activity.date.year == record.time.year &&
                  activity.date.month == record.time.month &&
                  activity.date.day == record.time.day &&
                  activity.date.hour == record.time.hour &&
                  activity.date.minute == record.time.minute;
              if (matchedRecord) {
                break;
              }
            }
            if (!matchedRecord) {
              importedRecords.add(
                Activity(
                  id: const Uuid().v4(),
                  partner: sampleActivity.partner,
                  birthControl: record.protectionUsed == Protection.protected
                      ? Contraceptive.condom
                      : sampleActivity.birthControl,
                  partnerBirthControl: sampleActivity.partnerBirthControl,
                  date: record.time,
                  location: sampleActivity.location,
                  notes: sampleActivity.notes,
                  duration: sampleActivity.duration,
                  orgasms: sampleActivity.orgasms,
                  partnerOrgasms: sampleActivity.partnerOrgasms,
                  place: sampleActivity.place,
                  initiator: sampleActivity.initiator,
                  rating: sampleActivity.rating,
                  type: sampleActivity.type,
                  practices: sampleActivity.practices,
                  mood: sampleActivity.mood,
                  watchedPorn: sampleActivity.watchedPorn,
                  ejaculation: sampleActivity.ejaculation,
                ),
              );
            }
          }
        } else if (Platform.isIOS) {
          for (hkr_category.Category record in records) {
            debugPrint(
              "${record.identifier}: ${record.startTimestamp} - ${record.harmonized.metadata}",
            );

            bool protectionUsed = false;
            try {
              protectionUsed = record.harmonized.metadata!['double']
                          ['dictionary']['HKSexualActivityProtectionUsed'] ==
                      1 ||
                  false;
            } catch (e) {
              debugPrint("Exception checking protection used");
            }
            DateTime startDate = DateTime.fromMillisecondsSinceEpoch(
              record.startTimestamp.toInt() * 1000,
            );
            DateTime endDate = DateTime.fromMillisecondsSinceEpoch(
              record.endTimestamp.toInt() * 1000,
            );

            bool matchedRecord = false;
            for (Activity activity in journal) {
              matchedRecord = activity.date.year == endDate.year &&
                  activity.date.month == endDate.month &&
                  activity.date.day == endDate.day &&
                  activity.date.hour == endDate.hour &&
                  activity.date.minute == endDate.minute;
              if (matchedRecord) {
                break;
              }
            }

            if (!matchedRecord) {
              importedRecords.add(
                Activity(
                  id: const Uuid().v4(),
                  partner: sampleActivity.partner,
                  birthControl: protectionUsed
                      ? Contraceptive.condom
                      : sampleActivity.birthControl,
                  partnerBirthControl: sampleActivity.partnerBirthControl,
                  date: endDate,
                  location: sampleActivity.location,
                  notes: sampleActivity.notes,
                  duration: endDate.difference(startDate).inMinutes,
                  orgasms: sampleActivity.orgasms,
                  partnerOrgasms: sampleActivity.partnerOrgasms,
                  place: sampleActivity.place,
                  initiator: sampleActivity.initiator,
                  rating: sampleActivity.rating,
                  type: sampleActivity.type,
                  practices: sampleActivity.practices,
                  mood: sampleActivity.mood,
                  watchedPorn: sampleActivity.watchedPorn,
                  ejaculation: sampleActivity.ejaculation,
                ),
              );
            }
          }
        }
        debugPrint("importedRecords: ${importedRecords.length}");
        journal.addAll(importedRecords);
        journal.sort((a, b) => a.date.isAfter(b.date) ? -1 : 1);
        _shared.activity = journal;
        return importedRecords;
      } catch (e) {
        debugPrint("Exception catched importing records: $e");
        return Future.error(e);
      }
    }
    return Future.value([]);
  }

  Future<List<dynamic>> exportSexualActivity() async {
    debugPrint('exportSexualActivity');
    if (!kIsWeb) {
      try {
        await clearSexualActivity();
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

  Future<void> clearSexualActivity() async {
    debugPrint('clearSexualActivity');
    if (!kIsWeb) {
      try {
        if (Platform.isAndroid) {
          HealthConnectFactory.deleteRecordsByTime(
            type: HealthConnectDataType.SexualActivity,
            startTime: startTime,
            endTime: endTime,
          ).then(
            (value) {
              debugPrint(
                "delete ${HealthConnectDataType.SexualActivity.name}: $value",
              );
            },
          );
        } else if (Platform.isIOS) {
          Predicate predicate = Predicate(startTime, endTime);
          hkr.HealthKitReporter.deleteObjects(
            CategoryType.sexualActivity.identifier,
            predicate,
          ).then((value) {
            debugPrint(
              "delete ${CategoryType.sexualActivity.identifier}: $value",
            );
          });
        }
      } catch (e) {
        debugPrint("$e");
        return Future.error(e);
      }
    }
  }

  Future<List<dynamic>> readSexualActivity() async {
    if (!kIsWeb) {
      try {
        if (Platform.isAndroid) {
          return HealthConnectFactory.getRecords(
            type: HealthConnectDataType.SexualActivity,
            startTime: startTime,
            endTime: endTime,
          ).then((value) => sexualActivity = value);
        } else if (Platform.isIOS) {
          Predicate predicate = Predicate(startTime, endTime);
          return hkr.HealthKitReporter.categoryQuery(
            CategoryType.sexualActivity,
            predicate,
          ).then((value) => sexualActivity = value.toList());
        }
      } catch (e) {
        debugPrint(e.toString());
        return Future.error(e);
      }
    }
    return Future.value([]);
  }

  Future<dynamic> findSexualActivity(Activity activity) async {
    if (!kIsWeb) {
      try {
        if (sexualActivity.isEmpty) {
          await readSexualActivity();
        }
        debugPrint("sexualActivity length: ${sexualActivity.length}");
        if (Platform.isAndroid) {
          final records = sexualActivity as List<SexualActivityRecord>;
          return records.firstWhereOrNull(
            (record) => record.metadata.clientRecordId == activity.id,
          );
        } else if (Platform.isIOS) {
          final records = sexualActivity as List<hkr_category.Category>;
          return records.firstWhereOrNull(
            (record) {
              String recordDate = DateTime.fromMillisecondsSinceEpoch(
                record.endTimestamp.toInt() * 1000,
              ).toString().toString().substring(0, 19);
              String activityDate = activity.date.toString().substring(0, 19);
              debugPrint(
                  "$recordDate = $activityDate ${recordDate == activityDate}");
              return recordDate == activityDate;
            },
          );
        }
      } catch (e) {
        debugPrint(e.toString());
        return Future.error(e);
      }
    }
    return Future.value(null);
  }

  Future<bool> deleteSexualActivity(Activity activity) async {
    debugPrint(
      "deleteSexualActivity: ${activity.id}",
    );
    if (!kIsWeb) {
      if (activity.type == ActivityType.sexualIntercourse) {
        final endDate = activity.date.add(
          Duration(minutes: activity.duration + 1),
        );
        final startDate = activity.date.subtract(
          Duration(minutes: activity.duration + 1),
        );

        if (Platform.isAndroid) {
          final record = await findSexualActivity(activity);
          if (record != null) {
            final androidRecord = record as SexualActivityRecord;
            return HealthConnectFactory.deleteRecordsByIds(
              type: HealthConnectDataType.SexualActivity,
              idList: [androidRecord.metadata.id],
            ).then(
              (value) {
                debugPrint(
                  "delete by id ${HealthConnectDataType.SexualActivity.name}: $value",
                );
                return value;
              },
            );
          } else {
            return HealthConnectFactory.deleteRecordsByTime(
              type: HealthConnectDataType.SexualActivity,
              startTime: startDate,
              endTime: endDate,
            ).then(
              (value) {
                debugPrint(
                  "delete ${HealthConnectDataType.SexualActivity.name}: $value",
                );
                return value;
              },
            );
          }
        } else if (Platform.isIOS) {
          Predicate predicate = Predicate(startDate, endDate);
          return hkr.HealthKitReporter.deleteObjects(
            CategoryType.sexualActivity.identifier,
            predicate,
          ).then((value) {
            debugPrint(
              "delete ${CategoryType.sexualActivity.identifier}: $value",
            );
            return value['status'];
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
      bool protection = _shared.isProtectionUsed(activity);
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
            final canWrite = await hkr.HealthKitReporter.isAuthorizedToWrite(
                CategoryType.sexualActivity.identifier);
            if (canWrite) {
              if (activity.type == ActivityType.sexualIntercourse) {
                final startDate = activity.date.subtract(
                  Duration(minutes: activity.duration),
                );
                final harmonized = hkr_category.CategoryHarmonized(
                  0,
                  'HKCategoryValue',
                  'Not Applicable',
                  {
                    'HKWasUserEntered': 1,
                    'HKSexualActivityProtectionUsed': protection ? 1 : 0,
                  },
                );
                final sexualActivity = hkr_category.Category(
                  activity.id!,
                  CategoryType.sexualActivity.identifier,
                  startDate.millisecondsSinceEpoch,
                  activity.date.millisecondsSinceEpoch,
                  null,
                  sourceRevision,
                  harmonized,
                );
                return hkr.HealthKitReporter.save(sexualActivity).then((value) {
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

  Future<bool> updateSexualActivity(
      Activity activity, Activity originalActivity) async {
    await deleteSexualActivity(originalActivity);
    return writeSexualActivity(activity);
  }

  void clearUnknownRecords() {
    debugPrint(
      "clearUnknownRecords",
    );
    List<Activity> journal = [..._shared.activity];
    for (Activity activity in _shared.activity) {
      if (activity.partner == null) {
        journal.remove(activity);
      }
    }
    _shared.activity = journal;
  }
}
