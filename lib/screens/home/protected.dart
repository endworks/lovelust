import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/local_auth_service.dart';
import 'package:lovelust/services/shared_service.dart';
import 'package:lovelust/widgets/no_content.dart';

class ProtectedPage extends StatefulWidget {
  const ProtectedPage({super.key});

  @override
  State<ProtectedPage> createState() => _ProtectedPageState();
}

class _ProtectedPageState extends State<ProtectedPage> {
  final SharedService _shared = getIt<SharedService>();
  final LocalAuthService _localAuth = getIt<LocalAuthService>();
  IconData? _icon;
  String? _message;

  @override
  void initState() {
    super.initState();
    _shared.addListener(() {
      if (mounted) {
        setState(() {
          if (_shared.appLifecycleState == AppLifecycleState.inactive &&
              (!_localAuth.authenticationFailed ||
                  _localAuth.isAuthenticating)) {
            _icon = null;
            _message = null;
          }
        });
      }
    });
  }

  void authenticate() {
    bool needAuth = _shared.requireAuth &&
        !_shared.authorized &&
        !_localAuth.isAuthenticating &&
        !_localAuth.authenticationFailed;
    debugPrint("needAuth: $needAuth");
    if (needAuth) {
      setState(() {
        _icon = null;
        _message = null;
      });
      _localAuth
          .authenticate(AppLocalizations.of(context)!.requireAuthToAccess)
          .then((_) {
        setState(() {
          _icon = Icons.error_outline;
          _message = _localAuth.authorizedMsg;
          _shared.protected = !_shared.authorized;
        });
      });
    } else {
      FlutterNativeSplash.remove();
    }
  }

  void retryAuthenticate() {
    setState(() {
      _icon = null;
      _message = null;
      _localAuth.authenticationFailed = false;
    });
    authenticate();
  }

  @override
  Widget build(BuildContext context) {
    _localAuth.init();
    authenticate();

    return Scaffold(
        backgroundColor:
            Theme.of(context).colorScheme.background.withAlpha(128),
        body: Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 8,
                sigmaY: 8,
              ),
              child: NoContent(
                icon: _icon ?? Icons.visibility_off_outlined,
                message:
                    _message ?? AppLocalizations.of(context)!.contentHidden,
                action:
                    _localAuth.authenticationFailed ? retryAuthenticate : null,
                actionLabel: AppLocalizations.of(context)!.authRetry,
              ),
            ),
          ],
        ));
  }
}
