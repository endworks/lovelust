import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:lovelust/models/enum.dart';

class LocalAuthService {
  final LocalAuthentication auth = LocalAuthentication();
  AuthSupportState supportState = AuthSupportState.unknown;
  bool? canCheckBiometrics;
  List<BiometricType>? availableBiometrics;
  String authorizedMsg = 'Not Authorized';
  bool isAuthenticating = false;
  bool authenticationFailed = false;
  bool authorized = false;

  void init() {
    try {
      auth.isDeviceSupported().then(
            (bool isSupported) => supportState = isSupported
                ? AuthSupportState.supported
                : AuthSupportState.unsupported,
          );
      checkBiometrics().then(
        (value) => getAvailableBiometrics().then(
          (value) => null,
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> checkBiometrics() async {
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      canCheckBiometrics = false;
      debugPrint(e.toString());
    }
  }

  Future<void> getAvailableBiometrics() async {
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      availableBiometrics = <BiometricType>[];
      debugPrint(e.toString());
    }
  }

  Future<void> authenticate(String localizedReason) async {
    bool authenticated = false;
    try {
      isAuthenticating = true;
      authorizedMsg = 'Authenticating';

      authenticated = await auth.authenticate(
        localizedReason: localizedReason,
        options: const AuthenticationOptions(
          stickyAuth: true,
        ),
      );

      authenticationFailed = false;
      isAuthenticating = false;
    } on PlatformException catch (e) {
      isAuthenticating = false;
      authenticationFailed = true;
      authorizedMsg = e.message!;
      authorized = false;
      return;
    }

    final String message = authenticated ? 'Authorized' : 'Not Authorized';
    authorized = authenticated;
    authorizedMsg = message;
  }

  Future<void> authenticateWithBiometrics() async {
    bool authenticated = false;
    try {
      isAuthenticating = true;
      authorizedMsg = 'Authenticating';

      authenticated = await auth.authenticate(
        localizedReason:
            'Scan your fingerprint (or face or whatever) to authenticate',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      isAuthenticating = false;
      authorizedMsg = 'Authenticating';
    } on PlatformException catch (e) {
      debugPrint(e.toString());

      isAuthenticating = false;
      authorizedMsg = 'Error - ${e.message}';
      authorized = false;
      return;
    }

    final String message = authenticated ? 'Authorized' : 'Not Authorized';
    authorized = authenticated;
    authorizedMsg = message;
  }

  Future<void> cancelAuthentication() async {
    await auth.stopAuthentication();
    isAuthenticating = false;
  }
}
