import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class _Post {
  final String title;
  final String author;
  final String role;
  final String time;
  final String content;
  final String tag;
  final Color tagColor;

  const _Post({
    required this.title,
    required this.author,
    required this.role,
    required this.time,
    required this.content,
    required this.tag,
    required this.tagColor,
  });
}

class CommentaryScreen extends StatelessWidget {
  const CommentaryScreen({super.key});

  static const List<_Post> _posts = [
    _Post(
      title: 'Weekly Market Overview',
      author: 'Rajeev Sharma',
      role: 'Senior Analyst',
      time: '2 hours ago',
      content: 'Markets remain range-bound near key resistance levels. Watch for consolidation before the next directional move. Broader indices showing resilience despite global headwinds.',
      tag: 'Overview',
      tagColor: Color(0xFF1565C0),
    ),
    _Post(
      title: 'Index Update: Key Levels to Watch',
      author: 'Priya Nair',
      role: 'Market Expert',
      time: '5 hours ago',
      content: 'Major indices have formed a short-term base. Support is well-defined. A sustained move above current levels would signal strength. Volatility expected ahead of macro data.',
      tag: 'Analysis',
      tagColor: Color(0xFF2E7D32),
    ),
    _Post(
      title: 'Commodity Watch: Metals Update',
      author: 'Suresh Mehta',
      role: 'Commodity Analyst',
      time: 'Yesterday',
      content: 'Precious metals consolidating after recent gains. Global cues remain mixed. Traders should watch key support zones closely. Any break below support could see accelerated selling.',
      tag: 'Commodity',
      tagColor: Color(0xFFE65100),
    ),
    _Post(
      title: 'FII Activity: Market Implications',
      author: 'Kavya Reddy',
      role: 'Research Head',
      time: 'Yesterday',
      content: 'Institutional flows have been net positive this week, supporting the broader market. Continued inflows into large-caps suggest confidence in the medium-term outlook.',
      tag: 'Institutional',
      tagColor: Color(0xFF6A1B9A),
    ),
    _Post(
      title: 'Currency & Macro Outlook',
      author: 'Anand Patel',
      role: 'Macro Strategist',
      time: '2 days ago',
      content: 'Currency markets remain stable with limited volatility. Macro indicators suggest moderate growth. Key global events this week could introduce short-term fluctuations.',
      tag: 'Macro',
      tagColor: Color(0xFF00695C),
    ),
    _Post(
      title: 'Derivatives Desk: Open Interest Analysis',
      author: 'Rohit Joshi',
      role: 'Derivatives Analyst',
      time: '3 days ago',
      content: 'Options data indicates a balanced setup with no extreme positioning. Put-call ratio near neutral levels suggests the market awaits a trigger before a decisive move.',
      tag: 'Derivatives',
      tagColor: Color(0xFF4527A0),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.primaryRed,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Commentary', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _posts.length,
        itemBuilder: (context, i) => _postCard(_posts[i]),
      ),
    );
  }

  Widget _postCard(_Post p) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: p.tagColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(p.tag, style: TextStyle(fontSize: 11, color: p.tagColor, fontWeight: FontWeight.w600)),
                ),
                const Spacer(),
                Text(p.time, style: const TextStyle(fontSize: 11, color: AppColors.textHint)),
              ],
            ),
            const SizedBox(height: 10),
            Text(p.title,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, height: 1.3)),
            const SizedBox(height: 8),
            Text(p.content,
                style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.55)),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 10),
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.primaryRed.withOpacity(0.12),
                  child: Text(
                    p.author.split(' ').map((w) => w[0]).take(2).join(),
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primaryRed),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(p.author, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    Text(p.role, style: const TextStyle(fontSize: 11, color: AppColors.textHint)),
                  ],
                ),
                const Spacer(),
                Icon(Icons.bookmark_border, size: 18, color: Colors.grey.shade400),
                const SizedBox(width: 12),
                Icon(Icons.share_outlined, size: 18, color: Colors.grey.shade400),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
