import 'package:flutter/material.dart';
import '../../utils/theme.dart';

class PremiumPage extends StatelessWidget {
  const PremiumPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: spotifyBgColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: const Color(0xFF1A0000),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Album art grid background
                  GridView.count(
                    crossAxisCount: 3,
                    physics: const NeverScrollableScrollPhysics(),
                    children: List.generate(9, (i) {
                      final colors = [
                        const Color(0xFF8B0000),
                        const Color(0xFF4A0000),
                        const Color(0xFF2D0000),
                        const Color(0xFF6B0000),
                        const Color(0xFF3D0000),
                        const Color(0xFF5A0000),
                        const Color(0xFF7A0000),
                        const Color(0xFF2A0000),
                        const Color(0xFF9B0000),
                      ];
                      return Container(
                        color: colors[i % colors.length],
                        child: const Icon(
                          Icons.music_note,
                          color: Colors.white12,
                          size: 40,
                        ),
                      );
                    }),
                  ),
                  // Gradient overlay
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Color(0xFF0A0A0A)],
                      ),
                    ),
                  ),
                  // Premium logo
                  Positioned(
                    bottom: 20,
                    left: 20,
                    child: Row(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: const BoxDecoration(
                            color: spotifyGreen,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.music_note,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Premium',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Listen without limits.\nTry 3 months of Premium\nfor ₹99 with Maylo.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white12,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.notifications_outlined,
                          color: Colors.white70,
                          size: 16,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Limited time offer',
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // CTA button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Try 3 months for ₹99',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '₹99 for 3 months, then ₹139 per month after. Offer only available if you haven\'t tried Premium before.',
                    style: TextStyle(color: Colors.white54, fontSize: 11),
                  ),
                  const SizedBox(height: 32),
                  // Why Premium section
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Why join Premium Standard?',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ...[
                          (Icons.volume_off_outlined, 'Ad-free music listening'),
                          (Icons.shuffle, 'Play songs in any order'),
                          (Icons.headphones_outlined, 'Very high audio quality'),
                          (Icons.people_outline, 'Listen with friends in real time'),
                          (Icons.play_circle_outline, 'Watch uninterrupted music videos'),
                        ].map(
                          (e) => Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: Row(
                              children: [
                                Icon(e.$1, color: Colors.white70, size: 22),
                                const SizedBox(width: 14),
                                Text(
                                  e.$2,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Available plans',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _planCard(
                    tag: '₹99 for 3 months',
                    tagColor: spotifyGreen,
                    title: 'Standard',
                    titleColor: spotifyGreen,
                    price: '₹99 for 3 months',
                    priceNote: '₹139 / month after',
                    buttonText: 'Try 3 months for ₹99',
                    buttonColor: Colors.white,
                    buttonTextColor: Colors.black,
                  ),
                  const SizedBox(height: 16),
                  _planCard(
                    tag: 'Savings available',
                    tagColor: const Color(0xFF00C8A0),
                    title: 'Platinum',
                    titleColor: const Color(0xFFFFE066),
                    price: '₹299 / month',
                    features: [
                      'Up to 3 Platinum accounts',
                      'Download to listen offline',
                      'Lossless audio quality (up to ~24-bit/44.1kHz)',
                      'Mix your playlists',
                      'Your personal AI DJ',
                      'AI playlist creation',
                      'Connect your DJ software',
                      'Cancel anytime',
                    ],
                    buttonText: 'Get Premium Platinum',
                    buttonColor: const Color(0xFFFFE066),
                    buttonTextColor: Colors.black,
                  ),
                  const SizedBox(height: 16),
                  _planCard(
                    tag: 'Savings available',
                    tagColor: const Color(0xFF00C8A0),
                    title: 'Student',
                    titleColor: spotifyGreen,
                    price: '₹69 for 2 months',
                    priceNote: '₹69 / month after',
                    features: [
                      '1 verified Standard account',
                      'Download to listen offline',
                      'Very high audio quality (up to ~320kbps)',
                      'Cancel anytime',
                    ],
                    buttonText: 'Try 2 months for ₹69',
                    buttonColor: const Color(0xFF00C8A0),
                    buttonTextColor: Colors.black,
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _planCard({
    required String tag,
    required Color tagColor,
    required String title,
    required Color titleColor,
    required String price,
    String? priceNote,
    List<String>? features,
    required String buttonText,
    required Color buttonColor,
    required Color buttonTextColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: tagColor,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              tag,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: const BoxDecoration(
                  color: spotifyGreen,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.music_note, color: Colors.white, size: 12),
              ),
              const SizedBox(width: 6),
              const Text(
                'Premium',
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: TextStyle(
              color: titleColor,
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            price,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (priceNote != null)
            Text(
              priceNote,
              style: const TextStyle(color: Colors.white54, fontSize: 13),
            ),
          if (features != null) ...[
            const SizedBox(height: 16),
            const Divider(color: Colors.white12),
            const SizedBox(height: 8),
            ...features.map(
              (f) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ', style: TextStyle(color: Colors.white70)),
                    Expanded(
                      child: Text(
                        f,
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                foregroundColor: buttonTextColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                buttonText,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: buttonTextColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
