import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../ahadith/domain/models/hadith.dart';
import '../../../auth/domain/models/app_user.dart';
import '../../../auth/presentation/providers/auth_notifier_provider.dart';
import '../../data/repositories/comment_feed_repository_provider.dart';
import '../../data/repositories/comment_repository_provider.dart';
import '../../domain/models/comment.dart';
import '../../domain/models/comment_author_profile.dart';

final allCommentsStreamProvider = StreamProvider.autoDispose<List<Comment>>((
  ref,
) {
  final repo = ref.read(commentRepositoryProvider);
  return repo.getCommentsStream();
});

DateTime _parseCommentDate(String value) {
  final parsed = DateTime.tryParse(value);
  if (parsed == null) {
    return DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
  }
  return parsed.toUtc();
}

List<Comment> _sortCommentsDesc(Iterable<Comment> comments) {
  final list = comments.toList();
  list.sort(
    (a, b) => _parseCommentDate(
      b.createdAt,
    ).compareTo(_parseCommentDate(a.createdAt)),
  );
  return list;
}

List<String> _parseIdsKey(String idsKey) {
  return idsKey
      .split(',')
      .map((id) => id.trim())
      .where((id) => id.isNotEmpty)
      .toSet()
      .toList();
}

final commentsByHadithProvider = Provider.autoDispose
    .family<List<Comment>, String>((ref, hadithId) {
      if (hadithId.trim().isEmpty) {
        return const <Comment>[];
      }

      final comments = ref.watch(allCommentsStreamProvider).valueOrNull;
      if (comments == null || comments.isEmpty) {
        return const <Comment>[];
      }

      return _sortCommentsDesc(
        comments.where((comment) => comment.hadithId == hadithId),
      );
    });

final ownScholarCommentByHadithProvider = Provider.autoDispose
    .family<Comment?, String>((ref, hadithId) {
      final currentUser = ref.watch(authNotifierProvider).valueOrNull;
      if (currentUser?.type != UserType.scholar) {
        return null;
      }

      final userId = currentUser?.id;
      if (userId == null || userId.isEmpty) {
        return null;
      }

      final comments = ref.watch(commentsByHadithProvider(hadithId));
      for (final comment in comments) {
        if (comment.userId == userId) {
          return comment;
        }
      }
      return null;
    });

final myScholarCommentsProvider = Provider.autoDispose<List<Comment>>((ref) {
  final currentUser = ref.watch(authNotifierProvider).valueOrNull;
  if (currentUser?.type != UserType.scholar) {
    return const <Comment>[];
  }

  final userId = currentUser?.id;
  if (userId == null || userId.isEmpty) {
    return const <Comment>[];
  }

  final comments = ref.watch(allCommentsStreamProvider).valueOrNull;
  if (comments == null || comments.isEmpty) {
    return const <Comment>[];
  }

  return _sortCommentsDesc(
    comments.where((comment) => comment.userId == userId),
  );
});

final commentAuthorsByIdsProvider = FutureProvider.autoDispose
    .family<Map<String, CommentAuthorProfile>, String>((ref, idsKey) async {
      final ids = _parseIdsKey(idsKey);
      if (ids.isEmpty) {
        return const <String, CommentAuthorProfile>{};
      }

      final repo = ref.read(commentFeedRepositoryProvider);
      return repo.getAuthorProfiles(ids);
    });

final hadithMapByIdsProvider = FutureProvider.autoDispose
    .family<Map<String, Hadith>, String>((ref, idsKey) async {
      final ids = _parseIdsKey(idsKey);
      if (ids.isEmpty) {
        return const <String, Hadith>{};
      }

      final repo = ref.read(commentFeedRepositoryProvider);
      return repo.getHadithMap(ids);
    });
