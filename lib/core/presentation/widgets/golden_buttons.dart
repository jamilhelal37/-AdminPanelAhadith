import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Golden Button Widget - زر بالتصميم الذهبي
class GoldenButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final IconData? icon;
  final bool isSmall;

  const GoldenButton({
    super.key,
    required this.text,
    this.onTap,
    this.width,
    this.height,
    this.icon,
    this.isSmall = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width ?? (isSmall ? 120 : 160),
        height: height ?? (isSmall ? 60 : 80),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), border: Border.all(color: Theme.of(context).colorScheme.outline, width: 1), color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.35)),
        child: Center(
          child: icon != null
              ? Directionality(
                  textDirection: TextDirection.rtl,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icon, color: cs.secondary, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          text,
                          style: TextStyle(fontSize: 18),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                )
              : Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(text, style: TextStyle(fontSize: 18)),
                ),
        ),
      ),
    );
  }
}

/// Golden Menu Button - زر القائمة الذهبي
class GoldenMenuButton extends StatelessWidget {
  final VoidCallback? onTap;

  const GoldenMenuButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(color: cs.outline),
          borderRadius: BorderRadius.circular(12),
          color: cs.primaryContainer,
        ),
        child: Icon(Icons.menu, color: cs.primary),
      ),
    );
  }
}

/// Golden Back Button - زر الرجوع الذهبي
class GoldenBackButton extends StatelessWidget {
  final VoidCallback? onTap;

  const GoldenBackButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap ?? () => context.pop(),
      child: SizedBox(
        height: 50,
        width: 50,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: cs.primaryContainer.withValues(alpha: 0.3),
          ),
          child: Icon(Icons.arrow_back, color: cs.primary),
        ),
      ),
    );
  }
}

/// Golden Icon Button - أيقونة دائرية ذهبية
class GoldenIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final double? size;
  final Color? color;
  final Color? backgroundColor;

  const GoldenIconButton({
    super.key,
    required this.icon,
    this.onTap,
    this.size,
    this.color,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      child: Container(
        width: size ?? 50,
        height: size ?? 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgroundColor ?? cs.primaryContainer.withValues(alpha: 0.35),
          border: Border.all(color: cs.outline.withValues(alpha: 0.4)),
        ),
        child: Icon(icon, color: color ?? cs.primary, size: (size ?? 50) * 0.5),
      ),
    );
  }
}

/// Golden Chip/Tag Widget
class GoldenChip extends StatelessWidget {
  final String text;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool isSelected;

  const GoldenChip({
    super.key,
    required this.text,
    this.icon,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? cs.primaryContainer
              : cs.primaryContainer.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(
            color: isSelected ? cs.outline : cs.outline.withValues(alpha: 0.6),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: cs.primary),
              const SizedBox(width: 4),
            ],
            Text(
              text,
              style: TextStyle(
                fontSize: 12,
                color: cs.primary,
                fontFamily: Theme.of(context).textTheme.bodyMedium?.fontFamily,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Golden Loading Indicator
class GoldenLoadingIndicator extends StatelessWidget {
  final String? message;

  const GoldenLoadingIndicator({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(cs.primary),
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: TextStyle(fontSize: 16, height: 1.5),
              textDirection: TextDirection.rtl,
            ),
          ],
        ],
      ),
    );
  }
}



