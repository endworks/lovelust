import 'package:lovelust/models/enum.dart';
import 'package:lovelust/services/shared_service.dart';

class Settings {
  String theme;
  AppColorScheme? colorScheme;
  bool material;
  bool trueBlack;
  bool privacyMode;
  bool sensitiveMode;
  bool requireAuth;
  bool calendarView;
  String? appIcon;
  String? activityFilter;

  Settings({
    required this.theme,
    required this.colorScheme,
    required this.material,
    required this.trueBlack,
    required this.privacyMode,
    required this.sensitiveMode,
    required this.requireAuth,
    required this.calendarView,
    required this.appIcon,
    required this.activityFilter,
  });

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      theme: json['theme'],
      colorScheme: SharedService.getAppColorSchemeByValue(json['colorScheme']),
      material: json['material'],
      trueBlack: json['trueBlack'],
      privacyMode: json['privacyMode'],
      sensitiveMode: json['sensitiveMode'],
      requireAuth: json['requireAuth'],
      calendarView: json['calendarView'],
      appIcon: json['appIcon'],
      activityFilter: json['activityFilter'],
    );
  }

  Map<String, dynamic> toJson() => {
        'theme': theme,
        'colorScheme': SharedService.setValueByAppColorScheme(colorScheme),
        'material': material,
        'trueBlack': trueBlack,
        'privacyMode': privacyMode,
        'sensitiveMode': sensitiveMode,
        'requireAuth': requireAuth,
        'calendarView': calendarView,
        'appIcon': appIcon,
        'activityFilter': activityFilter,
      };
}

Settings defaultSettings = Settings(
  theme: 'system',
  colorScheme: null,
  material: false,
  trueBlack: false,
  privacyMode: false,
  sensitiveMode: false,
  requireAuth: false,
  calendarView: true,
  appIcon: null,
  activityFilter: null,
);
