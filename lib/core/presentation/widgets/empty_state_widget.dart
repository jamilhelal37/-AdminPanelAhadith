import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({
    super.key,
    this.message,
    this.assetPath = 'assets/no_data.json',
    this.padding,
  });

  final String? message;
  final String assetPath;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: padding ?? EdgeInsets.all(32),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              assetPath,
              width: 200,
              height: 200,
              fit: BoxFit.contain,
              repeat: true,
            ),
            if (message != null) ...[
              SizedBox(height: 16),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  message!,
                  style: TextStyle(
                    fontSize: 16,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
