// @dart=2.16

import 'dart:ui' as ui;

import 'package:flutter_applicationdemo/main.dart' as entrypoint;

Future<void> main() async {
  await ui.webOnlyInitializePlatform();
  entrypoint.main();
}
