import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

class AuthBackground extends StatelessWidget {
  const AuthBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.alphaBlend(cs.primary.withValues(alpha: 0.14), cs.surface),
            Color.alphaBlend(
              cs.primaryContainer.withValues(alpha: 0.28),
              cs.surface,
            ),
            Color.alphaBlend(
              cs.tertiaryContainer.withValues(alpha: 0.35),
              cs.surface,
            ),
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -140,
            left: -110,
            child: _GlowBlob(
              size: 300,
              color: cs.primary.withValues(alpha: 0.16),
            ),
          ),
          Positioned(
            top: 110,
            right: 90,
            child: _GlowBlob(
              size: 180,
              color: cs.secondary.withValues(alpha: 0.12),
            ),
          ),
          Positioned(
            bottom: -150,
            right: -120,
            child: _GlowBlob(
              size: 320,
              color: cs.tertiary.withValues(alpha: 0.15),
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withValues(alpha: 0.10),
                      Colors.transparent,
                      Colors.white.withValues(alpha: 0.06),
                    ],
                  ),
                ),
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class _GlowBlob extends StatelessWidget {
  const _GlowBlob({this.size = 220, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [BoxShadow(color: color, blurRadius: 120, spreadRadius: 24)],
      ),
    );
  }
}

class AuthBrandPanel extends StatelessWidget {
  const AuthBrandPanel({
    super.key,
    this.badge = 'بوابة الإدارة',
    this.title = 'بوابة ويب مخصصة لإدارة الموسوعة الحديثية',
    this.description =
        'وصول واضح وسريع إلى إدارة المحتوى، الإشعارات، والطلبات ضمن واجهة مرتبة تناسب الشاشات الكبيرة.',
    this.highlights = const [
      'تنقل أوضح بين أقسام الإدارة',
      'إرسال إشعارات ومتابعة الطلبات بسرعة',
      'واجهة مريحة للشاشات الكبيرة',
    ],
    this.showVisualHero = false,
  });

  final String badge;
  final String title;
  final String description;
  final List<String> highlights;
  final bool showVisualHero;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: cs.surface.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.35)),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.06),
            blurRadius: 30,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showVisualHero) ...[
            const _AuthVisualHero(),
            const SizedBox(height: 22),
          ],
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
            decoration: BoxDecoration(
              color: cs.primary.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              badge,
              style: textTheme.labelLarge?.copyWith(
                color: cs.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            title,
            style: textTheme.headlineMedium?.copyWith(
              height: 1.2,
              fontWeight: FontWeight.w900,
              color: cs.onSurface,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            description,
            style: textTheme.bodyLarge?.copyWith(
              color: cs.onSurfaceVariant,
              height: 1.7,
            ),
          ),
          const SizedBox(height: 24),
          ...highlights.map(
            (highlight) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _BrandHighlight(text: highlight),
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  cs.surface,
                  cs.primaryContainer.withValues(alpha: 0.45),
                ],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: cs.outlineVariant.withValues(alpha: 0.32),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: const [
                    Expanded(
                      child: _MetricCard(
                        title: 'إدارة أسرع',
                        value: 'ويب',
                        icon: Icons.speed_rounded,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _MetricCard(
                        title: 'هوية متناسقة',
                        value: 'واجهة',
                        icon: Icons.auto_awesome_mosaic_rounded,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cs.surface.withValues(alpha: 0.86),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: cs.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          Icons.admin_panel_settings_outlined,
                          color: cs.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'تسجيل دخول مخصص للإدارة على الويب مع تجربة أوضح للشاشات الكبيرة.',
                          style: textTheme.bodyMedium?.copyWith(
                            color: cs.onSurfaceVariant,
                            height: 1.55,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AuthWebShowcasePanel extends StatefulWidget {
  const AuthWebShowcasePanel({super.key});

  @override
  State<AuthWebShowcasePanel> createState() => _AuthWebShowcasePanelState();
}

class _AuthWebShowcasePanelState extends State<AuthWebShowcasePanel>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 3600),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(34),
      decoration: BoxDecoration(
        color: const Color(0xFFF7E0B0),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.35)),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.06),
            blurRadius: 30,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final t = _controller.value * math.pi * 2;
              final floatY = math.sin(t) * 10;
              final pulse = 0.98 + ((math.sin(t) + 1) * 0.035);
              const orbitRadius = 182.0;

              return Column(
                children: [
                  SizedBox(
                    height: 390,
                    width: double.infinity,
                    child: Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: [
                        Transform.scale(
                          scale: pulse,
                          child: Container(
                            width: 310,
                            height: 310,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: cs.primary.withValues(alpha: 0.06),
                            ),
                          ),
                        ),
                        Container(
                          width: 232,
                          height: 232,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: cs.surface.withValues(alpha: 0.72),
                            boxShadow: [
                              BoxShadow(
                                color: cs.primary.withValues(alpha: 0.10),
                                blurRadius: 28,
                                offset: const Offset(0, 12),
                              ),
                            ],
                          ),
                        ),
                        Transform.translate(
                          offset: Offset(0, floatY),
                          child: ShaderMask(
                            blendMode: BlendMode.srcIn,
                            shaderCallback: (bounds) => LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                const Color(0xFFE8B04B),
                                Color.alphaBlend(
                                  cs.primary.withValues(alpha: 0.55),
                                  const Color(0xFFC98A1A),
                                ),
                                const Color(0xFF8F5C0F),
                              ],
                            ).createShader(bounds),
                            child: Image.asset(
                              'assets/images/pic1.png',
                              height: 340,
                              fit: BoxFit.contain,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        ..._buildOrbitingIcons(t, orbitRadius, cs),
                      ],
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(0, floatY * 0.35),
                    child: Text(
                      'مرجع علمي موثوق على منهاج أهل السنة والجماعة',
                      textAlign: TextAlign.center,
                      style: textTheme.titleMedium?.copyWith(
                        color: Color.alphaBlend(
                          cs.primary.withValues(alpha: 0.38),
                          const Color(0xFF8F5C0F),
                        ),
                        height: 1.8,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  List<Widget> _buildOrbitingIcons(double t, double radius, ColorScheme cs) {
    final items = <({double angle, Widget child})>[
      (
        angle: -1.55,
        child: _AuthFloatingIcon(icon: Icons.login_rounded, color: cs.primary),
      ),
      (angle: -0.72, child: _AuthFeaturePill(icon: Icons.menu_book_rounded)),
      (
        angle: 0.22,
        child: _AuthFeaturePill(icon: Icons.workspace_premium_outlined),
      ),
      (
        angle: 0.98,
        child: _AuthFloatingIcon(
          icon: Icons.lock_outline_rounded,
          color: cs.primary,
        ),
      ),
      (
        angle: 1.88,
        child: _AuthFloatingIcon(
          icon: Icons.verified_user_outlined,
          color: cs.primary,
        ),
      ),
      (angle: 2.58, child: _AuthFeaturePill(icon: Icons.dashboard_outlined)),
      (
        angle: -2.92,
        child: _AuthFeaturePill(icon: Icons.notifications_active_outlined),
      ),
      (
        angle: -2.28,
        child: _AuthFloatingIcon(
          icon: Icons.admin_panel_settings_outlined,
          color: cs.primary,
        ),
      ),
    ];

    return items.map((item) {
      final x = math.cos(item.angle) * radius + math.sin(t + item.angle) * 4;
      final y = math.sin(item.angle) * radius + math.cos(t + item.angle) * 4;
      return Transform.translate(offset: Offset(x, y), child: item.child);
    }).toList();
  }
}

class _AuthFloatingIcon extends StatelessWidget {
  const _AuthFloatingIcon({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.94),
        border: Border.all(color: color.withValues(alpha: 0.14)),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.10),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Icon(icon, color: color, size: 22),
    );
  }
}

class _AuthFeaturePill extends StatelessWidget {
  const _AuthFeaturePill({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: cs.surface.withValues(alpha: 0.94),
        shape: BoxShape.circle,
        border: Border.all(color: cs.primary.withValues(alpha: 0.12)),
        boxShadow: [
          BoxShadow(
            color: cs.primary.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(icon, size: 22, color: cs.primary),
    );
  }
}

class _AuthVisualHero extends StatelessWidget {
  const _AuthVisualHero();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            cs.surface.withValues(alpha: 0.96),
            cs.primaryContainer.withValues(alpha: 0.34),
          ],
        ),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: cs.surface,
                  shape: BoxShape.circle,
                  border: Border.all(color: cs.primary.withValues(alpha: 0.18)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Image.asset(
                    'assets/images/pic1.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'الموسوعة الحديثية',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: cs.onSurface,
                          ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'عرض بصري أنيق لنسخة الويب',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: const [
              Expanded(
                child: _AuthBookCard(
                  title: 'صحيح البخاري',
                  subtitle: 'تنظيم أصيل',
                  icon: Icons.menu_book_rounded,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _AuthBookCard(
                  title: 'صحيح مسلم',
                  subtitle: 'وصول أوضح',
                  icon: Icons.auto_stories_rounded,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AuthBookCard extends StatelessWidget {
  const _AuthBookCard({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surface.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: cs.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: cs.primary),
          ),
          const SizedBox(height: 18),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w900,
              color: cs.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _BrandHighlight extends StatelessWidget {
  const _BrandHighlight({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: cs.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Icons.check_rounded, color: cs.primary, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: cs.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surface.withValues(alpha: 0.84),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: cs.primary),
          const SizedBox(height: 14),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: cs.onSurface,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatelessWidget {
  const AuthCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final warmSurface = Color.alphaBlend(
      cs.primaryContainer.withValues(alpha: 0.18),
      cs.surface,
    );

    return Material(
      elevation: 0,
      borderRadius: BorderRadius.circular(28),
      color: warmSurface.withValues(alpha: 0.96),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              warmSurface.withValues(alpha: 0.98),
              Color.alphaBlend(
                cs.primaryContainer.withValues(alpha: 0.10),
                cs.surface,
              ),
            ],
          ),
          border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.28)),
          boxShadow: [
            BoxShadow(
              color: cs.shadow.withValues(alpha: 0.07),
              blurRadius: 30,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}

class AuthSectionDivider extends StatelessWidget {
  const AuthSectionDivider({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(child: Divider(color: cs.outlineVariant)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            label,
            style: TextStyle(color: cs.onSurface.withValues(alpha: 0.6)),
          ),
        ),
        Expanded(child: Divider(color: cs.outlineVariant)),
      ],
    );
  }
}

class AuthTextField extends StatelessWidget {
  const AuthTextField({
    super.key,
    required this.formControlName,
    required this.label,
    this.keyboardType,
    this.textDirection,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.validationMessages,
    this.minLines,
    this.maxLines,
  });

  final String formControlName;
  final String label;
  final TextInputType? keyboardType;
  final TextDirection? textDirection;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Map<String, String Function(Object)>? validationMessages;
  final int? minLines;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    final effectiveMaxLines = obscureText ? 1 : (maxLines ?? 1);
    final effectiveMinLines = obscureText ? 1 : minLines;

    return ReactiveTextField<String>(
      formControlName: formControlName,
      keyboardType: keyboardType,
      textDirection: textDirection,
      obscureText: obscureText,
      minLines: effectiveMinLines,
      maxLines: effectiveMaxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
      validationMessages: validationMessages ?? const {},
    );
  }
}

class AuthPrimaryButton extends StatelessWidget {
  const AuthPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: isLoading
          ? const SizedBox(
              height: 18,
              width: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Text(label),
    );
  }
}

class AuthGoogleButton extends StatelessWidget {
  const AuthGoogleButton({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    const lightWarmBeige = Color(0xFFF1E2C9);
    const lightWarmBeigeHover = Color(0xFFE8D5B4);
    const lightWarmBeigePressed = Color(0xFFE0C79E);

    final baseBg = theme.brightness == Brightness.dark
        ? Color.alphaBlend(cs.primary.withValues(alpha: 0.24), cs.surface)
        : lightWarmBeige;
    final hoverBg = theme.brightness == Brightness.dark
        ? Color.alphaBlend(cs.primary.withValues(alpha: 0.32), cs.surface)
        : lightWarmBeigeHover;
    final pressedBg = theme.brightness == Brightness.dark
        ? Color.alphaBlend(cs.primary.withValues(alpha: 0.38), cs.surface)
        : lightWarmBeigePressed;
    final disabledBg = Color.alphaBlend(
      cs.surfaceContainerLowest.withValues(alpha: 0.88),
      cs.surface,
    );

    return OutlinedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(vertical: 14, horizontal: 14),
        ),
        minimumSize: const WidgetStatePropertyAll(Size.fromHeight(58)),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        side: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return BorderSide(color: cs.outlineVariant.withValues(alpha: 0.2));
          }
          if (states.contains(WidgetState.hovered)) {
            return BorderSide(color: cs.primary.withValues(alpha: 0.34));
          }
          if (states.contains(WidgetState.pressed)) {
            return BorderSide(color: cs.primary.withValues(alpha: 0.42));
          }
          return BorderSide(color: cs.outlineVariant.withValues(alpha: 0.3));
        }),
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) return disabledBg;
          if (states.contains(WidgetState.pressed)) return pressedBg;
          if (states.contains(WidgetState.hovered)) return hoverBg;
          return baseBg;
        }),
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return cs.primary.withValues(alpha: 0.1);
          }
          if (states.contains(WidgetState.hovered)) {
            return cs.primary.withValues(alpha: 0.06);
          }
          return null;
        }),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: cs.primary.withValues(alpha: 0.18),
            child: Text(
              'G',
              style: TextStyle(color: cs.primary, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'تسجيل الدخول عبر Google مباشرة',
              textAlign: TextAlign.center,
              maxLines: 1,
              softWrap: false,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Color.alphaBlend(
                  cs.primary.withValues(alpha: 0.42),
                  cs.onSurface,
                ),
                fontWeight: FontWeight.w500,
                fontSize: 13,
                height: 1.1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
