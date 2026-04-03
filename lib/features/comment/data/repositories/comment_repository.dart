import '../../domain/models/comment.dart';

abstract class CommentRepository {
  Future<List<Comment>> getComments(String? searchQuery);
  Future<Comment> createComment(Comment comment);
  Future<Comment> updateComment(Comment comment);
  Future<void> deleteComment(String id);
  Stream<List<Comment>> getCommentsStream();
}
