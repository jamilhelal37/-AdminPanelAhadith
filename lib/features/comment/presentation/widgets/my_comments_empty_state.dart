import 'dart:math' as math;

import 'package:flutter/material.dart';


class MyCommentsEmptyState extends StatefulWidget {
  const MyCommentsEmptyState({super.key});

  @override
  State<MyCommentsEmptyState> createState() => _MyCommentsEmptyStateState();
}

class _MyCommentsEmptyStateState extends State<MyCommentsEmptyState>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 3200),
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
                              width: 148,
                              height: 148,
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
                              width: 112,
                              height: 112,
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
                            width: 82,
                            height: 82,
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
                              Icons.rate_review_outlined,
                              size: 36,
                              color: colorScheme.primary,
                            ),
                          ),
                          Positioned(
                            top: 18 + floatUp,
                            right: 30,
                            child: const _FloatingMiniChip(
                              icon: Icons.mode_comment_outlined,
                            ),
                          ),
                          Positioned(
                            bottom: 20 - floatDown,
                            left: 26,
                            child: const _FloatingMiniChip(
                              icon: Icons.forum_outlined,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                Text(
                  'لا يوجد لديك تعليقات بعد',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'اضف تعليقات على الأحاديث لتظهر هنا',
                  style: TextStyle(fontSize: 16, height: 1.5),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FloatingMiniChip extends StatelessWidget {
  const _FloatingMiniChip({required this.icon});

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



