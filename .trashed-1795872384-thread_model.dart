class ReplyItem {
  final String id;
  final String author;
  final String handle;
  final String role; // 'expert', 'friend', 'creator', 'user'
  final String content;
  final String time;
  final int likes;
  final int depth;
  final Color badgeColor;
  final List<ReplyItem> replies;

  ReplyItem({
    required this.id,
    required this.author,
    required this.handle,
    required this.role,
    required this.content,
    required this.time,
    required this.likes,
    this.depth = 0,
    required this.badgeColor,
    this.replies = const [],
  });
}

class ThreadPost {
  final String id;
  final String topic;
  final String author;
  final String handle;
  final String time;
  final String corePost;
  final String aiSummary;
  final List<String> aiHighlights;
  final List<ReplyItem> allReplies;

  ThreadPost({
    required this.id,
    required this.topic,
    required this.author,
    required this.handle,
    required this.time,
    required this.corePost,
    required this.aiSummary,
    required this.aiHighlights,
    required this.allReplies,
  });
}
