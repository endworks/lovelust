import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:lovelust/app.dart';
import 'package:lovelust/service_locator.dart';

void main() {
  setupServiceLocator();
  runApp(
    Phoenix(
      child: const App(),
    ),
  );
}
