class CommentAuthorProfile {
  const CommentAuthorProfile({
    required this.id,
    required this.name,
    this.avatarUrl,
  });

  final String id;
  final String name;
  final String? avatarUrl;
}
