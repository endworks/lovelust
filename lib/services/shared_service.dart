import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lovelust/l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:home_widget/home_widget.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl_standalone.dart';
import 'package:lovelust/extensions/string_extension.dart';
import 'package:lovelust/models/activity.dart';
import 'package:lovelust/models/activity_widget_data.dart';
import 'package:lovelust/models/enum.dart';
import 'package:lovelust/models/partner.dart';
import 'package:lovelust/models/settings.dart';
import 'package:lovelust/models/statistics.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/api_service.dart';
import 'package:lovelust/services/local_auth_service.dart';
import 'package:lovelust/services/navigation_service.dart';
import 'package:lovelust/services/storage_service.dart';
import 'package:lovelust/widgets/statistics/dynamic_statistic.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:relative_time/relative_time.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SharedService extends ChangeNotifier {
  final StorageService _storage = getIt<StorageService>();
  final ApiService _api = getIt<ApiService>();
  final LocalAuthService _localAuth = getIt<LocalAuthService>();
  final NavigationService _navigator = getIt<NavigationService>();

  Settings _settings = defaultSettings;

  List<Activity> _activity = [];
  List<Partner> _partners = [];
  List<Widget> _statistics = [];
  bool _protected = false;
  PackageInfo? packageInfo;
  AppLifecycleState appLifecycleState = AppLifecycleState.inactive;

  Future<void> initialLoad() async {
    debugPrint('initialLoad');
    List<Future> futures = <Future>[
      _storage.getSettings(),
      _storage.getActivity(),
      _storage.getPartners(),
      findSystemLocale(),
    ];

    List result = await Future.wait(futures);
    _settings = result[0];
    _activity = result[1];
    _partners = result[2];
    Intl.systemLocale = result[3];

    if (_settings.requireAuth && !authorized) {
      _protected = true;
    }

    //statistics = generateStatistics();
    updateWidgets();

    await getPackageInfo();
  }

  Future<void> initialFetch() async {
    debugPrint('initialFetch');
    activity = await _api.getActivity();
    partners = await _api.getPartners();
  }

  Future<void> getPackageInfo() async {
    if (!kDebugMode) {
      packageInfo = await PackageInfo.fromPlatform();
    }
  }

  Color generateAltColor(Color color, {double variation = 30.0}) {
    HSLColor hslColor = HSLColor.fromColor(color);
    double hue = hslColor.hue - variation;
    if (hue > 360) {
      hue = hue - 360;
    }
    if (hue < 0) {
      hue = hue + 360;
    }
    return hslColor.withHue(hue).toColor();
  }

  List<Widget> generateStatistics() {
    debugPrint('generateStatistics');
    BuildContext context = _navigator.navigatorKey.currentContext!;
    Color primary = Theme.of(context).colorScheme.primary;
    Color secondary = Theme.of(context).colorScheme.secondary;

    List<DynamicStatisticData> list = [];
    Activity? lastRelationship = activity.firstWhereOrNull(
        (element) => element.type == ActivityType.sexualIntercourse);
    if (lastRelationship != null) {
      list.add(
        DynamicStatisticData(
          type: StatisticType.lastRelationship,
          date: lastRelationship.date,
          data: lastRelationship,
        ),
      );
    }

    Activity? lastMasturbation = activity.firstWhereOrNull(
        (element) => element.type == ActivityType.masturbation);
    if (lastMasturbation != null) {
      list.add(
        DynamicStatisticData(
          type: StatisticType.lastMasturbation,
          date: lastMasturbation.date,
          data: lastMasturbation,
        ),
      );
    }

    DateTime daysWithoutSexDate = DateTime.now();
    int lastRelationshipDays = -1;
    if (lastRelationship != null) {
      lastRelationshipDays =
          (DateTime.now().difference(lastRelationship.date).inHours / 24)
              .floor();
    }
    int lastMasturbationDays = -1;
    if (lastMasturbation != null) {
      lastMasturbationDays =
          (DateTime.now().difference(lastMasturbation.date).inHours / 24)
              .floor();
    }
    if (lastRelationship != null && lastMasturbation != null) {
      daysWithoutSexDate =
          lastRelationship.date.difference(lastMasturbation.date).inSeconds > 0
              ? lastRelationship.date
              : lastMasturbation.date;
    } else if (lastRelationship != null) {
      daysWithoutSexDate = lastRelationship.date;
    } else if (lastMasturbation != null) {
      daysWithoutSexDate = lastMasturbation.date;
    }
    daysWithoutSexDate = daysWithoutSexDate.add(const Duration(seconds: 1));
    if (lastRelationshipDays > 0 || lastMasturbationDays > 0) {
      list.add(
        DynamicStatisticData(
          type: StatisticType.daysWithoutSex,
          date: daysWithoutSexDate,
          data: DaysWithoutSexData(lastRelationshipDays, lastMasturbationDays),
        ),
      );
    }
    if (lastRelationship != null || lastMasturbation != null) {
      List<WeeklyChartData> sexChartData = [];
      List<WeeklyChartData> masturbationChartData = [];

      final now = DateTime.now();
      List<Activity> data = activity
          .where(
            (element) =>
                element.date.compareTo(
                  DateTime(
                    now.year,
                    now.month,
                    now.day - 7,
                  ),
                ) >
                0,
          )
          .toList();

      List<String> weekdays = DateFormat.EEEE().dateSymbols.SHORTWEEKDAYS;

      for (var i = 6; i >= 0; i--) {
        DateTime currentDate = DateTime(
          now.year,
          now.month,
          now.day - i,
        );
        List<Activity> currentDayData = data
            .where((element) => element.date.day == currentDate.day)
            .toList();
        int countSex = currentDayData
            .where((element) => element.type == ActivityType.sexualIntercourse)
            .length;
        int countMasturbation = currentDayData
            .where((element) => element.type == ActivityType.masturbation)
            .length;
        String weekday = weekdays
            .elementAt(currentDate.weekday == 7 ? 0 : currentDate.weekday);
        WeeklyChartData sexChartItem = WeeklyChartData(
          day: weekday.capitalize(),
          activityCount: countSex.toDouble(),
        );
        sexChartData.add(sexChartItem);
        WeeklyChartData masturbationChartItem = WeeklyChartData(
          day: weekday.capitalize(),
          activityCount: countMasturbation.toDouble(),
        );
        masturbationChartData.add(masturbationChartItem);
      }

      List<XyDataSeries<WeeklyChartData, String>> series = [];
      bool hasSexData = sexChartData.firstWhereOrNull(
            (element) => element.activityCount > 0,
          ) !=
          null;
      bool hasMasturbationData = masturbationChartData.firstWhereOrNull(
            (element) => element.activityCount > 0,
          ) !=
          null;

      if (hasMasturbationData) {
        series.add(
          SplineAreaSeries<WeeklyChartData, String>(
            dataSource: masturbationChartData,
            isVisibleInLegend: masturbationChartData.isNotEmpty,
            name: AppLocalizations.of(context)!.masturbation,
            color: secondary,
            xValueMapper: (WeeklyChartData data, _) => data.day,
            yValueMapper: (WeeklyChartData data, _) => data.activityCount,
            markerSettings: MarkerSettings(
              isVisible: false,
              color: secondary,
              borderColor: secondary,
              borderWidth: 2,
              height: 4,
              width: 4,
            ),
            splineType: SplineType.monotonic,
            legendIconType: LegendIconType.circle,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                secondary.withAlpha(128),
                secondary.withAlpha(64),
                secondary.withAlpha(0),
              ],
              stops: const [
                0.0,
                0.3,
                0.9,
              ],
            ),
            borderWidth: 3,
            borderColor: secondary,
            borderGradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                secondary,
                generateAltColor(secondary),
              ],
            ),
          ),
        );
      }

      if (hasSexData) {
        series.add(
          SplineAreaSeries<WeeklyChartData, String>(
            dataSource: sexChartData,
            isVisibleInLegend: sexChartData.isNotEmpty,
            name: AppLocalizations.of(context)!.sexualIntercourse,
            color: primary,
            xValueMapper: (WeeklyChartData data, _) => data.day,
            yValueMapper: (WeeklyChartData data, _) => data.activityCount,
            markerSettings: MarkerSettings(
              isVisible: false,
              color: primary,
              borderColor: primary,
              borderWidth: 2,
              height: 4,
              width: 4,
            ),
            splineType: SplineType.monotonic,
            legendIconType: LegendIconType.circle,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                primary.withAlpha(128),
                primary.withAlpha(64),
                primary.withAlpha(0),
              ],
              stops: const [
                0.0,
                0.3,
                0.9,
              ],
            ),
            borderWidth: 3,
            borderColor: primary,
            borderGradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                primary,
                generateAltColor(primary),
              ],
            ),
          ),
        );
      }

      if (hasSexData || hasMasturbationData) {
        list.add(
          DynamicStatisticData(
            type: StatisticType.weeklyChart,
            date: DateTime.now(),
            data: series,
          ),
        );
      }
    }

    list.sort((a, b) => b.date.compareTo(a.date));

    return list
        .map(
          (e) => DynamicStatistic(
            type: e.type,
            date: e.date,
            data: e.data,
          ),
        )
        .toList();
  }

  void updateWidgets() {
    if (!kIsWeb) {
      if (Platform.isIOS) {
        HomeWidget.setAppGroupId('group.LoveLust');
      }
      BuildContext context = _navigator.navigatorKey.currentContext!;

      try {
        Activity? lastSexualIntercourse = activity.firstWhereOrNull(
            (element) => element.type == ActivityType.sexualIntercourse);
        if (lastSexualIntercourse != null) {
          Partner? partner;
          if (lastSexualIntercourse.partner != null) {
            partner = getPartnerById(lastSexualIntercourse.partner!);
          }
          ActivitySafety safety = calculateSafety(lastSexualIntercourse);
          String safetyValue;
          String safetyString;
          switch (safety) {
            case ActivitySafety.safe:
              safetyValue = "SAFE";
              safetyString = AppLocalizations.of(context)!.safeSex;
              break;
            case ActivitySafety.unsafe:
              safetyValue = "UNSAFE";
              safetyString = AppLocalizations.of(context)!.unsafeSex;
              break;
            default:
              safetyValue = "PARTIALLY_UNSAFE";
              safetyString = AppLocalizations.of(context)!.partiallyUnsafeSex;
          }

          ActivityWidgetData widgetData = ActivityWidgetData(
            activity: lastSexualIntercourse,
            partner: partner,
            safety: safetyValue,
            partnerString: partner != null
                ? partner.name
                : AppLocalizations.of(context)!.unknownPartner,
            safetyString: safetyString,
            dateString: RelativeTime(context, numeric: true)
                .format(lastSexualIntercourse.date),
            dayString:
                DateFormat(DateFormat.DAY).format(lastSexualIntercourse.date),
            weekdayString: DateFormat(DateFormat.WEEKDAY)
                .format(lastSexualIntercourse.date),
            placeString: getPlaceTranslation(lastSexualIntercourse.place),
            contraceptiveString:
                getContraceptiveTranslation(lastSexualIntercourse.birthControl),
            partnerContraceptiveString: getContraceptiveTranslation(
                lastSexualIntercourse.partnerBirthControl),
            moodString: getMoodTranslation(lastSexualIntercourse.mood),
            moodEmoji: getMoodEmoji(lastSexualIntercourse.mood),
            feelingsStrings: [],
          );

          HomeWidget.saveWidgetData<String>(
            'lastSexualIntercourse',
            jsonEncode(widgetData),
          ).then((value) {
            Future.wait([
              HomeWidget.updateWidget(
                iOSName: "LastActivity",
                androidName: 'LastActivityWidgetReceiver',
                qualifiedAndroidName:
                    'works.end.LoveLust.glance.LastActivityWidgetReceiver',
              )
            ]).then((value) => debugPrint("update widget data"));
            if (Platform.isIOS) {
              HomeWidget.updateWidget(
                iOSName: "DaysSince",
              );
            }
          });
        }
      } catch (e) {
        HomeWidget.saveWidgetData(
          'lastSexualIntercourse',
          null,
        ).then((value) {
          Future.wait([
            HomeWidget.updateWidget(
              iOSName: "LastActivity",
            ),
            HomeWidget.updateWidget(
              iOSName: "DaysSince",
            )
          ]).then((value) => debugPrint("delete widget data"));
        });
      }
    }
  }

  void launchedFromWidget(Uri? uri) {
    if (uri != null) {
      BuildContext context = _navigator.navigatorKey.currentContext!;
      showDialog(
        context: context,
        builder: (buildContext) => AlertDialog(
          title: const Text('App started from HomeScreenWidget'),
          content: Text('Here is the URI: $uri'),
        ),
      );
    }
  }

  void appLifecycleStateChanged(AppLifecycleState state) {
    debugPrint(state.name);
    appLifecycleState = state;
    if (state == AppLifecycleState.inactive) {
      if (requireAuth || privacyMode) {
        if (!isAuthenticating) {
          protected = true;
        }
      }
    }
    if (state == AppLifecycleState.resumed) {
      if (!requireAuth || privacyMode || authorized) {
        protected = false;
      }
    }
    if (state == AppLifecycleState.paused) {
      if (requireAuth) {
        authorized = false;
        _localAuth.authenticationFailed = false;
      }
    }
    updateWidgets();
  }

  bool get isLoggedIn {
    return accessToken != null;
  }

  void signOut() {
    debugPrint('signOut');
    accessToken = null;
    refreshToken = null;
  }

  void clearPersonalData() {
    debugPrint('clearPersonalData');
    theme = 'system';
    colorScheme = null;
    accessToken = null;
    refreshToken = null;
    activity = [];
    partners = [];
  }

  void clearData() async {
    debugPrint('clearData');
    await _storage.clear();
  }

  Widget sensitiveText(String text, {TextStyle? style}) {
    return privacyMode
        ? blurText(text, style: style)
        : Text(text, style: style);
  }

  Widget inappropriateText(
    String text, {
    TextStyle? style,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return sensitiveMode
        ? blurText(text, style: style)
        : Text(
            text,
            style: style,
            maxLines: maxLines,
            overflow: overflow,
          );
  }

  Widget blurText(String text, {TextStyle? style}) {
    Text widget = Text(text, style: style);
    double blurRadius = style != null ? style.fontSize! / 4 : 5;
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: blurRadius, sigmaY: blurRadius),
      child: Container(child: widget),
    );
  }

  Widget obscureText(String text, {TextStyle? style}) {
    return Text(text.replaceAll(RegExp(r"."), "*"), style: style);
  }

  ActivitySafety calculateSafety(Activity activity) {
    List<Contraceptive> safe = [
      Contraceptive.condom,
      Contraceptive.internalCondom,
      Contraceptive.outercourse,
    ];
    List<Contraceptive?> unsafe = [
      null,
      Contraceptive.pullOut,
      Contraceptive.unsafeContraceptive
    ];

    if (safe.contains(activity.birthControl) ||
        safe.contains(activity.partnerBirthControl)) {
      return ActivitySafety.safe;
    }

    if (unsafe.contains(activity.birthControl) &&
        unsafe.contains(activity.partnerBirthControl)) {
      return ActivitySafety.unsafe;
    }

    return ActivitySafety.partiallyUnsafe;
  }

  Activity? getActivityById(String id) {
    if (id.isEmpty) {
      return null;
    }
    return activity.firstWhere((element) => element.id == id);
  }

  List<Activity> getActivityByPartner(String? id) {
    return activity.where((element) => element.partner == id).toList();
  }

  Partner? getPartnerById(String id) {
    if (id.isEmpty) {
      return null;
    }
    return partners.firstWhere((element) => element.id == id);
  }

  static Contraceptive? getContraceptiveByValue(String? value) {
    if (value == 'CERVICAL_CAP') {
      return Contraceptive.cervicalCap;
    } else if (value == 'CONDOM') {
      return Contraceptive.condom;
    } else if (value == 'DIAPHRAGM') {
      return Contraceptive.diaphragm;
    } else if (value == 'IMPLANT') {
      return Contraceptive.contraceptiveImplant;
    } else if (value == 'INFERTILITY') {
      return Contraceptive.infertility;
    } else if (value == 'INTERNAL_CONDOM') {
      return Contraceptive.internalCondom;
    } else if (value == 'IUD') {
      return Contraceptive.intrauterineDevice;
    } else if (value == 'OUTERCOURSE') {
      return Contraceptive.outercourse;
    } else if (value == 'PATCH') {
      return Contraceptive.contraceptivePatch;
    } else if (value == 'PILL') {
      return Contraceptive.pill;
    } else if (value == 'PULL_OUT') {
      return Contraceptive.pullOut;
    } else if (value == 'SHOT') {
      return Contraceptive.contraceptiveShot;
    } else if (value == 'SPONGE') {
      return Contraceptive.sponge;
    } else if (value == 'TUBAL_LIGATION') {
      return Contraceptive.tubalLigation;
    } else if (value == 'UNSAFE_BIRTH_CONTROL') {
      return Contraceptive.unsafeContraceptive;
    } else if (value == 'VAGINAL_RING') {
      return Contraceptive.vaginalRing;
    } else if (value == 'VASECTOMY') {
      return Contraceptive.vasectomy;
    }
    return null;
  }

  static String? setValueByContraceptive(Contraceptive? value) {
    if (value == Contraceptive.cervicalCap) {
      return 'CERVICAL_CAP';
    } else if (value == Contraceptive.condom) {
      return 'CONDOM';
    } else if (value == Contraceptive.diaphragm) {
      return 'DIAPHRAGM';
    } else if (value == Contraceptive.contraceptiveImplant) {
      return 'IMPLANT';
    } else if (value == Contraceptive.infertility) {
      return 'INFERTILITY';
    } else if (value == Contraceptive.internalCondom) {
      return 'INTERNAL_CONDOM';
    } else if (value == Contraceptive.intrauterineDevice) {
      return 'IUD';
    } else if (value == Contraceptive.outercourse) {
      return 'OUTERCOURSE';
    } else if (value == Contraceptive.contraceptivePatch) {
      return 'PATCH';
    } else if (value == Contraceptive.pill) {
      return 'PILL';
    } else if (value == Contraceptive.pullOut) {
      return 'PULL_OUT';
    } else if (value == Contraceptive.contraceptiveShot) {
      return 'SHOT';
    } else if (value == Contraceptive.sponge) {
      return 'SPONGE';
    } else if (value == Contraceptive.tubalLigation) {
      return 'TUBAL_LIGATION';
    } else if (value == Contraceptive.unsafeContraceptive) {
      return 'UNSAFE_BIRTH_CONTROL';
    } else if (value == Contraceptive.vaginalRing) {
      return 'VAGINAL_RING';
    } else if (value == Contraceptive.vasectomy) {
      return 'VASECTOMY';
    }
    return null;
  }

  static Initiator? getInitiatorByValue(String? value) {
    if (value == 'ME') {
      return Initiator.me;
    } else if (value == 'PARTNER') {
      return Initiator.partner;
    } else if (value == 'BOTH') {
      return Initiator.both;
    } else if (value == 'OTHER') {
      return Initiator.other;
    }
    return null;
  }

  static String? setValueByInitiator(Initiator? value) {
    if (value == Initiator.me) {
      return 'ME';
    } else if (value == Initiator.partner) {
      return 'PARTNER';
    } else if (value == Initiator.both) {
      return 'BOTH';
    } else if (value == Initiator.other) {
      return 'OTHER';
    }
    return null;
  }

  static Place? getPlaceByValue(String? value) {
    if (value == 'BACKYARD') {
      return Place.backyard;
    } else if (value == 'BAR') {
      return Place.bar;
    } else if (value == 'BATHROOM') {
      return Place.bathroom;
    } else if (value == 'BEACH') {
      return Place.beach;
    } else if (value == 'BEDROOM') {
      return Place.bedroom;
    } else if (value == 'CAR') {
      return Place.car;
    } else if (value == 'CHAIR') {
      return Place.chair;
    } else if (value == 'CINEMA') {
      return Place.cinema;
    } else if (value == 'ELEVATOR') {
      return Place.elevator;
    } else if (value == 'FOREST') {
      return Place.forest;
    } else if (value == 'GARAGE') {
      return Place.garage;
    } else if (value == 'HOME') {
      return Place.home;
    } else if (value == 'HOTEL') {
      return Place.hotel;
    } else if (value == 'JACUZZI') {
      return Place.jacuzzi;
    } else if (value == 'KITCHEN') {
      return Place.kitchen;
    } else if (value == 'LIVING_ROOM') {
      return Place.livingRoom;
    } else if (value == 'MUSEUM') {
      return Place.museum;
    } else if (value == 'OTHER') {
      return Place.other;
    } else if (value == 'PARTY') {
      return Place.party;
    } else if (value == 'PLANE') {
      return Place.plane;
    } else if (value == 'POOL') {
      return Place.pool;
    } else if (value == 'PUBLIC') {
      return Place.public;
    } else if (value == 'RESTROOM') {
      return Place.restroom;
    } else if (value == 'ROOF') {
      return Place.roof;
    } else if (value == 'SCHOOL') {
      return Place.school;
    } else if (value == 'SHIP') {
      return Place.ship;
    } else if (value == 'SHOWER') {
      return Place.shower;
    } else if (value == 'SOFA') {
      return Place.sofa;
    } else if (value == 'TABLE') {
      return Place.table;
    } else if (value == 'THEATRE') {
      return Place.theatre;
    } else if (value == 'TRAIN') {
      return Place.train;
    } else if (value == 'WORK') {
      return Place.work;
    }
    return null;
  }

  static String? setValueByPlace(Place? value) {
    if (value == Place.backyard) {
      return 'BACKYARD';
    } else if (value == Place.bar) {
      return 'BAR';
    } else if (value == Place.bathroom) {
      return 'BATHROOM';
    } else if (value == Place.beach) {
      return 'BEACH';
    } else if (value == Place.bedroom) {
      return 'BEDROOM';
    } else if (value == Place.car) {
      return 'CAR';
    } else if (value == Place.chair) {
      return 'CHAIR';
    } else if (value == Place.cinema) {
      return 'CINEMA';
    } else if (value == Place.elevator) {
      return 'ELEVATOR';
    } else if (value == Place.forest) {
      return 'FOREST';
    } else if (value == Place.garage) {
      return 'GARAGE';
    } else if (value == Place.home) {
      return 'HOME';
    } else if (value == Place.hotel) {
      return 'HOTEL';
    } else if (value == Place.jacuzzi) {
      return 'JACUZZI';
    } else if (value == Place.kitchen) {
      return 'KITCHEN';
    } else if (value == Place.livingRoom) {
      return 'LIVING_ROOM';
    } else if (value == Place.museum) {
      return 'MUSEUM';
    } else if (value == Place.other) {
      return 'OTHER';
    } else if (value == Place.party) {
      return 'PARTY';
    } else if (value == Place.plane) {
      return 'PLANE';
    } else if (value == Place.pool) {
      return 'POOL';
    } else if (value == Place.public) {
      return 'PUBLIC';
    } else if (value == Place.restroom) {
      return 'RESTROOM';
    } else if (value == Place.roof) {
      return 'ROOF';
    } else if (value == Place.school) {
      return 'SCHOOL';
    } else if (value == Place.ship) {
      return 'SHIP';
    } else if (value == Place.shower) {
      return 'SHOWER';
    } else if (value == Place.sofa) {
      return 'SOFA';
    } else if (value == Place.table) {
      return 'TABLE';
    } else if (value == Place.theatre) {
      return 'THEATRE';
    } else if (value == Place.train) {
      return 'TRAIN';
    } else if (value == Place.work) {
      return 'WORK';
    }
    return null;
  }

  static ActivityType? getActivityTypeByValue(String? value) {
    if (value == 'MASTURBATION') {
      return ActivityType.masturbation;
    } else if (value == 'SEXUAL_INTERCOURSE') {
      return ActivityType.sexualIntercourse;
    }
    return null;
  }

  static String? setValueByActivityType(ActivityType? value) {
    if (value == ActivityType.masturbation) {
      return 'MASTURBATION';
    } else if (value == ActivityType.sexualIntercourse) {
      return 'SEXUAL_INTERCOURSE';
    }
    return null;
  }

  static BiologicalSex getBiologicalSexByValue(String value) {
    if (value == 'F') {
      return BiologicalSex.female;
    }
    return BiologicalSex.male;
  }

  static String setValueByBiologicalSex(BiologicalSex value) {
    if (value == BiologicalSex.female) {
      return 'F';
    } else if (value == BiologicalSex.male) {
      return 'M';
    }
    return 'NB';
  }

  static Gender getGenderByValue(String value) {
    if (value == 'F') {
      return Gender.female;
    } else if (value == 'M') {
      return Gender.male;
    }
    return Gender.nonBinary;
  }

  static String setValueByGender(Gender value) {
    if (value == Gender.female) {
      return 'F';
    } else if (value == Gender.male) {
      return 'M';
    }
    return 'NB';
  }

  static Practice? getPracticeByValue(String? value) {
    if (value == 'ANAL') {
      return Practice.anal;
    } else if (value == 'BDSM') {
      return Practice.bdsm;
    } else if (value == 'BONDAGE') {
      return Practice.bondage;
    } else if (value == 'CHOKING') {
      return Practice.choking;
    } else if (value == 'CUDDLING') {
      return Practice.cuddling;
    } else if (value == 'DOMINATION') {
      return Practice.domination;
    } else if (value == 'FINGERING') {
      return Practice.fingering;
    } else if (value == 'HANDJOB') {
      return Practice.handjob;
    } else if (value == 'MASTURBATION') {
      return Practice.masturbation;
    } else if (value == 'ORAL') {
      return Practice.oral;
    } else if (value == 'TOY') {
      return Practice.toy;
    } else if (value == 'VAGINAL') {
      return Practice.vaginal;
    } else if (value == 'ANILINGUS') {
      return Practice.anilingus;
    } else if (value == 'BLOWJOB') {
      return Practice.blowjob;
    } else if (value == 'CUNNILINGUS') {
      return Practice.cunnilingus;
    } else if (value == 'TITJOB') {
      return Practice.titjob;
    } else if (value == 'WHITE_KISS') {
      return Practice.whiteKiss;
    } else if (value == 'CREAMPIE') {
      return Practice.creampie;
    }
    return null;
  }

  static String? setValueByPractice(Practice? value) {
    if (value == Practice.anal) {
      return 'ANAL';
    } else if (value == Practice.bdsm) {
      return 'BDSM';
    } else if (value == Practice.bondage) {
      return 'BONDAGE';
    } else if (value == Practice.choking) {
      return 'CHOKING';
    } else if (value == Practice.cuddling) {
      return 'CUDDLING';
    } else if (value == Practice.domination) {
      return 'DOMINATION';
    } else if (value == Practice.fingering) {
      return 'FINGERING';
    } else if (value == Practice.handjob) {
      return 'HANDJOB';
    } else if (value == Practice.masturbation) {
      return 'MASTURBATION';
    } else if (value == Practice.oral) {
      return 'ORAL';
    } else if (value == Practice.toy) {
      return 'TOY';
    } else if (value == Practice.vaginal) {
      return 'VAGINAL';
    } else if (value == Practice.anilingus) {
      return 'ANILINGUS';
    } else if (value == Practice.blowjob) {
      return 'BLOWJOB';
    } else if (value == Practice.cunnilingus) {
      return 'CUNNILINGUS';
    } else if (value == Practice.titjob) {
      return 'TITJOB';
    } else if (value == Practice.whiteKiss) {
      return 'WHITE_KISS';
    } else if (value == Practice.creampie) {
      return 'CREAMPIE';
    }
    return null;
  }

  static Mood? getMoodByValue(String? value) {
    if (value == 'ADVENTUROUS') {
      return Mood.adventurous;
    } else if (value == 'ANGRY') {
      return Mood.angry;
    } else if (value == 'COMFORTABLE') {
      return Mood.comfortable;
    } else if (value == 'CRAZY') {
      return Mood.crazy;
    } else if (value == 'HORNY') {
      return Mood.horny;
    } else if (value == 'LAZY') {
      return Mood.lazy;
    } else if (value == 'PLAYFUL') {
      return Mood.playful;
    } else if (value == 'RELAXED') {
      return Mood.relaxed;
    } else if (value == 'SAFE') {
      return Mood.safe;
    } else if (value == 'SCARED') {
      return Mood.scared;
    } else if (value == 'SURPRISED') {
      return Mood.surprised;
    } else if (value == 'UNSAFE') {
      return Mood.unsafe;
    } else if (value == 'OTHER') {
      return Mood.other;
    }
    return null;
  }

  static String? setValueByMood(Mood? value) {
    if (value == Mood.adventurous) {
      return 'ADVENTUROUS';
    } else if (value == Mood.angry) {
      return 'ANGRY';
    } else if (value == Mood.comfortable) {
      return 'COMFORTABLE';
    } else if (value == Mood.crazy) {
      return 'CRAZY';
    } else if (value == Mood.horny) {
      return 'HORNY';
    } else if (value == Mood.lazy) {
      return 'LAZY';
    } else if (value == Mood.playful) {
      return 'PLAYFUL';
    } else if (value == Mood.relaxed) {
      return 'RELAXED';
    } else if (value == Mood.safe) {
      return 'SAFE';
    } else if (value == Mood.scared) {
      return 'SCARED';
    } else if (value == Mood.surprised) {
      return 'SURPRISED';
    } else if (value == Mood.unsafe) {
      return 'UNSAFE';
    } else if (value == Mood.other) {
      return 'OTHER';
    }
    return null;
  }

  static AppIcon? getAppIconByValue(String? value) {
    if (value == 'Beta') {
      return AppIcon.beta;
    } else if (value == 'MonoBlack') {
      return AppIcon.monoBlack;
    } else if (value == 'MonoWhite') {
      return AppIcon.monoWhite;
    } else if (value == 'White') {
      return AppIcon.white;
    } else if (value == 'Blue') {
      return AppIcon.blue;
    } else if (value == 'Filled') {
      return AppIcon.filled;
    } else if (value == 'FilledBlack') {
      return AppIcon.filledBlack;
    } else if (value == 'FilledWhite') {
      return AppIcon.filledWhite;
    } else if (value == 'Glow') {
      return AppIcon.glow;
    } else if (value == 'Health') {
      return AppIcon.health;
    } else if (value == 'Health2') {
      return AppIcon.health2;
    } else if (value == 'Neon') {
      return AppIcon.neon;
    } else if (value == 'Pink') {
      return AppIcon.pink;
    } else if (value == 'Pride') {
      return AppIcon.pride;
    } else if (value == 'PrideAce') {
      return AppIcon.prideAce;
    } else if (value == 'PrideBi') {
      return AppIcon.prideBi;
    } else if (value == 'PrideClassic') {
      return AppIcon.prideClassic;
    } else if (value == 'PrideRainbow') {
      return AppIcon.prideRainbow;
    } else if (value == 'PrideRainbowLine') {
      return AppIcon.prideRainbowLine;
    } else if (value == 'PrideTrans') {
      return AppIcon.prideTrans;
    } else if (value == 'PrideRomania') {
      return AppIcon.prideRomania;
    } else if (value == 'Purple') {
      return AppIcon.purple;
    } else if (value == 'DeepPurple') {
      return AppIcon.deepPurple;
    } else if (value == 'Red') {
      return AppIcon.red;
    } else if (value == 'Sexapill') {
      return AppIcon.sexapill;
    } else if (value == 'Teal') {
      return AppIcon.teal;
    } else if (value == 'White') {
      return AppIcon.white;
    }
    return AppIcon.defaultAppIcon;
  }

  static String? setValueByAppIcon(AppIcon? value) {
    if (value == AppIcon.beta) {
      return 'Beta';
    } else if (value == AppIcon.monoBlack) {
      return 'MonoBlack';
    } else if (value == AppIcon.monoWhite) {
      return 'MonoWhite';
    } else if (value == AppIcon.white) {
      return 'White';
    } else if (value == AppIcon.blue) {
      return 'Blue';
    } else if (value == AppIcon.filled) {
      return 'Filled';
    } else if (value == AppIcon.filledBlack) {
      return 'FilledBlack';
    } else if (value == AppIcon.filledWhite) {
      return 'FilledWhite';
    } else if (value == AppIcon.glow) {
      return 'Glow';
    } else if (value == AppIcon.health) {
      return 'Health';
    } else if (value == AppIcon.health2) {
      return 'Health2';
    } else if (value == AppIcon.neon) {
      return 'Neon';
    } else if (value == AppIcon.pink) {
      return 'Pink';
    } else if (value == AppIcon.pride) {
      return 'Pride';
    } else if (value == AppIcon.prideAce) {
      return 'PrideAce';
    } else if (value == AppIcon.prideBi) {
      return 'PrideBi';
    } else if (value == AppIcon.prideClassic) {
      return 'PrideClassic';
    } else if (value == AppIcon.prideRainbow) {
      return 'PrideRainbow';
    } else if (value == AppIcon.prideRainbowLine) {
      return 'PrideRainbowLine';
    } else if (value == AppIcon.prideTrans) {
      return 'PrideTrans';
    } else if (value == AppIcon.prideRomania) {
      return 'PrideRomania';
    } else if (value == AppIcon.purple) {
      return 'Purple';
    } else if (value == AppIcon.deepPurple) {
      return 'DeepPurple';
    } else if (value == AppIcon.red) {
      return 'Red';
    } else if (value == AppIcon.sexapill) {
      return 'Sexapill';
    } else if (value == AppIcon.teal) {
      return 'Teal';
    } else if (value == AppIcon.white) {
      return 'White';
    }
    return null;
  }

  static AppColorScheme? getAppColorSchemeByValue(String? value) {
    if (value == 'dynamic') {
      return AppColorScheme.dynamic;
    } else if (value == 'black') {
      return AppColorScheme.black;
    } else if (value == 'blue') {
      return AppColorScheme.blue;
    } else if (value == 'love') {
      return AppColorScheme.pink;
    } else if (value == 'lust') {
      return AppColorScheme.purple;
    } else if (value == 'lipstick') {
      return AppColorScheme.red;
    } else if (value == 'shimapan') {
      return AppColorScheme.teal;
    }
    return AppColorScheme.defaultAppColorScheme;
  }

  static String? setValueByAppColorScheme(AppColorScheme? value) {
    if (value == AppColorScheme.black) {
      return 'black';
    } else if (value == AppColorScheme.blue) {
      return 'blue';
    } else if (value == AppColorScheme.dynamic) {
      return 'dynamic';
    } else if (value == AppColorScheme.pink) {
      return 'love';
    } else if (value == AppColorScheme.purple) {
      return 'lust';
    } else if (value == AppColorScheme.red) {
      return 'lipstick';
    } else if (value == AppColorScheme.teal) {
      return 'shimapan';
    }
    return null;
  }

  static String getContraceptiveTranslation(Contraceptive? value) {
    GetIt locator = GetIt.instance;
    BuildContext context =
        locator<NavigationService>().navigatorKey.currentContext!;

    if (value == Contraceptive.cervicalCap) {
      return AppLocalizations.of(context)!.cervicalCap;
    } else if (value == Contraceptive.condom) {
      return AppLocalizations.of(context)!.condom;
    } else if (value == Contraceptive.contraceptiveImplant) {
      return AppLocalizations.of(context)!.contraceptiveImplant;
    } else if (value == Contraceptive.contraceptivePatch) {
      return AppLocalizations.of(context)!.contraceptivePatch;
    } else if (value == Contraceptive.contraceptiveShot) {
      return AppLocalizations.of(context)!.contraceptiveShot;
    } else if (value == Contraceptive.diaphragm) {
      return AppLocalizations.of(context)!.diaphragm;
    } else if (value == Contraceptive.infertility) {
      return AppLocalizations.of(context)!.infertility;
    } else if (value == Contraceptive.internalCondom) {
      return AppLocalizations.of(context)!.internalCondom;
    } else if (value == Contraceptive.intrauterineDevice) {
      return AppLocalizations.of(context)!.intrauterineDevice;
    } else if (value == Contraceptive.outercourse) {
      return AppLocalizations.of(context)!.outercourse;
    } else if (value == Contraceptive.pill) {
      return AppLocalizations.of(context)!.pill;
    } else if (value == Contraceptive.pullOut) {
      return AppLocalizations.of(context)!.pullOut;
    } else if (value == Contraceptive.sponge) {
      return AppLocalizations.of(context)!.sponge;
    } else if (value == Contraceptive.tubalLigation) {
      return AppLocalizations.of(context)!.tubalLigation;
    } else if (value == Contraceptive.unsafeContraceptive) {
      return AppLocalizations.of(context)!.unsafeContraceptive;
    } else if (value == Contraceptive.vaginalRing) {
      return AppLocalizations.of(context)!.vaginalRing;
    } else if (value == Contraceptive.vasectomy) {
      return AppLocalizations.of(context)!.vasectomy;
    }
    return AppLocalizations.of(context)!.noBirthControl;
  }

  static String getPlaceTranslation(Place? value) {
    GetIt locator = GetIt.instance;
    BuildContext context =
        locator<NavigationService>().navigatorKey.currentContext!;

    if (value == Place.backyard) {
      return AppLocalizations.of(context)!.backyard;
    } else if (value == Place.bar) {
      return AppLocalizations.of(context)!.bar;
    } else if (value == Place.bathroom) {
      return AppLocalizations.of(context)!.bathroom;
    } else if (value == Place.beach) {
      return AppLocalizations.of(context)!.beach;
    } else if (value == Place.bedroom) {
      return AppLocalizations.of(context)!.bedroom;
    } else if (value == Place.car) {
      return AppLocalizations.of(context)!.car;
    } else if (value == Place.chair) {
      return AppLocalizations.of(context)!.chair;
    } else if (value == Place.cinema) {
      return AppLocalizations.of(context)!.cinema;
    } else if (value == Place.elevator) {
      return AppLocalizations.of(context)!.elevator;
    } else if (value == Place.forest) {
      return AppLocalizations.of(context)!.forest;
    } else if (value == Place.garage) {
      return AppLocalizations.of(context)!.garage;
    } else if (value == Place.home) {
      return AppLocalizations.of(context)!.home;
    } else if (value == Place.hotel) {
      return AppLocalizations.of(context)!.hotel;
    } else if (value == Place.jacuzzi) {
      return AppLocalizations.of(context)!.jacuzzi;
    } else if (value == Place.kitchen) {
      return AppLocalizations.of(context)!.kitchen;
    } else if (value == Place.livingRoom) {
      return AppLocalizations.of(context)!.livingRoom;
    } else if (value == Place.museum) {
      return AppLocalizations.of(context)!.museum;
    } else if (value == Place.other) {
      return AppLocalizations.of(context)!.other;
    } else if (value == Place.party) {
      return AppLocalizations.of(context)!.party;
    } else if (value == Place.plane) {
      return AppLocalizations.of(context)!.plane;
    } else if (value == Place.pool) {
      return AppLocalizations.of(context)!.pool;
    } else if (value == Place.public) {
      return AppLocalizations.of(context)!.public;
    } else if (value == Place.restroom) {
      return AppLocalizations.of(context)!.restroom;
    } else if (value == Place.roof) {
      return AppLocalizations.of(context)!.roof;
    } else if (value == Place.school) {
      return AppLocalizations.of(context)!.school;
    } else if (value == Place.ship) {
      return AppLocalizations.of(context)!.ship;
    } else if (value == Place.shower) {
      return AppLocalizations.of(context)!.shower;
    } else if (value == Place.sofa) {
      return AppLocalizations.of(context)!.sofa;
    } else if (value == Place.table) {
      return AppLocalizations.of(context)!.table;
    } else if (value == Place.theatre) {
      return AppLocalizations.of(context)!.theatre;
    } else if (value == Place.train) {
      return AppLocalizations.of(context)!.train;
    } else if (value == Place.work) {
      return AppLocalizations.of(context)!.work;
    }
    return AppLocalizations.of(context)!.unknownPlace;
  }

  static String getInitiatorTranslation(Initiator? value) {
    GetIt locator = GetIt.instance;
    BuildContext context =
        locator<NavigationService>().navigatorKey.currentContext!;

    if (value == Initiator.me) {
      return AppLocalizations.of(context)!.me;
    } else if (value == Initiator.partner) {
      return AppLocalizations.of(context)!.partner;
    } else if (value == Initiator.both) {
      return AppLocalizations.of(context)!.both;
    } else if (value == Initiator.other) {
      return AppLocalizations.of(context)!.other;
    }
    return AppLocalizations.of(context)!.noInitiator;
  }

  static String getPracticeTranslation(Practice? value) {
    GetIt locator = GetIt.instance;
    BuildContext context =
        locator<NavigationService>().navigatorKey.currentContext!;

    if (value == Practice.anal) {
      return AppLocalizations.of(context)!.anal;
    } else if (value == Practice.bdsm) {
      return AppLocalizations.of(context)!.bdsm;
    } else if (value == Practice.bondage) {
      return AppLocalizations.of(context)!.bondage;
    } else if (value == Practice.choking) {
      return AppLocalizations.of(context)!.choking;
    } else if (value == Practice.cuddling) {
      return AppLocalizations.of(context)!.cuddling;
    } else if (value == Practice.domination) {
      return AppLocalizations.of(context)!.domination;
    } else if (value == Practice.fingering) {
      return AppLocalizations.of(context)!.fingering;
    } else if (value == Practice.handjob) {
      return AppLocalizations.of(context)!.handjob;
    } else if (value == Practice.masturbation) {
      return AppLocalizations.of(context)!.masturbation;
    } else if (value == Practice.oral) {
      return AppLocalizations.of(context)!.oral;
    } else if (value == Practice.toy) {
      return AppLocalizations.of(context)!.toy;
    } else if (value == Practice.vaginal) {
      return AppLocalizations.of(context)!.vaginal;
    } else if (value == Practice.anilingus) {
      return AppLocalizations.of(context)!.anilingus;
    } else if (value == Practice.blowjob) {
      return AppLocalizations.of(context)!.blowjob;
    } else if (value == Practice.cunnilingus) {
      return AppLocalizations.of(context)!.cunnilingus;
    } else if (value == Practice.titjob) {
      return AppLocalizations.of(context)!.titjob;
    } else if (value == Practice.whiteKiss) {
      return AppLocalizations.of(context)!.whiteKiss;
    } else if (value == Practice.creampie) {
      return AppLocalizations.of(context)!.creampie;
    }
    return AppLocalizations.of(context)!.unknown;
  }

  static String getMoodTranslation(Mood? value) {
    GetIt locator = GetIt.instance;
    BuildContext context =
        locator<NavigationService>().navigatorKey.currentContext!;

    if (value == Mood.adventurous) {
      return AppLocalizations.of(context)!.adventurous;
    } else if (value == Mood.angry) {
      return AppLocalizations.of(context)!.angry;
    } else if (value == Mood.comfortable) {
      return AppLocalizations.of(context)!.comfortable;
    } else if (value == Mood.crazy) {
      return AppLocalizations.of(context)!.crazy;
    } else if (value == Mood.horny) {
      return AppLocalizations.of(context)!.horny;
    } else if (value == Mood.lazy) {
      return AppLocalizations.of(context)!.lazy;
    } else if (value == Mood.playful) {
      return AppLocalizations.of(context)!.playful;
    } else if (value == Mood.relaxed) {
      return AppLocalizations.of(context)!.relaxed;
    } else if (value == Mood.safe) {
      return AppLocalizations.of(context)!.safeMood;
    } else if (value == Mood.scared) {
      return AppLocalizations.of(context)!.scared;
    } else if (value == Mood.surprised) {
      return AppLocalizations.of(context)!.surprised;
    } else if (value == Mood.unsafe) {
      return AppLocalizations.of(context)!.unsafeMood;
    } else if (value == Mood.other) {
      return AppLocalizations.of(context)!.other;
    }
    return AppLocalizations.of(context)!.noMood;
  }

  static String getMoodEmoji(Mood? value) {
    if (value == Mood.adventurous) {
      return '🤠';
    } else if (value == Mood.angry) {
      return '😡';
    } else if (value == Mood.comfortable) {
      return '😊';
    } else if (value == Mood.crazy) {
      return '🤪';
    } else if (value == Mood.horny) {
      return '🥵';
    } else if (value == Mood.lazy) {
      return '🥱';
    } else if (value == Mood.playful) {
      return '😏';
    } else if (value == Mood.relaxed) {
      return '😌';
    } else if (value == Mood.safe) {
      return '🥰';
    } else if (value == Mood.scared) {
      return '😨';
    } else if (value == Mood.surprised) {
      return '😮';
    } else if (value == Mood.unsafe) {
      return '🤔';
    } else if (value == Mood.other) {
      return '😶';
    }
    return '😐';
  }

  static String getAppIconTranslation(AppIcon? value) {
    GetIt locator = GetIt.instance;
    BuildContext context =
        locator<NavigationService>().navigatorKey.currentContext!;

    if (value == AppIcon.beta) {
      return AppLocalizations.of(context)!.beta;
    } else if (value == AppIcon.monoBlack) {
      return AppLocalizations.of(context)!.monoBlack;
    } else if (value == AppIcon.monoWhite) {
      return AppLocalizations.of(context)!.monoWhite;
    } else if (value == AppIcon.white) {
      return AppLocalizations.of(context)!.white;
    } else if (value == AppIcon.blue) {
      return AppLocalizations.of(context)!.blue;
    } else if (value == AppIcon.filled) {
      return AppLocalizations.of(context)!.filled;
    } else if (value == AppIcon.filledBlack) {
      return AppLocalizations.of(context)!.filledBlack;
    } else if (value == AppIcon.filledWhite) {
      return AppLocalizations.of(context)!.filledWhite;
    } else if (value == AppIcon.glow) {
      return AppLocalizations.of(context)!.glow;
    } else if (value == AppIcon.health) {
      return AppLocalizations.of(context)!.health;
    } else if (value == AppIcon.health2) {
      return AppLocalizations.of(context)!.health2;
    } else if (value == AppIcon.neon) {
      return AppLocalizations.of(context)!.neon;
    } else if (value == AppIcon.pink) {
      return AppLocalizations.of(context)!.love;
    } else if (value == AppIcon.pride) {
      return AppLocalizations.of(context)!.pride;
    } else if (value == AppIcon.prideAce) {
      return AppLocalizations.of(context)!.prideAce;
    } else if (value == AppIcon.prideBi) {
      return AppLocalizations.of(context)!.prideBi;
    } else if (value == AppIcon.prideClassic) {
      return AppLocalizations.of(context)!.prideClassic;
    } else if (value == AppIcon.prideRainbow) {
      return AppLocalizations.of(context)!.prideRainbow;
    } else if (value == AppIcon.prideRainbowLine) {
      return AppLocalizations.of(context)!.prideRainbowLine;
    } else if (value == AppIcon.prideTrans) {
      return AppLocalizations.of(context)!.prideTrans;
    } else if (value == AppIcon.prideRomania) {
      return AppLocalizations.of(context)!.prideRomania;
    } else if (value == AppIcon.purple) {
      return AppLocalizations.of(context)!.lust;
    } else if (value == AppIcon.deepPurple) {
      return AppLocalizations.of(context)!.deepPurple;
    } else if (value == AppIcon.red) {
      return AppLocalizations.of(context)!.lipstick;
    } else if (value == AppIcon.sexapill) {
      return AppLocalizations.of(context)!.sexapill;
    } else if (value == AppIcon.teal) {
      return AppLocalizations.of(context)!.shimapan;
    } else if (value == AppIcon.white) {
      return AppLocalizations.of(context)!.white;
    }
    return AppLocalizations.of(context)!.defaultAppIcon;
  }

  static String getAppColorSchemeTranslation(AppColorScheme? value) {
    GetIt locator = GetIt.instance;
    BuildContext context =
        locator<NavigationService>().navigatorKey.currentContext!;

    if (value == AppColorScheme.black) {
      return AppLocalizations.of(context)!.black;
    } else if (value == AppColorScheme.dynamic) {
      return AppLocalizations.of(context)!.dynamicColorScheme;
    } else if (value == AppColorScheme.blue) {
      return AppLocalizations.of(context)!.blue;
    } else if (value == AppColorScheme.pink) {
      return AppLocalizations.of(context)!.love;
    } else if (value == AppColorScheme.purple) {
      return AppLocalizations.of(context)!.lust;
    } else if (value == AppColorScheme.red) {
      return AppLocalizations.of(context)!.lipstick;
    } else if (value == AppColorScheme.teal) {
      return AppLocalizations.of(context)!.shimapan;
    }
    return AppLocalizations.of(context)!.defaultColorScheme;
  }

  static String? emptyStringToNull(String? value) {
    if (value != null) {
      return value.isEmpty ? null : value;
    }
    return null;
  }

  String get theme {
    return _settings.theme;
  }

  set theme(String value) {
    _settings.theme = value;
    _storage.setSettings(_settings);
    notifyListeners();
  }

  AppColorScheme? get colorScheme {
    return _settings.colorScheme;
  }

  set colorScheme(AppColorScheme? value) {
    _settings.colorScheme = value;
    _storage.setSettings(_settings);
    notifyListeners();
  }

  String? get accessToken {
    return _settings.accessToken;
  }

  set accessToken(String? value) {
    _settings.accessToken = value;
    _storage.setSettings(_settings);
    notifyListeners();
  }

  String? get refreshToken {
    return _settings.refreshToken;
  }

  set refreshToken(String? value) {
    _settings.refreshToken = value;
    _storage.setSettings(_settings);
    notifyListeners();
  }

  List<Activity> get activity {
    return _activity;
  }

  set activity(List<Activity> value) {
    _activity = value;
    _storage.setActivity(value);
    notifyListeners();
  }

  List<Partner> get partners {
    return _partners;
  }

  set partners(List<Partner> value) {
    _partners = value;
    _storage.setPartners(value);
    notifyListeners();
  }

  bool get privacyMode {
    return _settings.privacyMode;
  }

  set privacyMode(bool value) {
    _settings.privacyMode = value;
    _storage.setSettings(_settings);
    notifyListeners();
  }

  bool get sensitiveMode {
    return _settings.sensitiveMode;
  }

  set sensitiveMode(bool value) {
    _settings.sensitiveMode = value;
    _storage.setSettings(_settings);
    notifyListeners();
  }

  bool get requireAuth {
    return _settings.requireAuth;
  }

  set requireAuth(bool value) {
    _settings.requireAuth = value;
    _storage.setSettings(_settings);
    notifyListeners();
  }

  bool get calendarView {
    return _settings.calendarView;
  }

  set calendarView(bool value) {
    _settings.calendarView = value;
    _storage.setSettings(_settings);
    notifyListeners();
  }

  String? get activityFilter {
    return _settings.activityFilter;
  }

  set activityFilter(String? value) {
    _settings.activityFilter = value;
    _storage.setSettings(_settings);
    notifyListeners();
  }

  AppIcon? get appIcon {
    return getAppIconByValue(_settings.appIcon);
  }

  set appIcon(AppIcon? value) {
    _settings.appIcon = setValueByAppIcon(value);
    _storage.setSettings(_settings);
    notifyListeners();
  }

  bool get authorized {
    return _localAuth.authorized;
  }

  set authorized(bool value) {
    _localAuth.authorized = value;
    notifyListeners();
  }

  bool get isAuthenticating {
    return _localAuth.isAuthenticating;
  }

  set isAuthenticating(bool value) {
    _localAuth.isAuthenticating = value;
    notifyListeners();
  }

  List<Widget> get statistics {
    return _statistics;
  }

  set statistics(List<Widget> value) {
    _statistics = value;
    notifyListeners();
  }

  bool get protected {
    return _protected;
  }

  set protected(bool value) {
    _protected = value;
    notifyListeners();
  }

  bool get material {
    return _settings.material;
  }

  set material(bool value) {
    _settings.material = value;
    _storage.setSettings(_settings);
    notifyListeners();
  }

  bool get trueBlack {
    return _settings.trueBlack;
  }

  set trueBlack(bool value) {
    _settings.trueBlack = value;
    _storage.setSettings(_settings);
    notifyListeners();
  }
}
