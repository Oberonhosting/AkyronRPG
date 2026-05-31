import 'dart:io';

import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'akyron_app.dart';
import 'audio/audio_director.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Em mobile: permite todas as orientações; o RotateDeviceGate vai
  // pedir (em vez de forçar) que o jogador gire o aparelho.
  try {
    if (Platform.isAndroid || Platform.isIOS) {
      await SystemChrome.setPreferredOrientations(const [
        DeviceOrientation.portraitUp,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      await Flame.device.fullScreen();
    }
  } catch (_) {
    // Em web/desktop Platform pode lançar — ignoramos.
  }

  // Inicializa o áudio. Falha silenciosamente se assets ausentes.
  await AudioDirector.instance.init();

  runApp(const ProviderScope(child: AkyronApp()));
}
