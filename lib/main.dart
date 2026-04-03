import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app_bootstrap.dart';
import 'app/app_widget.dart';

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    final bootstrapResult = await bootstrapApp();

    runApp(
      ProviderScope(
        overrides: bootstrapResult.overrides,
        child: const AhadithApp(),
      ),
    );
  } catch (error) {
    runApp(StartupErrorApp(message: error.toString()));
  }
}
