import 'package:flutter/material.dart';
import 'package:frontend/shared/theme.dart';
import 'package:frontend/ui/widgets/activites/overview_activites/redeem_point_header.dart';
import 'package:frontend/ui/widgets/activites/overview_activites/redeem_item_card.dart';

/// Redeem points section with horizontal list
class RedeemPointsSection extends StatelessWidget {
  final VoidCallback? onSeeMoreTap;
  
  const RedeemPointsSection({Key? key, this.onSeeMoreTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsive sizing
    final screenWidth = MediaQuery.of(context).size.width;
    final sectionHeight = screenWidth < 360 ? 250.0 : 280.0;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RedeemPointsHeader(onSeeMoreTap: onSeeMoreTap),
        const SizedBox(height: 16),
        SizedBox(
          height: sectionHeight,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              RedeemItemCard(
                title: 'Tumblr',
                description: 'always hydrate with a',
                itemType: 'tumbler',
                coins: 3206,
                imagePath: 'assets/tumblr.png',
                brandColor: orangeColor,
              ),
              const SizedBox(width: 12),
              RedeemItemCard(
                title: 'Running Shoes',
                description: 'get a comfortable run with',
                itemType: 'shoe',
                coins: 3206,
                imagePath: 'assets/shoe.png',
                brandColor: orangeColor,
              ),
              const SizedBox(width: 12),
              RedeemItemCard(
                title: 'Sports',
                description: 'always comfortable with a',
                itemType: 's',
                coins: 3206,
                imagePath: 'assets/shoe.png',
                brandColor: orangeColor,
              ),
            ],
          ),
        ),
      ],
    );
  }
}