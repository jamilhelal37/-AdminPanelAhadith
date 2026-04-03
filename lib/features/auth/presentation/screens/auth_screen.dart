import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/presentation/widgets/core_actions_widget.dart';
import '../providers/auth_notifier_provider.dart';
import '../providers/providers.dart';
import '../screens/post_signup_avatar_screen.dart';
import '../widgets/auth_shared_widgets.dart';
import '../widgets/login_form_widget.dart';
import '../widgets/signup_form_widget.dart';

class AuthScreen extends ConsumerWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showAvatarScreen = ref.watch(showPostSignupAvatarProvider);
    final headerBrandColor = Color.alphaBlend(
      Theme.of(context).colorScheme.primary.withValues(
        alpha: Theme.of(context).brightness == Brightness.dark ? 0.32 : 0.56,
      ),
      Theme.of(context).colorScheme.onSurface,
    );
    if (kIsWeb) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        body: AuthBackground(
          child: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final authCardWidth = constraints.maxWidth >= 680
                    ? 500.0
                    : double.infinity;

                return Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1280),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 24,
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Spacer(),
                              const CoreActionsWidget(openDrawer: false),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Center(
                                child: SizedBox(
                                  width: authCardWidth,
                                  child: const AuthCard(child: _WebLoginOnly()),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: showAvatarScreen
            ? PostSignupAvatarScreen(
                onCompleted: () {
                  ref.read(showPostSignupAvatarProvider.notifier).state = false;
                },
              )
            : AuthBackground(
                child: SafeArea(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final isWide = constraints.maxWidth >= 980;

                      return Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1240),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 28,
                              vertical: 24,
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            'assets/images/pic1.png',
                                            width: 48,
                                            height: 48,
                                            fit: BoxFit.contain,
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              'الموسوعة الحديثية',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.w700,
                                                    color: headerBrandColor,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    CoreActionsWidget(
                                      openDrawer: false,
                                      iconColor: headerBrandColor,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: isWide
                                        ? Center(
                                            child: SizedBox(
                                              width: 450,
                                              child: const AuthCard(
                                                child: _AuthTabs(),
                                              ),
                                            ),
                                          )
                                        : Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              const AuthCard(
                                                child: _AuthTabs(),
                                              ),
                                            ],
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
      ),
    );
  }
}

class _WebLoginOnly extends ConsumerWidget {
  const _WebLoginOnly();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final warmInnerSurface = Color.alphaBlend(
      cs.primaryContainer.withValues(alpha: 0.14),
      cs.surface,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'تسجيل دخول الإدارة',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 8),
        Text(
          'استخدم حساب المشرف للوصول إلى لوحة التحكم الخاصة بالويب.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            height: 1.55,
          ),
        ),
        const SizedBox(height: 20),
        AuthGoogleButton(
          onPressed: () async {
            try {
              await ref.read(authNotifierProvider.notifier).googleAuth();
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(e.toString())));
              }
            }
          },
        ),
        const SizedBox(height: 16),
        AuthSectionDivider(label: ' أو عبر البريد الإلكتروني '),
        const SizedBox(height: 16),
        DecoratedBox(
          decoration: BoxDecoration(
            color: warmInnerSurface,
            borderRadius: BorderRadius.circular(22),
          ),
          child: const Padding(
            padding: EdgeInsets.fromLTRB(14, 10, 14, 14),
            child: LoginFormWidget(onSwitchToSignup: null),
          ),
        ),
      ],
    );
  }
}

class _AuthTabs extends ConsumerStatefulWidget {
  const _AuthTabs();

  @override
  ConsumerState<_AuthTabs> createState() => _AuthTabsState();
}

class _AuthTabsState extends ConsumerState<_AuthTabs> {
  TabController? _controller;
  int _tabIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final controller = DefaultTabController.of(context);
    if (_controller == controller) return;

    _controller?.removeListener(_handleTabChanged);
    _controller = controller;
    _tabIndex = controller.index;
    _controller?.addListener(_handleTabChanged);
  }

  @override
  void dispose() {
    _controller?.removeListener(_handleTabChanged);
    super.dispose();
  }

  void _handleTabChanged() {
    final controller = _controller;
    if (controller == null || controller.indexIsChanging) return;
    if (_tabIndex == controller.index) return;
    setState(() {
      _tabIndex = controller.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final controller = _controller ?? DefaultTabController.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'سجّل الدخول أو أنشئ حسابًا جديدًا للمتابعة داخل التطبيق.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: cs.onSurfaceVariant,
            height: 1.55,
          ),
        ),
        const SizedBox(height: 20),
        AuthGoogleButton(
          onPressed: () async {
            try {
              await ref.read(authNotifierProvider.notifier).googleAuth();
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(e.toString())));
              }
            }
          },
        ),
        const SizedBox(height: 16),
        AuthSectionDivider(label: ' أو عبر البريد الإلكتروني '),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: cs.surfaceContainerHighest.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(14),
          ),
          child: TabBar(
            dividerColor: Colors.transparent,
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: BoxDecoration(
              color: cs.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            labelColor: cs.onPrimaryContainer,
            unselectedLabelColor: cs.onSurface.withValues(alpha: 0.6),
            tabs: [
              Tab(text: 'تسجيل الدخول'),
              Tab(text: 'إنشاء حساب'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeOutCubic,
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: SizeTransition(
                sizeFactor: animation,
                axisAlignment: -1,
                child: child,
              ),
            );
          },
          child: KeyedSubtree(
            key: ValueKey(_tabIndex),
            child: _tabIndex == 0
                ? LoginFormWidget(
                    onSwitchToSignup: () => controller.animateTo(1),
                    showBottomSwitchAction: false,
                  )
                : SignupFormWidget(
                    onSwitchToLogin: () => controller.animateTo(0),
                    showBottomSwitchAction: false,
                  ),
          ),
        ),
      ],
    );
  }
}
