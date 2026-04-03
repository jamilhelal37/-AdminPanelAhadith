import 'dart:math' as math;

import 'package:flutter/material.dart';


class FavoritesEmptyState extends StatefulWidget {
  const FavoritesEmptyState({
    super.key,
    required this.title,
    required this.subtitle,
    this.action,
  });

  final String title;
  final String subtitle;
  final Widget? action;

  @override
  State<FavoritesEmptyState> createState() => _FavoritesEmptyStateState();
}

class _FavoritesEmptyStateState extends State<FavoritesEmptyState>
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

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 22),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), color: Theme.of(context).colorScheme.surface, border: Border.all(color: Theme.of(context).colorScheme.outlineVariant)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    final t = _controller.value * math.pi * 2;
                    final floatUp = math.sin(t) * 8;
                    final floatDown = math.cos(t) * 7;
                    final pulse = 0.96 + (math.sin(t) + 1) * 0.04;

                    return SizedBox(
                      width: 220,
                      height: 170,
                      child: Stack(
                        alignment: Alignment.center,
                        clipBehavior: Clip.none,
                        children: [
                          Transform.scale(
                            scale: pulse,
                            child: Container(
                              width: 150,
                              height: 150,
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
                              width: 114,
                              height: 114,
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
                            width: 84,
                            height: 84,
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
                              Icons.bookmark_added_outlined,
                              size: 36,
                              color: colorScheme.primary,
                            ),
                          ),
                          Positioned(
                            top: 20 + floatUp,
                            right: 28,
                            child: const _FloatingMiniBadge(
                              icon: Icons.favorite_border_rounded,
                            ),
                          ),
                          Positioned(
                            bottom: 18 - floatDown,
                            left: 26,
                            child: const _FloatingMiniBadge(
                              icon: Icons.collections_bookmark_outlined,
                            ),
                          ),
                          Positioned(
                            top: 46 - floatDown * 0.7,
                            left: 42,
                            child: Container(
                              width: 10,
                              height: 10,
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
                const SizedBox(height: 12),
                Text(
                  widget.title,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  widget.subtitle,
                  style: TextStyle(fontSize: 16, height: 1.5),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          if (widget.action != null) ...[
            const SizedBox(height: 20),
            widget.action!,
          ],
        ],
      ),
    );
  }
}

class _FloatingMiniBadge extends StatelessWidget {
  const _FloatingMiniBadge({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: 42,
      height: 42,
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
      child: Icon(icon, color: colorScheme.primary, size: 20),
    );
  }
}


