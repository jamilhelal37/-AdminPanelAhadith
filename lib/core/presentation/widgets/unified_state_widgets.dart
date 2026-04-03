import 'package:flutter/material.dart';

import 'empty_state_widget.dart';

class UnifiedLoadingState extends StatelessWidget {
  const UnifiedLoadingState({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(
            color: Theme.of(context).colorScheme.primary,
          ),
          if (message != null) ...[
            const SizedBox(height: 12),
            Text(message!, style: const TextStyle(fontSize: 14)),
          ],
        ],
      ),
    );
  }
}

class UnifiedErrorState extends StatelessWidget {
  const UnifiedErrorState({
    super.key,
    required this.title,
    this.message,
    this.onRetry,
  });

  final String title;
  final String? message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final composed = message == null ? title : '$title\n$message';
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: EmptyStateWidget(
            message: composed,
            assetPath: 'assets/images/under_construction.json',
          ),
        ),
        if (onRetry != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('إعادة المحاولة'),
            ),
          ),
      ],
    );
  }
}

class UnifiedEmptyState extends StatelessWidget {
  const UnifiedEmptyState({
    super.key,
    required this.title,
    this.subtitle,
    this.assetPath = 'assets/no_data.json',
    this.action,
  });

  final String title;
  final String? subtitle;
  final String assetPath;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final composed = subtitle == null ? title : '$title\n$subtitle';
    return Column(
      children: [
        Expanded(
          child: EmptyStateWidget(message: composed, assetPath: assetPath),
        ),
        if (action != null)
          Padding(padding: const EdgeInsets.only(bottom: 24), child: action!),
      ],
    );
  }
}


