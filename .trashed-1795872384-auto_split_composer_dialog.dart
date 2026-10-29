import 'package:flutter/material.dart';

class AutoSplitComposerDialog extends StatefulWidget {
  const AutoSplitComposerDialog({super.key});

  @override
  State<AutoSplitComposerDialog> createState() => _AutoSplitComposerDialogState();
}

class _AutoSplitComposerDialogState extends State<AutoSplitComposerDialog> {
  final TextEditingController _controller = TextEditingController();
  final int maxCharsPerCard = 140; // auto-split limit
  List<String> threadCards = [];
  bool isRecording = false;

  void _onTextChanged(String text) {
    if (text.trim().isEmpty) {
      setState(() => threadCards = []);
      return;
    }

    // Split text automatically based on paragraph or character chunk size
    List<String> chunks = [];
    int start = 0;
    while (start < text.length) {
      int end = (start + maxCharsPerCard < text.length) ? (start + maxCharsPerCard) : text.length;
      // try to break on space
      if (end < text.length) {
        int lastSpace = text.lastIndexOf(' ', end);
        if (lastSpace > start + 50) {
          end = lastSpace;
        }
      }
      chunks.add(text.substring(start, end).trim());
      start = end;
    }

    setState(() {
      threadCards = chunks.where((c) => c.isNotEmpty).toList();
    });
  }

  void _loadSampleLongText() {
    String demoText = "1. सोशल मीडिया थ्रेड आर्किटेक्चर का मुख्य लक्ष्य यूज़र के समय की बचत करना और चर्चा को व्यवस्थित रखना है। "
        "2. AI समरी से पाठक को 5 सेकंड में मुख्य बिंदु समझ आ जाते हैं बिना पूरा थ्रेड स्क्रॉल किए। "
        "3. विजुअल नेस्टिंग लाइन्स जटिल बहसों में स्पष्टता लाती हैं, जिससे पता चलता है कि किस उत्तर का संबंध किस विचार से है। "
        "4. ऑटो-स्प्लिट कंपोज़र लेखक को बिना रुके लगातार टाइप करने की आज़ादी देता है और ऐप खुद कार्ड बना देती है।";
    _controller.text = demoText;
    _onTextChanged(demoText);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.88,
      padding: EdgeInsets.only(
        top: 16,
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF111827),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Auto-Split Thread Composer',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const Spacer(),
              TextButton(
                onPressed: _loadSampleLongText,
                child: const Text('उदा. टेक्स्ट भरें', style: TextStyle(color: Color(0xFF818CF8), fontSize: 12)),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white70),
                onPressed: () => Navigator.pop(context),
              )
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'यहाँ लगातार लिखें; ऐप अपने आप 140 अक्षरों के थ्रेड कार्ड्स में बाँट देगा।',
            style: TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
          ),
          const SizedBox(height: 12),

          // Input area
          Container(
            height: 110,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF1F2937),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF374151)),
            ),
            child: TextField(
              controller: _controller,
              onChanged: _onTextChanged,
              maxLines: null,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: const InputDecoration(
                hintText: 'अपना पूरा विचार यहाँ टाइप करें या बोलें...',
                hintStyle: TextStyle(color: Color(0xFF6B7280)),
                border: InputBorder.none,
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Voice-to-Text / Audio Note trigger
          Row(
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isRecording ? Colors.redAccent : const Color(0xFF374151),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                onPressed: () {
                  setState(() => isRecording = !isRecording);
                  if (isRecording) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('🎙️ Voice-to-Text रिकॉर्डिंग सक्रिय (ऑडियो नोट)'), duration: Duration(seconds: 2)),
                    );
                  }
                },
                icon: Icon(isRecording ? Icons.mic : Icons.mic_none, size: 16),
                label: Text(
                  isRecording ? 'Recording Audio Note...' : 'Voice-to-Text',
                  style: const TextStyle(fontSize: 11),
                ),
              ),
              const Spacer(),
              Text(
                'कुल कार्ड्स: ${threadCards.isEmpty ? 1 : threadCards.length}',
                style: const TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ],
          ),

          const SizedBox(height: 12),
          const Text(
            'LIVE THREAD PREVIEW (ऑटो स्प्लिट परिणाम):',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF9CA3AF), letterSpacing: 1),
          ),
          const SizedBox(height: 8),

          // Cards Preview list
          Expanded(
            child: threadCards.isEmpty
                ? Container(
                    alignment: Alignment.center,
                    child: const Text(
                      'ऊपर लिखना शुरू करें, लाइव कार्ड्स यहाँ दिखेंगे।',
                      style: TextStyle(color: Color(0xFF4B5563), fontSize: 13),
                    ),
                  )
                : ListView.builder(
                    itemCount: threadCards.length,
                    itemBuilder: (ctx, index) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFF4F46E5).withOpacity(0.5)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF6366F1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '${index + 1}/${threadCards.length}',
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                threadCards[index],
                                style: const TextStyle(fontSize: 13, color: Color(0xFFE2E8F0), height: 1.35),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),

          // Publish Thread Button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('✅ थ्रेड सफलतापूर्वक पोस्ट हो गया!')),
                );
              },
              child: const Text(
                'Publish Entire Thread',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
          )
        ],
      ),
    );
  }
}
