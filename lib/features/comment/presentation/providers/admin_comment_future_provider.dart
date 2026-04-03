import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/comment_repository_provider.dart';
import '../../domain/models/comment.dart';
import 'search_provider.dart';

var adminCommentsFutureProvider = FutureProvider<List<Comment>>((ref) async {
  var repo = ref.read(commentRepositoryProvider);
  var search = ref.watch(searchProvider);
  return repo.getComments(search);
});
