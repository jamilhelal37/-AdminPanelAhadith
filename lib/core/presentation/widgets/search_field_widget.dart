import 'package:flutter/material.dart';

class SearchFieldWidget extends StatelessWidget {
  const SearchFieldWidget({
    super.key,
    required this.onChanged,
    this.hintText,
    this.controller,
    this.compact = false,
  });

  final ValueChanged<String> onChanged;
  final String? hintText;
  final TextEditingController? controller;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final radius = compact ? 10.0 : 12.0;
    final fontSize = compact ? 13.0 : 14.0;
    final iconSize = compact ? 20.0 : 24.0;
    final verticalPadding = compact ? 10.0 : 14.0;

    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText ?? 'ابحث عن الفتاوى الشرعية',
        hintStyle: TextStyle(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          fontSize: fontSize,
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.outline.withAlpha(100),
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.outline.withAlpha(100),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 1,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: compact ? 12 : 16,
          vertical: verticalPadding,
        ),
        prefixIcon: Icon(
          Icons.search,
          color: Theme.of(context).colorScheme.primary,
          size: iconSize,
        ),
      ),
    );
  }
}
