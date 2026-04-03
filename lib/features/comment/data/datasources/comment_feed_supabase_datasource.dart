import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../ahadith/domain/models/hadith.dart';
import '../../domain/models/comment_author_profile.dart';
import '../repositories/comment_feed_repository.dart';

class CommentFeedSupabaseDatasource implements CommentFeedRepository {
  CommentFeedSupabaseDatasource({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  @override
  Future<Map<String, CommentAuthorProfile>> getAuthorProfiles(
    List<String> ids,
  ) async {
    if (ids.isEmpty) {
      return const <String, CommentAuthorProfile>{};
    }

    try {
      final response = await _client
          .from('app_user')
          .select('id,name,avatar_url')
          .inFilter('id', ids);

      final rows = (response as List).cast<Map<String, dynamic>>();
      final mapped = <String, CommentAuthorProfile>{};

      for (final row in rows) {
        final id = row['id']?.toString();
        if (id == null || id.isEmpty) {
          continue;
        }

        final name = row['name']?.toString().trim();
        final avatarUrl = row['avatar_url']?.toString().trim();

        mapped[id] = CommentAuthorProfile(
          id: id,
          name: (name == null || name.isEmpty) ? 'عالم' : name,
          avatarUrl: (avatarUrl == null || avatarUrl.isEmpty)
              ? null
              : avatarUrl,
        );
      }

      return mapped;
    } catch (error) {
      throw AppFailure.network(
        'تعذر تحميل بيانات كُتّاب التعليقات.',
        details: error.toString(),
      );
    }
  }

  @override
  Future<Map<String, Hadith>> getHadithMap(List<String> ids) async {
    if (ids.isEmpty) {
      return const <String, Hadith>{};
    }

    try {
      final response = await _client
          .from('ahadith')
          .select('''
            *,
            explaining_rel:explaining(text),
            rawi_rel:rawi(name),
            source_rel:source(name),
            muhaddith_ruling_rel:muhaddith_ruling(name),
            final_ruling_rel:final_ruling(name)
            ''')
          .inFilter('id', ids);

      final rows = (response as List).cast<Map<String, dynamic>>();
      final mapped = <String, Hadith>{};

      for (final row in rows) {
        final hadith = Hadith.fromJson(row);
        final id = hadith.id;
        if (id == null || id.isEmpty) {
          continue;
        }
        mapped[id] = hadith;
      }

      return mapped;
    } catch (error) {
      throw AppFailure.network(
        'تعذر تحميل بيانات الأحاديث المرتبطة.',
        details: error.toString(),
      );
    }
  }
}
