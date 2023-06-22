import 'package:flutter/material.dart';
import 'package:lovelust/service_locator.dart';

import 'app.dart';

void main() {
  setupServiceLocator();
  runApp(const App());
}
