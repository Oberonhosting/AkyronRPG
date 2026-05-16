import 'dart:io';

import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'akyron_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Em mobile: trava em paisagem (RPG combina mais), em desktop deixa livre.
  try {
    if (Platform.isAndroid || Platform.isIOS) {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      await Flame.device.fullScreen();
    }
  } catch (_) {
    // Em web/desktop Platform pode lançar — ignoramos.
  }

  runApp(const ProviderScope(child: AkyronApp()));
}
