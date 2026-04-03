import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/question.dart';
import 'my_questions_provider.dart';
import 'search_provider.dart';
import 'status_filter_provider.dart';

final adminQuestionsFutureProvider =
    Provider.autoDispose<AsyncValue<List<Question>>>((ref) {
      final search = ref.watch(searchProvider).trim();
      final statusFilter = ref.watch(questionStatusFilterProvider);
      final questionsAsync = ref.watch(questionsStreamProvider);

      final bool? isActiveFilter = switch (statusFilter) {
        QuestionStatusFilter.all => null,
        QuestionStatusFilter.active => true,
        QuestionStatusFilter.inactive => false,
      };

      return questionsAsync.whenData((questions) {
        final normalizedSearch = search.toLowerCase();
        final filtered = questions.where((question) {
          if (isActiveFilter != null && question.isActive != isActiveFilter) {
            return false;
          }

          if (normalizedSearch.isEmpty) {
            return true;
          }

          final askerText = question.askerText.toLowerCase();
          final answerText = (question.answerText ?? '').toLowerCase();
          return askerText.contains(normalizedSearch) ||
              answerText.contains(normalizedSearch);
        }).toList();

        filtered.sort((a, b) {
          final aDate =
              DateTime.tryParse(a.createdAt)?.toUtc() ??
              DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
          final bDate =
              DateTime.tryParse(b.createdAt)?.toUtc() ??
              DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
          return bDate.compareTo(aDate);
        });

        return filtered;
      });
    });
