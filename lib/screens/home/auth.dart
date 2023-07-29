import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/local_auth_service.dart';
import 'package:lovelust/services/shared_service.dart';
import 'package:lovelust/widgets/no_content.dart';

class LocalAuthPage extends StatefulWidget {
  const LocalAuthPage({super.key});

  @override
  State<LocalAuthPage> createState() => _LocalAuthPageState();
}

class _LocalAuthPageState extends State<LocalAuthPage> {
  final SharedService _shared = getIt<SharedService>();
  final LocalAuthService _localAuth = getIt<LocalAuthService>();
  bool _authorized = false;
  bool _authenticationFailed = false;

  @override
  Widget build(BuildContext context) {
    if (_shared.requireAuth && !_authorized && !_authenticationFailed) {
      _localAuth.init();
      _localAuth.getAvailableBiometrics().then((_) {
        _localAuth.authenticate().then((_) {
          setState(() {
            _authorized = _localAuth.authorized;
            _authenticationFailed = !_localAuth.authorized;
            _shared.authorized = _localAuth.authorized;
          });
        });
      });
    } else {
      FlutterNativeSplash.remove();
    }

    return Scaffold(
      body: NoContent(
        message: _authenticationFailed
            ? AppLocalizations.of(context)!.authFailed
            : '',
      ),
    );
  }
}
