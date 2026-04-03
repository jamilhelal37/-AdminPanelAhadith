import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../../core/presentation/widgets/core_actions_widget.dart';
import '../../../../core/presentation/widgets/golden_drawer.dart';
import '../../../../core/presentation/widgets/golden_form_fields.dart';
import '../../../../core/services/speech_to_text_service.dart';
import '../../../../router.dart';
import '../../../search_history/presentation/providers/search_history_provider.dart';
import '../../../search_history/presentation/widgets/search_history_suggestions.dart';
import '../models/search_results_args.dart';

final generalSearchFormProvider = Provider<FormGroup>((ref) {
  return FormGroup({'searchQuery': FormControl<String>(value: '')});
});

class GeneralSearchScreen extends ConsumerStatefulWidget {
  const GeneralSearchScreen({super.key});

  @override
  ConsumerState<GeneralSearchScreen> createState() =>
      _GeneralSearchScreenState();
}

class _GeneralSearchScreenState extends ConsumerState<GeneralSearchScreen>
    with SingleTickerProviderStateMixin {
  bool _isListening = false;
  bool _voiceSearchSubmitted = false;
  late final FocusNode _searchFocusNode = FocusNode()
    ..addListener(() {
      if (mounted) setState(() {});
    });
  final SpeechToTextService _speechService = SpeechToTextService();
  late final AnimationController _emptyAnimationController =
      AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 3200),
      )..repeat();

  @override
  void dispose() {
    _speechService.cancel();
    _searchFocusNode.dispose();
    _emptyAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final form = ref.watch(generalSearchFormProvider);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      endDrawer: const GoldenAppDrawer(),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('البحث العام'),
        centerTitle: true,
        actions: const [CoreActionsWidget()],
      ),
      body: ReactiveForm(
        formGroup: form,
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 28),
              Directionality(
                textDirection: TextDirection.rtl,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: GoldenSearchField(
                    formControlName: 'searchQuery',
                    hintText:
                        'مثلا: إنما الأعمال بالنيات',
                    onSearch: _performSearch,
                    onClear: _clearSearch,
                    onVoiceTap: _toggleVoiceSearch,
                    isListening: _isListening,
                    focusNode: _searchFocusNode,
                  ),
                ),
              ),
              ReactiveValueListenableBuilder<String>(
                formControlName: 'searchQuery',
                builder: (context, control, child) {
                  final query = (control.value ?? '').trim();
                  if (!_searchFocusNode.hasFocus) {
                    return const SizedBox(height: 12);
                  }

                  final suggestionsAsync = ref.watch(
                    searchHistorySuggestionsProvider(
                      SearchHistoryLookupArgs(
                        query: query,
                        isHadith: true,
                        limit: query.isEmpty ? 5 : 8,
                      ),
                    ),
                  );

                  return suggestionsAsync.when(
                    data: (items) {
                      if (items.isEmpty) {
                        return const SizedBox(height: 12);
                      }

                      return Padding(
                        padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
                        child: SearchHistorySuggestions(
                          items: items,
                          showRecentTitle: query.isEmpty,
                          onSelect: _applySuggestion,
                          onDelete: _deleteSuggestion,
                          onClearAll: _clearAllSuggestions,
                        ),
                      );
                    },
                    loading: () => const SizedBox(height: 12),
                    error: (_, _) => const SizedBox(height: 12),
                  );
                },
              ),
              Expanded(
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: _buildInitialState(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInitialState() {
    final colorScheme = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 22),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), color: Theme.of(context).colorScheme.surface, border: Border.all(color: Theme.of(context).colorScheme.outlineVariant)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedBuilder(
                      animation: _emptyAnimationController,
                      builder: (context, child) {
                        final t = _emptyAnimationController.value * math.pi * 2;
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
                                  Icons.search_rounded,
                                  size: 36,
                                  color: colorScheme.primary,
                                ),
                              ),
                              Positioned(
                                top: 18 + floatUp,
                                right: 30,
                                child: const _FloatingSearchMiniChip(
                                  icon: Icons.auto_awesome_rounded,
                                ),
                              ),
                              Positioned(
                                bottom: 20 - floatDown,
                                left: 26,
                                child: const _FloatingSearchMiniChip(
                                  icon: Icons.menu_book_rounded,
                                ),
                              ),
                              Positioned(
                                top: 44 - floatDown * 0.7,
                                left: 44,
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
                      'اكتب عبارة لإجراء بحث مطابق',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'في جميع الأحاديث النبوية',
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

  Future<void> _performSearch() async {
    FocusScope.of(context).unfocus();
    final form = ref.read(generalSearchFormProvider);
    final query = (form.control('searchQuery').value as String? ?? '').trim();

    if (query.isEmpty) return;

    await ref
        .read(searchHistoryRepositoryProvider)
        .saveQuery(query: query, isHadith: true);

    if (!mounted) return;

    context.pushNamed(
      AppRouteNames.searchResults,
      extra: SearchResultsArgs(
        title: 'نتائج البحث',
        searchQuery: query,
        searchMode: 'all',
      ),
    );
  }

  void _clearSearch() {
    ref.read(generalSearchFormProvider).control('searchQuery').value = '';
  }

  void _applySuggestion(String suggestion) {
    ref.read(generalSearchFormProvider).control('searchQuery').value =
        suggestion;
    _performSearch();
  }

  Future<void> _deleteSuggestion(String suggestion) async {
    await ref
        .read(searchHistoryRepositoryProvider)
        .deleteQuery(query: suggestion, isHadith: true);

    ref.invalidate(searchHistorySuggestionsProvider(_currentLookupArgs()));
  }

  Future<void> _clearAllSuggestions() async {
    await ref.read(searchHistoryRepositoryProvider).clearAll(isHadith: true);

    ref.invalidate(searchHistorySuggestionsProvider(_currentLookupArgs()));
  }

  SearchHistoryLookupArgs _currentLookupArgs() {
    final query =
        (ref.read(generalSearchFormProvider).control('searchQuery').value
                    as String? ??
                '')
            .trim();

    return SearchHistoryLookupArgs(
      query: query,
      isHadith: true,
      limit: query.isEmpty ? 5 : 8,
    );
  }

  Future<void> _toggleVoiceSearch() async {
    if (_isListening) {
      await _speechService.stop();
      if (!mounted) return;
      setState(() => _isListening = false);
      _submitVoiceSearchIfNeeded();
      return;
    }

    FocusScope.of(context).unfocus();
    _voiceSearchSubmitted = false;

    final available = await _speechService.initialize(
      onStatus: _handleSpeechStatus,
      onError: _handleSpeechError,
    );

    if (!available) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'تعذر تفعيل البحث الصوتي على هذا الجهاز',
          ),
        ),
      );
      return;
    }

    final form = ref.read(generalSearchFormProvider);
    await _speechService.startListening(
      onResult: (recognizedWords, isFinal) {
        form.control('searchQuery').value = recognizedWords;
        if (isFinal) {
          _submitVoiceSearchIfNeeded();
        }
      },
    );

    if (!mounted) return;
    setState(() => _isListening = true);
  }

  void _handleSpeechStatus(String status) {
    if (!mounted) return;

    setState(() => _isListening = status == 'listening');

    if (status == 'done' || status == 'notListening') {
      _submitVoiceSearchIfNeeded();
    }
  }

  void _handleSpeechError(String message) {
    if (!mounted) return;
    setState(() => _isListening = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'تعذر إكمال البحث الصوتي: $message',
        ),
      ),
    );
  }

  void _submitVoiceSearchIfNeeded() {
    if (_voiceSearchSubmitted) return;

    final form = ref.read(generalSearchFormProvider);
    final query = (form.control('searchQuery').value as String? ?? '').trim();
    if (query.isEmpty) return;

    _voiceSearchSubmitted = true;
    _performSearch();
  }
}

class _FloatingSearchMiniChip extends StatelessWidget {
  const _FloatingSearchMiniChip({required this.icon});

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




