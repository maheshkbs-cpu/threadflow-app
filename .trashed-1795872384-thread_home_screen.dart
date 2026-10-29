import 'package:flutter/material.dart';
import '../models/thread_model.dart';
import '../widgets/ai_summary_card.dart';
import '../widgets/visual_tree_reply.dart';
import '../widgets/auto_split_composer_dialog.dart';

class ThreadHomeScreen extends StatefulWidget {
  const ThreadHomeScreen({super.key});

  @override
  State<ThreadHomeScreen> createState() => _ThreadHomeScreenState();
}

class _ThreadHomeScreenState extends State<ThreadHomeScreen> {
  String selectedFilter = 'All'; // 'All', 'Experts', 'Friends', 'Top'

  final ThreadPost sampleThread = ThreadPost(
    id: 'thread_101',
    topic: 'Next-Gen Mobile Social UX & AI Threads',
    author: 'Mahesh Gond',
    handle: '@mahesh_arch',
    time: '2h ago',
    corePost: 'मोबाइल सोशल ऐप्स में लंबे थ्रेड्स को पढ़ना बहुत थका देने वाला होता है। इसी समस्या को हल करने के लिए हमने AI Summarized Box, Visual Tree Lines और Auto-Split Composer का आर्किटेक्चर तैयार किया है। इससे पढ़ने और जवाब देने का अनुभव 10 गुना तेज हो जाता है!',
    aiSummary: 'इस थ्रेड में सोशल मीडिया थ्रेड्स के नए 4-फीचर आर्किटेक्चर की चर्चा है: AI समरी बॉक्स, विजुअल ट्री लाइन्स, ऑटो-स्प्लिट कंपोज़र और स्मार्ट फिल्टर्स।',
    aiHighlights: [
      'लंबे थ्रेड्स से पहले 3 बुलेट पॉइंट्स वाली AI समरी।',
      'रंगीन नेस्टिंग लाइन्स ताकि पैरेंट-चाइल्ड रिप्लाई कभी मिक्स न हों।',
      'लंबा टेक्स्ट टाइप करते ही अपने आप कार्ड 1/3, 2/3 में स्प्लिट।',
    ],
    allReplies: [
      ReplyItem(
        id: 'r1',
        author: 'Dr. Alok Verma',
        handle: '@alok_ux',
        role: 'expert',
        badgeColor: const Color(0xFFF59E0B),
        time: '1h ago',
        likes: 42,
        depth: 0,
        content: 'Visual Nesting Lines Reddit और Twitter दोनों की सबसे बड़ी कमी को पूरा करती हैं। ट्री व्यू से संदर्भ एकदम साफ रहता है।',
        replies: [
          ReplyItem(
            id: 'r1_1',
            author: 'Rohan Sharma',
            handle: '@rohan_dev',
            role: 'friend',
            badgeColor: const Color(0xFF10B981),
            time: '45m ago',
            likes: 18,
            depth: 1,
            content: 'बिलकुल सहमत! खासकर जब 3-4 लेवल गहरे रिप्लाई हों तो कलर कोडेड लाइन्स से ट्रैक करना बहुत आसान होता है।',
            replies: [
              ReplyItem(
                id: 'r1_1_1',
                author: 'Mahesh Gond',
                handle: '@mahesh_arch',
                role: 'creator',
                badgeColor: const Color(0xFF6366F1),
                time: '20m ago',
                likes: 9,
                depth: 2,
                content: 'हाँ रोहन, हमने इसमें डबल-टैप क्विक रिप्लाई भी जोड़ा है ताकि सीधा उसी नोड पर रिप्लाई हो सके!',
                replies: [],
              )
            ],
          ),
        ],
      ),
      ReplyItem(
        id: 'r2',
        author: 'Priya Patel',
        handle: '@priya_ai',
        role: 'expert',
        badgeColor: const Color(0xFFF59E0B),
        time: '50m ago',
        likes: 31,
        depth: 0,
        content: 'Auto-Split Composer बहुत ही क्रांतिकारी है। क्रिएटर को बार-बार मैन्युअल + बटन नहीं दबाना पड़ता।',
        replies: [],
      ),
      ReplyItem(
        id: 'r3',
        author: 'Aman Gupta',
        handle: '@amang',
        role: 'friend',
        badgeColor: const Color(0xFF10B981),
        time: '30m ago',
        likes: 12,
        depth: 0,
        content: 'सुपर क्लीन डिज़ाइन! वॉयस-टू-टेक्स्ट ऑडियो नोट वाला फीचर कब टेस्ट करने को मिलेगा?',
        replies: [],
      ),
    ],
  );

  List<ReplyItem> _filterReplies(List<ReplyItem> replies) {
    if (selectedFilter == 'All') return replies;
    if (selectedFilter == 'Experts') {
      return replies.where((r) => r.role == 'expert').toList();
    }
    if (selectedFilter == 'Friends') {
      return replies.where((r) => r.role == 'friend').toList();
    }
    if (selectedFilter == 'Top') {
      List<ReplyItem> sorted = List.from(replies);
      sorted.sort((a, b) => b.likes.compareTo(a.likes));
      return sorted;
    }
    return replies;
  }

  void _openComposer() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const AutoSplitComposerDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filterReplies(sampleThread.allReplies);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF111827),
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'THREAD HUB',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.1),
            ),
            Text(
              sampleThread.topic,
              style: const TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Colors.white70),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('थ्रेड लिंक क्लिपबोर्ड में कॉपी हो गया!')),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF6366F1),
        onPressed: _openComposer,
        icon: const Icon(Icons.edit_note, color: Colors.white, size: 26),
        label: const Text('Start a Thread', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // Core Post Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1F2937),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF374151)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: const Color(0xFF6366F1),
                      child: Text(sampleThread.author[0], style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(sampleThread.author, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        Text('${sampleThread.handle} • ${sampleThread.time}', style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 12)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  sampleThread.corePost,
                  style: const TextStyle(fontSize: 15, height: 1.5, color: Color(0xFFF3F4F6)),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Highlight 1: AI Summarized Box
          AISummaryCard(
            summary: sampleThread.aiSummary,
            highlights: sampleThread.aiHighlights,
          ),

          const SizedBox(height: 18),

          // Smart Filters Bar
          Row(
            children: [
              const Text('REPLIES', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF9CA3AF), letterSpacing: 1.2)),
              const Spacer(),
              _buildFilterChip('All', 'सभी'),
              const SizedBox(width: 6),
              _buildFilterChip('Experts', '🎓 Experts'),
              const SizedBox(width: 6),
              _buildFilterChip('Friends', '👥 Friends'),
              const SizedBox(width: 6),
              _buildFilterChip('Top', '🔥 Top'),
            ],
          ),

          const SizedBox(height: 14),

          // Visual Tree Replies
          if (filtered.isEmpty)
            Container(
              padding: const EdgeInsets.all(24),
              alignment: Alignment.center,
              child: const Text('इस फ़िल्टर में कोई जवाब उपलब्ध नहीं है।', style: TextStyle(color: Colors.grey)),
            )
          else
            ...filtered.map((reply) => VisualTreeReply(
              item: reply,
              onDoubleTapReply: (author) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Quick Reply to @$author (डबल-टैप सक्रिय)')),
                );
              },
            )),

          const SizedBox(height: 80), // Fab space
        ],
      ),
    );
  }

  Widget _buildFilterChip(String filterKey, String label) {
    final isSelected = selectedFilter == filterKey;
    return GestureDetector(
      onTap: () => setState(() => selectedFilter = filterKey),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF6366F1) : const Color(0xFF1F2937),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF818CF8) : const Color(0xFF374151),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Colors.white : const Color(0xFFD1D5DB),
          ),
        ),
      ),
    );
  }
}
