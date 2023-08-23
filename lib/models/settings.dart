import 'package:lovelust/models/enum.dart';
import 'package:lovelust/services/shared_service.dart';

class Settings {
  String theme;
  AppColorScheme? colorScheme;
  bool material;
  bool trueBlack;
  bool privacyMode;
  bool requireAuth;
  bool calendarView;
  String? activityFilter;
  String? accessToken;
  String? refreshToken;

  Settings({
    required this.theme,
    required this.colorScheme,
    required this.material,
    required this.trueBlack,
    required this.privacyMode,
    required this.requireAuth,
    required this.calendarView,
    required this.activityFilter,
    this.accessToken,
    this.refreshToken,
  });

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      theme: json['theme'],
      colorScheme: SharedService.getAppColorSchemeByValue(json['colorScheme']),
      material: json['material'],
      trueBlack: json['trueBlack'],
      privacyMode: json['privacyMode'],
      requireAuth: json['requireAuth'],
      calendarView: json['calendarView'],
      activityFilter: json['activityFilter'],
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
    );
  }

  Map<String, dynamic> toJson() => {
        'theme': theme,
        'colorScheme': SharedService.setValueByAppColorScheme(colorScheme),
        'material': material,
        'trueBlack': trueBlack,
        'privacyMode': privacyMode,
        'requireAuth': requireAuth,
        'calendarView': calendarView,
        'activityFilter': activityFilter,
        'accessToken': accessToken,
        'refreshToken': refreshToken,
      };
}

Settings defaultSettings = Settings(
  theme: 'system',
  colorScheme: null,
  material: false,
  trueBlack: false,
  privacyMode: false,
  requireAuth: false,
  calendarView: false,
  activityFilter: null,
);
