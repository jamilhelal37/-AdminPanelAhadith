import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:reactive_forms/reactive_forms.dart';


class GoldenSearchField extends StatelessWidget {
  final String formControlName;
  final String? hintText;
  final VoidCallback? onSearch;
  final VoidCallback? onClear;
  final VoidCallback? onVoiceTap;
  final bool showSearchIcon;
  final bool showClearIcon;
  final bool isListening;
  final TextDirection textDirection;
  final Color? backgroundColor;
  final Color? fillColor;
  final FocusNode? focusNode;

  const GoldenSearchField({
    super.key,
    required this.formControlName,
    this.hintText,
    this.onSearch,
    this.onClear,
    this.onVoiceTap,
    this.showSearchIcon = true,
    this.showClearIcon = true,
    this.isListening = false,
    this.textDirection = TextDirection.rtl,
    this.backgroundColor,
    this.fillColor,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final resolvedBackground =
        (isDark ? null : backgroundColor) ??
        (isDark
            ? cs.surface.withValues(alpha: 0.92)
            : cs.surface.withValues(alpha: 0.96));
    final resolvedFill =
        (isDark ? null : fillColor) ??
        (isDark
            ? cs.surfaceContainerHighest.withValues(alpha: 0.35)
            : cs.primaryContainer.withValues(alpha: 0.08));

    return Container(
      decoration: BoxDecoration(
        color: resolvedBackground,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark
              ? cs.outlineVariant.withValues(alpha: 0.55)
              : cs.primary.withValues(alpha: 0.22),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.28)
                : cs.primary.withValues(alpha: 0.1),
            blurRadius: isDark ? 12 : 16,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.12 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ReactiveTextField<String>(
        formControlName: formControlName,
        focusNode: focusNode,
        textDirection: textDirection,
        cursorColor: cs.primary,
        textInputAction: TextInputAction.search,
        style: TextStyle(fontSize: 16, height: 1.5),
        onSubmitted: (_) => onSearch?.call(),
        decoration: InputDecoration(
          hintText: hintText ?? 'مثلا: صدقة',
          hintStyle: TextStyle(fontSize: 14),
          hintTextDirection: TextDirection.rtl,
          contentPadding: const EdgeInsetsDirectional.fromSTEB(0, 17, 14, 17),
          prefixIcon: showSearchIcon
              ? Padding(
                  padding: const EdgeInsetsDirectional.only(start: 10, end: 6),
                  child: _buildSearchAction(
                    context,
                    icon: CupertinoIcons.search,
                    onTap: onSearch,
                  ),
                )
              : null,
          prefixIconConstraints: const BoxConstraints(
            minWidth: 0,
            minHeight: 0,
          ),
          suffixIcon: ReactiveValueListenableBuilder<String>(
            formControlName: formControlName,
            builder: (context, control, child) {
              final hasValue = control.value?.isNotEmpty == true;
              final showVoiceButton = onVoiceTap != null;
              final showClearButton = showClearIcon && hasValue;

              if (!showClearButton && !showVoiceButton) {
                return const SizedBox.shrink();
              }

              return Padding(
                padding: const EdgeInsetsDirectional.only(start: 6, end: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (showClearButton)
                      _buildSearchAction(
                        context,
                        icon: Icons.close_rounded,
                        onTap: () {
                          control.value = '';
                          onClear?.call();
                        },
                      ),
                    if (showVoiceButton) ...[
                      if (showClearButton) const SizedBox(width: 6),
                      _buildSearchAction(
                        context,
                        icon: isListening
                            ? Icons.mic_rounded
                            : Icons.mic_none_rounded,
                        onTap: onVoiceTap,
                        isActive: isListening,
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
          suffixIconConstraints: const BoxConstraints(
            minWidth: 0,
            minHeight: 0,
          ),
          filled: true,
          fillColor: resolvedFill,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(22),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(22),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(22),
            borderSide: BorderSide(
              color: cs.primary.withValues(alpha: 0.72),
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchAction(
    BuildContext context, {
    required IconData icon,
    required VoidCallback? onTap,
    bool isActive = false,
  }) {
    final cs = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: isActive
                ? cs.primary.withValues(alpha: 0.18)
                : cs.primaryContainer.withValues(alpha: 0.24),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isActive
                  ? cs.primary.withValues(alpha: 0.36)
                  : cs.primary.withValues(alpha: 0.14),
            ),
          ),
          child: Icon(
            icon,
            size: 19,
            color: isActive ? cs.primary : cs.primary.withValues(alpha: 0.92),
          ),
        ),
      ),
    );
  }
}


class GoldenTextField extends StatelessWidget {
  final String formControlName;
  final String? labelText;
  final String? hintText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool isPassword;
  final int maxLines;
  final TextInputType? keyboardType;
  final TextDirection textDirection;

  const GoldenTextField({
    super.key,
    required this.formControlName,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.isPassword = false,
    this.maxLines = 1,
    this.keyboardType,
    this.textDirection = TextDirection.rtl,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ReactiveTextField<String>(
      formControlName: formControlName,
      textDirection: textDirection,
      obscureText: isPassword,
      maxLines: maxLines,
      keyboardType: keyboardType,
      cursorColor: cs.primary,
      style: const TextStyle(fontSize: 16, height: 1.5),
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        hintStyle: TextStyle(fontSize: 14),
        hintTextDirection: TextDirection.rtl,
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: cs.primary)
            : null,
        suffixIcon: suffixIcon != null
            ? Icon(suffixIcon, color: cs.primary)
            : null,
        filled: true,
        fillColor: cs.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: cs.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: cs.primary, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: cs.outline.withValues(alpha: 0.5)),
        ),
      ),
    );
  }
}


class GoldenDropdownField<T> extends StatelessWidget {
  final String formControlName;
  final String? labelText;
  final String? hintText;
  final List<DropdownMenuItem<T>> items;
  final IconData? icon;

  const GoldenDropdownField({
    super.key,
    required this.formControlName,
    required this.items,
    this.labelText,
    this.hintText,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest.withValues(alpha: 0.45),
          borderRadius: BorderRadius.circular(14.0),
        ),
        child: ReactiveDropdownField<T>(
          formControlName: formControlName,
          isExpanded: true,
          decoration: InputDecoration(
            labelText: labelText,
            hintText: hintText,
            hintStyle: const TextStyle(fontSize: 14),
            border: InputBorder.none,
            icon: icon != null ? Icon(icon, color: cs.primary) : null,
          ),
          items: items,
          dropdownColor: cs.surface,
        ),
      ),
    );
  }
}

class GoldenMultiSelectItem<T> {
  final T value;
  final String label;

  const GoldenMultiSelectItem({required this.value, required this.label});
}


class GoldenMultiSelectDropdown<T> extends StatelessWidget {
  final String formControlName;
  final String? labelText;
  final String? hintText;
  final List<GoldenMultiSelectItem<T>> items;
  final IconData? icon;
  final String? emptyText;
  final bool enableSearch;
  final bool enableSelectAll;
  final String? searchHintText;
  final String? selectAllText;
  final T? allOptionValue;

  const GoldenMultiSelectDropdown({
    super.key,
    required this.formControlName,
    required this.items,
    this.labelText,
    this.hintText,
    this.icon,
    this.emptyText,
    this.enableSearch = true,
    this.enableSelectAll = true,
    this.searchHintText,
    this.selectAllText,
    this.allOptionValue,
  });

  @override
  Widget build(BuildContext context) {
    return ReactiveFormField<List<T>, List<T>>(
      formControlName: formControlName,
      builder: (field) {
        final selected = List<T>.from(field.value ?? const []);
        final hasAllOptionInItems =
            allOptionValue != null &&
            items.any((item) => item.value == allOptionValue);

        if (hasAllOptionInItems && selected.isEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!field.control.disabled) {
              field.control.value = [allOptionValue as T];
            }
          });
        }

        final hasAll =
            allOptionValue != null && selected.contains(allOptionValue);
        final selectedLabels = items
            .where((item) => selected.contains(item.value))
            .map((item) => item.label)
            .toList();

        final allLabel = allOptionValue == null
            ? null
            : items
                  .where((item) => item.value == allOptionValue)
                  .map((item) => item.label)
                  .cast<String?>()
                  .firstWhere((_) => true, orElse: () => null);

        final displayText = hasAll && allLabel != null
            ? allLabel
            : selectedLabels.isEmpty
            ? (hintText ?? 'اختر')
            : selectedLabels.join('، ');
        final cs = Theme.of(context).colorScheme;

        return Directionality(
          textDirection: TextDirection.rtl,
          child: InkWell(
            onTap: () => _showMultiSelectSheet(context, field),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius: BorderRadius.circular(14.0),
                border: Border.all(color: cs.primary.withValues(alpha: 0.16)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  if (icon != null) ...[
                    Icon(icon, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 8),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (labelText != null)
                          Text(
                            labelText!,
                            style: TextStyle(fontSize: 14),
                          ),
                        Text(
                          displayText,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 16, height: 1.5),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.keyboard_arrow_down, color: cs.primary),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _showMultiSelectSheet(
    BuildContext context,
    ReactiveFormFieldState<List<T>, List<T>> field,
  ) async {
    final current = List<T>.from(field.value ?? const []);
    final searchController = TextEditingController();

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final cs = Theme.of(context).colorScheme;
        var tempSelected = List<T>.from(current);
        final hasAllOptionInItems =
            allOptionValue != null &&
            items.any((item) => item.value == allOptionValue);

        if (hasAllOptionInItems && tempSelected.isEmpty) {
          tempSelected = [allOptionValue as T];
        }

        return StatefulBuilder(
          builder: (context, setState) {
            void ensureValidAllSelection() {
              if (allOptionValue == null) return;

              if (tempSelected.isEmpty) {
                tempSelected = [allOptionValue as T];
                return;
              }

              if (tempSelected.contains(allOptionValue) &&
                  tempSelected.length > 1) {
                tempSelected = [allOptionValue as T];
              }
            }

            String normalize(String input) {
              return input
                  .trim()
                  .toLowerCase()
                  .replaceAll(' ', '')
                  .replaceAll('_', '')
                  .replaceAll('-', '');
            }

            final q = normalize(searchController.text);
            final filteredItems = q.isEmpty
                ? List<GoldenMultiSelectItem<T>>.from(items)
                : items.where((item) {
                    final label = normalize(item.label);
                    final value = normalize(item.value.toString());
                    return label.contains(q) || value.contains(q);
                  }).toList();

            bool isAllSelected() {
              if (items.isEmpty) return false;
              return items.every((item) => tempSelected.contains(item.value));
            }

            return SafeArea(
              child: Container(
                decoration: BoxDecoration(
                  color: cs.surface,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(28),
                  ),
                  border: Border.all(color: cs.primary.withValues(alpha: 0.1)),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          labelText ?? 'اختيار متعدد',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                        ),
                        IconButton(
                          onPressed: () => context.pop(),
                          icon: Icon(Icons.close),
                        ),
                      ],
                    ),
                    if (enableSearch) ...[
                      const SizedBox(height: 8),
                      TextField(
                        controller: searchController,
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          hintText: searchHintText ?? 'ابحث...',
                          prefixIcon: Icon(Icons.search, color: cs.primary),
                          filled: false,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                              color: cs.primary.withValues(alpha: 0.45),
                              width: 1.2,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                              color: cs.primary.withValues(alpha: 0.45),
                              width: 1.2,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                              color: cs.primary,
                              width: 1.8,
                            ),
                          ),
                        ),
                      ),
                    ],
                    if (enableSelectAll) ...[
                      const SizedBox(height: 8),
                      CheckboxListTile(
                        value: isAllSelected(),
                        activeColor: cs.primary,
                        checkColor: cs.onPrimary,
                        tileColor: cs.surfaceContainerHighest.withValues(
                          alpha: 0.24,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        title: Text(
                          selectAllText ?? 'اختيار الكل',
                          style: const TextStyle(fontSize: 16, height: 1.5),
                        ),
                        onChanged: (checked) {
                          setState(() {
                            if (checked == true) {
                              tempSelected = items
                                  .map((item) => item.value)
                                  .toList();
                            } else {
                              tempSelected.clear();
                            }
                          });
                        },
                      ),
                    ],
                    const SizedBox(height: 8),
                    Flexible(
                      child: filteredItems.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(24),
                              child: Text(
                                emptyText ?? 'لا توجد عناصر',
                                style: const TextStyle(fontSize: 16, height: 1.5),
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: filteredItems.length,
                              itemBuilder: (context, index) {
                                final item = filteredItems[index];
                                final isSelected = tempSelected.contains(
                                  item.value,
                                );

                                return CheckboxListTile(
                                  value: isSelected,
                                  activeColor: cs.primary,
                                  checkColor: cs.onPrimary,
                                  tileColor: isSelected
                                      ? cs.primary.withValues(alpha: 0.09)
                                      : Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  title: Text(
                                    item.label,
                                    style: const TextStyle(fontSize: 16, height: 1.5),
                                  ),
                                  onChanged: (checked) {
                                    setState(() {
                                      if (checked == true) {
                                        if (allOptionValue != null &&
                                            item.value == allOptionValue) {
                                          tempSelected = [allOptionValue as T];
                                        } else {
                                          tempSelected.remove(allOptionValue);
                                          if (!tempSelected.contains(
                                            item.value,
                                          )) {
                                            tempSelected.add(item.value);
                                          }
                                        }
                                      } else {
                                        tempSelected.remove(item.value);
                                        ensureValidAllSelection();
                                      }
                                    });
                                  },
                                );
                              },
                            ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              if (allOptionValue != null) {
                                tempSelected = [allOptionValue as T];
                              } else {
                                tempSelected.clear();
                              }
                            });
                          },
                          child: const Text('مسح الكل'),
                        ),
                        const Spacer(),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              ensureValidAllSelection();
                              field.control.value = tempSelected;
                              field.control.markAsTouched();
                              context.pop();
                            },
                            borderRadius: BorderRadius.circular(999),
                            child: Container(
                              height: 44,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(999),
                                color: cs.primary.withValues(alpha: 0.12),
                                border: Border.all(
                                  color: cs.primary.withValues(alpha: 0.16),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: cs.primary.withValues(alpha: 0.08),
                                    blurRadius: 10,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.save_rounded,
                                    color: cs.primary,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'حفظ',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}


