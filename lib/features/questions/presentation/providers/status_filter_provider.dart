import 'package:flutter_riverpod/flutter_riverpod.dart';

enum QuestionStatusFilter { all, active, inactive }

final questionStatusFilterProvider = StateProvider<QuestionStatusFilter>(
  (ref) => QuestionStatusFilter.all,
);
