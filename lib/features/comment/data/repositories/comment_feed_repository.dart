import '../../../ahadith/domain/models/hadith.dart';
import '../../domain/models/comment_author_profile.dart';

abstract class CommentFeedRepository {
  Future<Map<String, CommentAuthorProfile>> getAuthorProfiles(List<String> ids);

  Future<Map<String, Hadith>> getHadithMap(List<String> ids);
}
