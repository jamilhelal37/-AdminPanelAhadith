import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../../core/presentation/widgets/core_actions_widget.dart'
    show CoreActionsWidget;
import '../../../../core/presentation/widgets/golden_drawer.dart';
import '../../../../core/presentation/widgets/golden_form_fields.dart';
import '../../../../core/services/speech_to_text_service.dart';
import '../../../../router.dart';
import '../../../search_history/presentation/providers/search_history_provider.dart';
import '../../../search_history/presentation/widgets/search_history_suggestions.dart';
import '../../../books/domain/models/book.dart';
import '../../../books/presentation/providers/admin_book_future_provider.dart';
import '../../../muhaddiths/domain/models/muhaddith.dart';
import '../../../muhaddiths/presentation/providers/muhaddith_future_provider.dart';
import '../../../rawis/domain/models/rawi.dart';
import '../../../rawis/presentation/providers/admin_rawi_future_provider.dart';
import '../../../ruling/domain/models/ruling.dart';
import '../../../ruling/presentation/providers/ruling_future_provider.dart';
import '../../../topics/domain/models/topic.dart';
import '../../../topics/presentation/providers/topic_future_provider.dart';
import '../../application/search_results_args_mapper.dart';

const _allFilterValue = '__all__';

final advancedSearchFormProvider = Provider<FormGroup>((ref) {
  return FormGroup({
    'searchQuery': FormControl<String>(value: ''),
    'rawiIds': FormControl<List<String>>(value: const [_allFilterValue]),
    'muhaddithIds': FormControl<List<String>>(value: const [_allFilterValue]),
    'topicIds': FormControl<List<String>>(value: const [_allFilterValue]),
    'bookIds': FormControl<List<String>>(value: const [_allFilterValue]),
    'rulingIds': FormControl<List<String>>(value: const [_allFilterValue]),
    'searchScopes': FormControl<List<String>>(value: const [_allFilterValue]),
    'searchMode': FormControl<String>(value: 'any'),
  });
});

class AdvancedSearchScreen extends ConsumerStatefulWidget {
  const AdvancedSearchScreen({super.key});

  @override
  ConsumerState<AdvancedSearchScreen> createState() =>
      _AdvancedSearchScreenState();
}

class _AdvancedSearchScreenState extends ConsumerState<AdvancedSearchScreen> {
  bool _isExpanded = true;
  bool _isListening = false;
  bool _voiceSearchSubmitted = false;
  late final FocusNode _searchFocusNode = FocusNode()
    ..addListener(() {
      if (mounted) setState(() {});
    });
  final SpeechToTextService _speechService = SpeechToTextService();

  @override
  void initState() {
    super.initState();
    _applyDefaultFilters(ref.read(advancedSearchFormProvider));
  }

  @override
  void dispose() {
    _speechService.cancel();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _applyDefaultFilters(FormGroup form) {
    form.control('searchScopes').value = const [_allFilterValue];
    form.control('bookIds').value = const [_allFilterValue];
    form.control('muhaddithIds').value = const [_allFilterValue];
    form.control('rawiIds').value = const [_allFilterValue];
    form.control('rulingIds').value = const [_allFilterValue];
    form.control('topicIds').value = const [_allFilterValue];
  }

  @override
  Widget build(BuildContext context) {
    final form = ref.watch(advancedSearchFormProvider);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      endDrawer: const GoldenAppDrawer(),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'البحث المتقدم',
        ),
        centerTitle: true,
        actions: const [CoreActionsWidget()],
      ),
      body: ReactiveForm(
        formGroup: form,
        child: SafeArea(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 12),
              child: _buildSearchAndFiltersPanel(form),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchAndFiltersPanel(FormGroup form) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 28),
        const SizedBox(height: 12),
        GoldenSearchField(
          formControlName: 'searchQuery',
          hintText: 'مثلا: صدقة',
          onSearch: _performSearch,
          onClear: _clearSearch,
          onVoiceTap: _toggleVoiceSearch,
          isListening: _isListening,
          focusNode: _searchFocusNode,
        ),
        const SizedBox(height: 14),
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
                  isHadith: true,
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
                  padding: const EdgeInsets.only(bottom: 14),
                  child: SearchHistorySuggestions(
                    items: items,
                    showRecentTitle: query.isEmpty,
                    onSelect: _applySuggestion,
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
        _buildFiltersPanel(form),
      ],
    );
  }

  Widget _buildFiltersPanel(FormGroup form) {
    final booksAsync = ref.watch(adminBooksFutureProvider);
    final muhaddithsAsync = ref.watch(adminMuhaddithFutureProvider);
    final rawisAsync = ref.watch(adminRawisFutureProvider);
    final rulingsAsync = ref.watch(adminRulingsFutureProvider);
    final topicsAsync = ref.watch(adminTopicsFutureProvider);
    final cs = Theme.of(context).colorScheme;

    return Column(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: cs.surface,
                  ),
                  child: Icon(Icons.tune_rounded, color: cs.primary, size: 22),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'فلترة متقدمة :',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                  ),
                ),
                Icon(
                  _isExpanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: cs.primary,
                  size: 28,
                ),
              ],
            ),
          ),
        ),
        if (_isExpanded) ...[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Divider(
              height: 1,
              color: cs.primary.withValues(alpha: 0.12),
            ),
          ),
          _buildSearchModeSelector(form),
          const SizedBox(height: 12),
          _buildSearchScopeDropdown(),
          const SizedBox(height: 12),
          booksAsync.when(
            data: _buildBookDropdown,
            loading: () => const SizedBox.shrink(),
            error: (_, _) => const SizedBox.shrink(),
          ),
          const SizedBox(height: 12),
          muhaddithsAsync.when(
            data: _buildMuhaddithDropdown,
            loading: () => const SizedBox.shrink(),
            error: (_, _) => const SizedBox.shrink(),
          ),
          const SizedBox(height: 12),
          rawisAsync.when(
            data: _buildRawiDropdown,
            loading: () => const SizedBox.shrink(),
            error: (_, _) => const SizedBox.shrink(),
          ),
          const SizedBox(height: 12),
          rulingsAsync.when(
            data: _buildRulingDropdown,
            loading: () => const SizedBox.shrink(),
            error: (_, _) => const SizedBox.shrink(),
          ),
          const SizedBox(height: 12),
          topicsAsync.when(
            data: _buildTopicDropdown,
            loading: () => const SizedBox.shrink(),
            error: (_, _) => const SizedBox.shrink(),
          ),
          const SizedBox(height: 16),
          _buildSearchActionButton(),
        ],
      ],
    );
  }

  Widget _buildSearchScopeDropdown() {
    final scopes = [
      {'value': _allFilterValue, 'label': 'الجميع'},
      {'value': 'marfu', 'label': 'مرفوع'},
      {'value': 'mawquf', 'label': 'موقوف'},
      {'value': 'qudsi', 'label': 'قدسي'},
      {
        'value': 'atharSahaba',
        'label': 'آثار الصحابة',
      },
    ];

    return GoldenMultiSelectDropdown<String>(
      formControlName: 'searchScopes',
      labelText: 'نطاق البحث',
      hintText: 'اختر نطاق البحث',
      icon: Icons.category,
      allOptionValue: _allFilterValue,
      enableSelectAll: false,
      items: scopes
          .map(
            (scope) => GoldenMultiSelectItem<String>(
              value: scope['value']!,
              label: scope['label']!,
            ),
          )
          .toList(),
    );
  }

  Widget _buildSearchModeSelector(FormGroup form) {
    final cs = Theme.of(context).colorScheme;

    return ReactiveValueListenableBuilder<String>(
      formControlName: 'searchMode',
      builder: (context, control, child) {
        final searchMode = control.value ?? 'any';

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.manage_search_rounded, color: cs.primary),
                  const SizedBox(width: 8),
                  Text(
                    'طريقة البحث',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _buildSearchModeOption(
                      label: 'بحث مرن',
                      icon: Icons.auto_awesome_rounded,
                      isSelected: searchMode == 'any',
                      onTap: () => form.control('searchMode').value = 'any',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildSearchModeOption(
                      label: 'بحث مطابق',
                      icon: Icons.done_all_rounded,
                      isSelected: searchMode == 'all',
                      onTap: () => form.control('searchMode').value = 'all',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                searchMode == 'any'
                    ? 'بحث مرن: يبحث بأي كلمة من الكلمات المدخلة.'
                    : 'بحث مطابق: يبحث بكل الكلمات المدخلة معاً.',
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchModeOption({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final cs = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: isSelected
                ? cs.primary.withValues(alpha: 0.12)
                : cs.surfaceContainerHighest.withValues(alpha: 0.28),
            border: Border.all(
              color: isSelected
                  ? cs.primary.withValues(alpha: 0.28)
                  : cs.outlineVariant.withValues(alpha: 0.55),
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: cs.primary.withValues(alpha: 0.07),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? cs.primary.withValues(alpha: 0.16)
                      : cs.surface,
                ),
                child: Icon(
                  icon,
                  color: isSelected ? cs.primary : cs.onSurfaceVariant,
                  size: 16,
                ),
              ),
              const SizedBox(width: 6),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchActionButton() {
    final cs = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _performSearch,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          width: double.infinity,
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            color: cs.primary.withValues(alpha: 0.12),
            border: Border.all(color: cs.primary.withValues(alpha: 0.16)),
            boxShadow: [
              BoxShadow(
                color: cs.primary.withValues(alpha: 0.08),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.manage_search_rounded, color: cs.primary, size: 22),
              const SizedBox(width: 8),
              Text(
                'البحث حسب الفلاتر المحددة',
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookDropdown(List<Book> books) {
    return GoldenMultiSelectDropdown<String>(
      formControlName: 'bookIds',
      labelText: 'الكتب',
      hintText: 'اختر الكتب',
      icon: Icons.menu_book,
      allOptionValue: _allFilterValue,
      enableSelectAll: false,
      items: [
        const GoldenMultiSelectItem<String>(
          value: _allFilterValue,
          label: 'الجميع',
        ),
        ...books
            .where((book) => book.id != null)
            .map(
              (book) => GoldenMultiSelectItem<String>(
                value: book.id!,
                label: book.name,
              ),
            ),
      ],
    );
  }

  Widget _buildRawiDropdown(List<Rawi> rawis) {
    return GoldenMultiSelectDropdown<String>(
      formControlName: 'rawiIds',
      labelText: 'الرواة',
      hintText: 'اختر الرواة',
      icon: Icons.person,
      allOptionValue: _allFilterValue,
      enableSelectAll: false,
      items: [
        const GoldenMultiSelectItem<String>(
          value: _allFilterValue,
          label: 'الجميع',
        ),
        ...rawis
            .where((rawi) => rawi.id != null)
            .map(
              (rawi) => GoldenMultiSelectItem<String>(
                value: rawi.id!,
                label: rawi.name,
              ),
            ),
      ],
    );
  }

  Widget _buildMuhaddithDropdown(List<Muhaddith> muhaddiths) {
    return GoldenMultiSelectDropdown<String>(
      formControlName: 'muhaddithIds',
      labelText: 'المحدثين',
      hintText: 'اختر المحدثين',
      icon: Icons.record_voice_over,
      allOptionValue: _allFilterValue,
      enableSelectAll: false,
      items: [
        const GoldenMultiSelectItem<String>(
          value: _allFilterValue,
          label: 'الجميع',
        ),
        ...muhaddiths
            .where((muhaddith) => muhaddith.id != null)
            .map(
              (muhaddith) => GoldenMultiSelectItem<String>(
                value: muhaddith.id!,
                label: muhaddith.name,
              ),
            ),
      ],
    );
  }

  Widget _buildRulingDropdown(List<Ruling> rulings) {
    return GoldenMultiSelectDropdown<String>(
      formControlName: 'rulingIds',
      labelText: 'الأحكام',
      hintText: 'اختر الأحكام',
      icon: Icons.gavel,
      allOptionValue: _allFilterValue,
      enableSelectAll: false,
      items: [
        const GoldenMultiSelectItem<String>(
          value: _allFilterValue,
          label: 'الجميع',
        ),
        ...rulings
            .where((ruling) => ruling.id != null)
            .map(
              (ruling) => GoldenMultiSelectItem<String>(
                value: ruling.id!,
                label: ruling.name,
              ),
            ),
      ],
    );
  }

  Widget _buildTopicDropdown(List<Topic> topics) {
    return GoldenMultiSelectDropdown<String>(
      formControlName: 'topicIds',
      labelText: 'الموضوعات',
      hintText: 'اختر موضوعات',
      icon: Icons.topic,
      allOptionValue: _allFilterValue,
      enableSelectAll: false,
      items: [
        const GoldenMultiSelectItem<String>(
          value: _allFilterValue,
          label: 'الجميع',
        ),
        ...topics
            .where((topic) => topic.id != null)
            .map(
              (topic) => GoldenMultiSelectItem<String>(
                value: topic.id!,
                label: topic.name,
              ),
            ),
      ],
    );
  }

  Future<void> _performSearch() async {
    FocusScope.of(context).unfocus();
    final form = ref.read(advancedSearchFormProvider);
    final args = SearchResultsArgsMapper.fromAdvancedForm(
      title:
          'نتائج البحث المتقدم',
      searchQuery: form.control('searchQuery').value as String?,
      searchMode: form.control('searchMode').value as String?,
      rawiIds: form.control('rawiIds').value as List<String>?,
      muhaddithIds: form.control('muhaddithIds').value as List<String>?,
      topicIds: form.control('topicIds').value as List<String>?,
      bookIds: form.control('bookIds').value as List<String>?,
      rulingIds: form.control('rulingIds').value as List<String>?,
      types: form.control('searchScopes').value as List<String>?,
    );

    if (args == null) return;

    await ref
        .read(searchHistoryRepositoryProvider)
        .saveQuery(query: args.searchQuery, isHadith: true);

    if (!mounted) return;

    context.pushNamed(AppRouteNames.searchResults, extra: args);
  }

  void _clearSearch() {
    ref.read(advancedSearchFormProvider).control('searchQuery').value = '';
  }

  void _applySuggestion(String suggestion) {
    ref.read(advancedSearchFormProvider).control('searchQuery').value =
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
        (ref.read(advancedSearchFormProvider).control('searchQuery').value
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

    final form = ref.read(advancedSearchFormProvider);
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

    final form = ref.read(advancedSearchFormProvider);
    final query = (form.control('searchQuery').value as String? ?? '').trim();
    if (query.isEmpty) return;

    _voiceSearchSubmitted = true;
    _performSearch();
  }
}



