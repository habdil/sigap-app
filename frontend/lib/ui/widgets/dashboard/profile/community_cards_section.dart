// frontend/lib/ui/widgets/dashboard/profile/community_cards_section.dart
import 'package:flutter/material.dart';
import 'package:frontend/shared/theme.dart';

class CommunityCardsSection extends StatelessWidget {
  const CommunityCardsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Community',
          style: blackTextStyle.copyWith(
            fontSize: 18,
            fontWeight: semiBold,
          ),
        ),
        const SizedBox(height: 16),
        
        // Community Cards
        Row(
          children: [
            Expanded(
              child: _buildCommunityCard(
                'Maraphtoon',
                'Jogging running community that you can participate in the marathon every day',
                'Joined',
                Colors.orange,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildCommunityCard(
                'Yogya Joging',
                'Jogging running community that you can participate in the marathon every day',
                'Join',
                Colors.grey,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCommunityCard(String title, String description, String buttonText, Color buttonColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: blackTextStyle.copyWith(
              fontWeight: semiBold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: greyTextStyle.copyWith(
              fontSize: 12,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: buttonColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              buttonText,
              style: buttonColor == Colors.grey 
                ? blackTextStyle.copyWith(
                    fontSize: 12,
                    fontWeight: medium,
                  )
                : whiteTextStyle.copyWith(
                    fontSize: 12,
                    fontWeight: medium,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}