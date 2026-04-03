import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/presentation/widgets/core_actions_widget.dart';
import '../../../../core/presentation/widgets/golden_drawer.dart';

class HadithOriginScreen extends StatelessWidget {
  const HadithOriginScreen({super.key, required this.originText});

  final String originText;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      endDrawer: const GoldenAppDrawer(),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        foregroundColor: colorScheme.onSurface,
        title: Text(
          'أصل الحديث',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.primary),
          onPressed: () => context.pop(),
        ),
        actions: const [CoreActionsWidget()],
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            color: colorScheme.surface,
            elevation: 0,
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: colorScheme.outlineVariant.withValues(alpha: 0.8),
              ),
              borderRadius: BorderRadius.circular(14.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      Icon(
                        Icons.account_tree_outlined,
                        color: colorScheme.primary,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'نص السند الكامل :',
                        style: TextStyle(fontSize: 16, height: 1.5),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), border: Border.all(color: Theme.of(context).colorScheme.outline, width: 1), color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.35)),
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      originText,
                      style: TextStyle(fontSize: 16, height: 1.5),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}



