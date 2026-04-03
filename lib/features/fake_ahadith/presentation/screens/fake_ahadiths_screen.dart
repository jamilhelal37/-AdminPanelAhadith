import 'dart:async';

import 'package:ahadith/core/presentation/widgets/core_actions_widget.dart';
import 'package:ahadith/core/presentation/widgets/golden_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../../core/presentation/widgets/golden_form_fields.dart';
import '../../../../core/services/speech_to_text_service.dart';
import '../../../ahadith/presentation/widgets/search_empty_state.dart';
import '../../../search_history/presentation/providers/search_history_provider.dart';
import '../../../search_history/presentation/widgets/search_history_suggestions.dart';
import '../../data/repositories/fakeahadith_repositories_provider.dart';
import '../../domain/models/fake_ahadith.dart';
import '../widgets/fake_hadith_card_widget.dart';

final userFakeAhadithsFutureProvider = FutureProvider<List<FakeAhadith>>((
  ref,
) async {
  final repo = ref.read(fakeAhadithRepositoryProvider);
  return repo.getFakeAhadiths(null);
});

class FakeAhadithScreen extends ConsumerStatefulWidget {
  const FakeAhadithScreen({super.key, this.notificationFakeHadithId});

  final String? notificationFakeHadithId;

  @override
  ConsumerState<FakeAhadithScreen> createState() => _FakeAhadithScreenState();
}

class _FakeAhadithScreenState extends ConsumerState<FakeAhadithScreen> {
  late final FormGroup _searchForm;
  StreamSubscription<Object?>? _searchSubscription;
  late final FocusNode _searchFocusNode = FocusNode()
    ..addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  final SpeechToTextService _speechService = SpeechToTextService();

  bool _isListening = false;
  bool _voiceSearchSubmitted = false;
  bool _hasAppliedNotificationSearch = false;
  String? _notificationAutofillQuery;
  String? _expandedNotificationFakeHadithId;

  FormControl<String> get _searchControl =>
      _searchForm.control('searchQuery') as FormControl<String>;

  String get _searchQuery => (_searchControl.value ?? '').trim().toLowerCase();

  @override
  void initState() {
    super.initState();
    _searchForm = FormGroup({'searchQuery': FormControl<String>(value: '')});
    _searchSubscription = _searchForm.valueChanges.listen((_) {
      final currentQuery = (_searchControl.value ?? '').trim().toLowerCase();
      final notificationQuery = _notificationAutofillQuery
          ?.trim()
          .toLowerCase();
      if (notificationQuery != null && currentQuery != notificationQuery) {
        _expandedNotificationFakeHadithId = null;
      }
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void didUpdateWidget(covariant FakeAhadithScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.notificationFakeHadithId != widget.notificationFakeHadithId) {
      _hasAppliedNotificationSearch = false;
      _notificationAutofillQuery = null;
      _expandedNotificationFakeHadithId = null;
    }
  }

  @override
  void dispose() {
    _searchSubscription?.cancel();
    _speechService.cancel();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fakeAhadithsAsync = ref.watch(userFakeAhadithsFutureProvider);
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      endDrawer: const GoldenAppDrawer(),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        actions: const [CoreActionsWidget()],
        title: const Text(
          'أحاديث منتشرة لا تصح',
        ),
        centerTitle: true,
        backgroundColor: cs.surface,
        foregroundColor: cs.primary,
        iconTheme: IconThemeData(color: cs.onSurface),
      ),
      body: ReactiveForm(
        formGroup: _searchForm,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: fakeAhadithsAsync.when(
            data: (items) {
              _applyNotificationSearchIfNeeded(items);

              final filtered =
                  items.where((item) {
                    final textMatches =
                        _searchQuery.isEmpty ||
                        item.text.toLowerCase().contains(_searchQuery);

                    return textMatches;
                  }).toList()..sort((a, b) {
                    final aDate = DateTime.tryParse(a.createdAt);
                    final bDate = DateTime.tryParse(b.createdAt);
                    if (aDate != null && bDate != null) {
                      return bDate.compareTo(aDate);
                    }
                    return b.createdAt.compareTo(a.createdAt);
                  });

              return Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                    decoration: BoxDecoration(
                      color: cs.surface.withValues(alpha: 0.72),
                      border: Border(
                        bottom: BorderSide(
                          color: cs.outlineVariant.withValues(alpha: 0.35),
                        ),
                      ),
                    ),
                    child: Column(
                      children: [
                        _buildSearchAndFiltersPanel(context),
                        if (_searchQuery.isNotEmpty) ...[
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'عدد النتائج: ${filtered.length}',
                              style: TextStyle(fontSize: 16, height: 1.5),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Expanded(
                    child: filtered.isEmpty
                        ? _buildEmptyState(context)
                        : Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: cs.surface.withValues(alpha: 0.25),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16),
                              ),
                            ),
                            child: ListView.builder(
                              padding: const EdgeInsets.fromLTRB(
                                16,
                                12,
                                16,
                                16,
                              ),
                              itemCount: filtered.length,
                              itemBuilder: (context, index) {
                                final item = filtered[index];
                                return FakeHadithCard(
                                  fakeHadith: item,
                                  serialNumber: index + 1,
                                  showFullText:
                                      item.id != null &&
                                      item.id ==
                                          _expandedNotificationFakeHadithId,
                                );
                              },
                            ),
                          ),
                  ),
                ],
              );
            },
            loading: () =>
                Center(child: CircularProgressIndicator(color: cs.primary)),
            error: (error, stack) => Center(
              child: Text(
                'تعذر تحميل الأحاديث في الوقت الحالي',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _applyNotificationSearchIfNeeded(List<FakeAhadith> items) {
    if (_hasAppliedNotificationSearch) return;

    final notificationFakeHadithId = widget.notificationFakeHadithId?.trim();
    if (notificationFakeHadithId == null || notificationFakeHadithId.isEmpty) {
      _hasAppliedNotificationSearch = true;
      return;
    }

    FakeAhadith? target;
    for (final item in items) {
      if (item.id == notificationFakeHadithId) {
        target = item;
        break;
      }
    }

    if (target == null) {
      _hasAppliedNotificationSearch = true;
      return;
    }

    _hasAppliedNotificationSearch = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final query = target?.text.trim() ?? '';
      _notificationAutofillQuery = query;
      _expandedNotificationFakeHadithId = target?.id;
      _searchControl.value = query;
      FocusScope.of(context).unfocus();
      setState(() {});
    });
  }

  Widget _buildSearchAndFiltersPanel(BuildContext context) {
    return Column(
      children: [
        GoldenSearchField(
          formControlName: 'searchQuery',
          hintText:
              'ابحث في نص الحديث',
          onSearch: _submitSearch,
          onClear: () {
            _searchControl.value = '';
          },
          onVoiceTap: _toggleVoiceSearch,
          isListening: _isListening,
          focusNode: _searchFocusNode,
        ),
        ReactiveValueListenableBuilder<String>(
          formControlName: 'searchQuery',
          builder: (context, control, child) {
            final query = (control.value ?? '').trim();
            if (!_searchFocusNode.hasFocus) {
              return const SizedBox.shrink();
            }

            final suggestionsAsync = ref.watch(
              searchHistorySuggestionsProvider(
                SearchHistoryLookupArgs(
                  query: query,
                  isHadith: false,
                  limit: query.isEmpty ? 5 : 8,
                ),
              ),
            );

            return suggestionsAsync.when(
              data: (items) {
                if (items.isEmpty) {
                  return const SizedBox.shrink();
                }

                return Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: SearchHistorySuggestions(
                    items: items,
                    onSelect: _applySuggestion,
                    showRecentTitle: query.isEmpty,
                    onDelete: _deleteSuggestion,
                    onClearAll: _clearAllSuggestions,
                  ),
                );
              },
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
            );
          },
        ),
      ],
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

    await _speechService.startListening(
      onResult: (recognizedWords, isFinal) {
        _searchControl.value = recognizedWords;
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

  Future<void> _submitSearch() async {
    FocusScope.of(context).unfocus();
    final query = (_searchControl.value ?? '').trim();
    if (query.isEmpty) return;

    await ref
        .read(searchHistoryRepositoryProvider)
        .saveQuery(query: query, isHadith: false);
  }

  Future<void> _applySuggestion(String suggestion) async {
    _searchControl.value = suggestion;
    await _submitSearch();
  }

  Future<void> _deleteSuggestion(String suggestion) async {
    await ref
        .read(searchHistoryRepositoryProvider)
        .deleteQuery(query: suggestion, isHadith: false);

    final currentQuery = (_searchControl.value ?? '').trim();
    ref.invalidate(
      searchHistorySuggestionsProvider(
        SearchHistoryLookupArgs(
          query: currentQuery,
          isHadith: false,
          limit: currentQuery.isEmpty ? 5 : 8,
        ),
      ),
    );
  }

  Future<void> _clearAllSuggestions() async {
    await ref.read(searchHistoryRepositoryProvider).clearAll(isHadith: false);

    final currentQuery = (_searchControl.value ?? '').trim();
    ref.invalidate(
      searchHistorySuggestionsProvider(
        SearchHistoryLookupArgs(
          query: currentQuery,
          isHadith: false,
          limit: currentQuery.isEmpty ? 5 : 8,
        ),
      ),
    );
  }

  void _submitVoiceSearchIfNeeded() {
    if (_voiceSearchSubmitted) return;

    final query = (_searchControl.value ?? '').trim();
    if (query.isEmpty) return;

    _voiceSearchSubmitted = true;
    _submitSearch();
  }

  Widget _buildEmptyState(BuildContext context) {
    return const SearchEmptyState(
      title:
          'لم يتم العثور على نتائج',
      subtitle:
          'جرّب البحث بكلمات أخرى .',
    );
  }
}


