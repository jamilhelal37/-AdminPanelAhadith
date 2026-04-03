import 'dart:math' as math;

import 'package:flutter/material.dart';


class SearchEmptyState extends StatefulWidget {
  const SearchEmptyState({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  State<SearchEmptyState> createState() => _SearchEmptyStateState();
}

class _SearchEmptyStateState extends State<SearchEmptyState>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 3400),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxHeight < 320;
        final badgeSize = compact ? 34.0 : 42.0;
        final artWidth = compact ? 170.0 : 220.0;
        final artHeight = compact ? 120.0 : 170.0;
        final outerCircle = compact ? 112.0 : 150.0;
        final midCircle = compact ? 88.0 : 114.0;
        final iconCircle = compact ? 66.0 : 84.0;
        final iconSize = compact ? 28.0 : 36.0;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(
                  compact ? 16 : 20,
                  compact ? 18 : 24,
                  compact ? 16 : 20,
                  compact ? 18 : 22,
                ),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), color: Theme.of(context).colorScheme.surface, border: Border.all(color: Theme.of(context).colorScheme.outlineVariant)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        final t = _controller.value * math.pi * 2;
                        final floatUp = math.sin(t) * (compact ? 5 : 8);
                        final floatDown = math.cos(t) * (compact ? 4 : 7);
                        final pulse = 0.96 + (math.sin(t) + 1) * 0.04;

                        return SizedBox(
                          width: artWidth,
                          height: artHeight,
                          child: Stack(
                            alignment: Alignment.center,
                            clipBehavior: Clip.none,
                            children: [
                              Transform.scale(
                                scale: pulse,
                                child: Container(
                                  width: outerCircle,
                                  height: outerCircle,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: colorScheme.primary.withValues(
                                      alpha: 0.07,
                                    ),
                                  ),
                                ),
                              ),
                              Transform.scale(
                                scale: 1.02 - (pulse - 0.96),
                                child: Container(
                                  width: midCircle,
                                  height: midCircle,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: colorScheme.primary.withValues(
                                      alpha: 0.12,
                                    ),
                                    border: Border.all(
                                      color: colorScheme.primary.withValues(
                                        alpha: 0.16,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: iconCircle,
                                height: iconCircle,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: colorScheme.primary.withValues(
                                    alpha: 0.14,
                                  ),
                                  border: Border.all(
                                    color: colorScheme.primary.withValues(
                                      alpha: 0.18,
                                    ),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: colorScheme.primary.withValues(
                                        alpha: 0.08,
                                      ),
                                      blurRadius: 14,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.search_off_rounded,
                                  size: iconSize,
                                  color: colorScheme.primary,
                                ),
                              ),
                              Positioned(
                                top: (compact ? 14 : 20) + floatUp,
                                right: compact ? 18 : 28,
                                child: _FloatingSearchBadge(
                                  icon: Icons.manage_search_rounded,
                                  size: badgeSize,
                                ),
                              ),
                              Positioned(
                                bottom: (compact ? 12 : 18) - floatDown,
                                left: compact ? 18 : 26,
                                child: _FloatingSearchBadge(
                                  icon: Icons.tune_rounded,
                                  size: badgeSize,
                                ),
                              ),
                              Positioned(
                                top: compact
                                    ? 32 - floatDown * 0.7
                                    : 46 - floatDown * 0.7,
                                left: compact ? 30 : 42,
                                child: Container(
                                  width: compact ? 8 : 10,
                                  height: compact ? 8 : 10,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: colorScheme.primary.withValues(
                                      alpha: 0.35,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    SizedBox(height: compact ? 8 : 12),
                    Text(
                      widget.title,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: compact ? 6 : 8),
                    Text(
                      widget.subtitle,
                      style: TextStyle(fontSize: 16, height: 1.5),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _FloatingSearchBadge extends StatelessWidget {
  const _FloatingSearchBadge({required this.icon, this.size = 42});

  final IconData icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colorScheme.surface,
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.14)),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(icon, color: colorScheme.primary, size: size * 0.48),
    );
  }
}


