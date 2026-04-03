import 'package:flutter/material.dart';

class AppSplashScreen extends StatelessWidget {
  const AppSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 30,
          height: 30,
          child: CircularProgressIndicator(
            strokeWidth: 2.6,
            color: colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
