import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../datasources/comment_feed_supabase_datasource.dart';
import 'comment_feed_repository.dart';

final commentFeedRepositoryProvider = Provider<CommentFeedRepository>((ref) {
  return CommentFeedSupabaseDatasource();
});
