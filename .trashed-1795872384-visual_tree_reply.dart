import 'package:flutter/material.dart';
import '../models/thread_model.dart';

class VisualTreeReply extends StatelessWidget {
  final ReplyItem item;
  final Function(String author) onDoubleTapReply;

  const VisualTreeReply({
    super.key,
    required this.item,
    required this.onDoubleTapReply,
  });

  Color _getLineColor(int depth) {
    switch (depth % 3) {
      case 0:
        return const Color(0xFF06B6D4); // Cyan
      case 1:
        return const Color(0xFFA855F7); // Purple
      default:
        return const Color(0xFF10B981); // Emerald
    }
  }

  @override
  Widget build(BuildContext context) {
    final lineColor = _getLineColor(item.depth);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Depth indents with tree lines
          if (item.depth > 0)
            Row(
              children: List.generate(item.depth, (i) {
                return Container(
                  width: 20,
                  margin: const EdgeInsets.only(right: 6),
                  alignment: Alignment.center,
                  child: Container(
                    width: 2.2,
                    decoration: BoxDecoration(
                      color: _getLineColor(i).withOpacity(0.65),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              }),
            ),

          // Main reply card
          Expanded(
            child: GestureDetector(
              onDoubleTap: () => onDoubleTapReply(item.author),
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF161F30),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: lineColor.withOpacity(0.35),
                    width: 1.2,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 13,
                          backgroundColor: lineColor.withOpacity(0.2),
                          child: Text(
                            item.author[0],
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: lineColor),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          item.author,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: item.badgeColor.withOpacity(0.18),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            item.role.toUpperCase(),
                            style: TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.bold,
                              color: item.badgeColor,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(item.time, style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.content,
                      style: const TextStyle(fontSize: 13, height: 1.42, color: Color(0xFFE5E7EB)),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.favorite_border, size: 14, color: Color(0xFF9CA3AF)),
                        const SizedBox(width: 4),
                        Text('${item.likes}', style: const TextStyle(fontSize: 11, color: Color(0xFF9CA3AF))),
                        const SizedBox(width: 16),
                        const Icon(Icons.reply, size: 14, color: Color(0xFF9CA3AF)),
                        const SizedBox(width: 4),
                        const Text('Double tap to reply', style: TextStyle(fontSize: 10, color: Color(0xFF6B7280))),
                      ],
                    ),
                    // Child replies nested recursively
                    if (item.replies.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      ...item.replies.map((child) => VisualTreeReply(
                            item: child,
                            onDoubleTapReply: onDoubleTapReply,
                          )),
                    ]
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
