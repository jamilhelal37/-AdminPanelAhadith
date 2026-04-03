import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/app_appearance_settings_provider.dart';

class ThemeDialogWidget extends ConsumerWidget {
  const ThemeDialogWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appAppearanceSettingsValueProvider);

    return AlertDialog(
      title: const Text('تغيير السمة'),
      content: RadioGroup<ThemeMode>(
        groupValue: settings.themeMode,
        onChanged: (value) async {
          await ref
              .read(appAppearanceSettingsProvider.notifier)
              .setThemeMode(value!);
          if (!context.mounted) return;
          context.pop();
        },
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<ThemeMode>(
              title: Text('فاتح'),
              value: ThemeMode.light,
            ),
            RadioListTile<ThemeMode>(
              title: Text('داكن'),
              value: ThemeMode.dark,
            ),
            RadioListTile<ThemeMode>(
              title: Text('نظام'),
              value: ThemeMode.system,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => context.pop(), child: const Text('إغلاق')),
      ],
    );
  }
}
