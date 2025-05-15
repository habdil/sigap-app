import 'package:flutter/material.dart';
import 'package:frontend/shared/theme.dart';
import 'package:frontend/ui/pages/dashboard/activity/order/setaddress_page.dart';

/// Redeem item card
class RedeemItemCard extends StatelessWidget {
  final String title;
  final String description;
  final String itemType;
  final int coins;
  final String imagePath;
  final Color brandColor;

  const RedeemItemCard({
    Key? key,
    required this.title,
    required this.description,
    required this.itemType,
    required this.coins,
    required this.imagePath,
    required this.brandColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsive sizing
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    // Adjust card width based on screen size
    final cardWidth = screenWidth < 360 ? 170.0 : 220.0;
    
    // Adjust font sizes based on screen size
    final titleFontSize = screenWidth < 360 ? 12.0 : 14.0;
    final descFontSize = screenWidth < 360 ? 10.0 : 12.0;
    final coinFontSize = screenWidth < 360 ? 10.0 : 12.0;
    final buttonFontSize = screenWidth < 360 ? 8.0 : 10.0;
    
    // Adjust image height based on screen size
    final imageHeight = screenWidth < 360 ? 100.0 : 120.0;
    
    // Adjust content padding based on screen size
    final contentPadding = screenWidth < 360 
        ? const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 4)
        : const EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 6);
    
    return Container(
      width: cardWidth,
      // Use constraints to ensure the card doesn't grow too tall
      constraints: BoxConstraints(
        maxHeight: screenHeight * 0.4, // Limit maximum height
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Use minimum space needed
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image section
          Container(
            height: imageHeight,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xFFDADADA),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Center(
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
                height: imageHeight * 1.3, // Proportional to container height
                errorBuilder: (context, error, stackTrace) => 
                  Icon(Icons.image_not_supported, size: 40, color: Colors.grey.shade400),
              ),
            ),
          ),
          // Content section - use Expanded to fill remaining space
          Flexible(
            child: Container(
              padding: contentPadding,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(18), 
                  bottomRight: Radius.circular(18)
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min, // Use minimum space needed
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row: Title & Coin
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Expanded(
                        child: RichText(
                          overflow: TextOverflow.ellipsis, // Handle text overflow
                          maxLines: 1, // Limit to one line
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'SIGAP ',
                                style: orangeTextStyle.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: titleFontSize,
                                ),
                              ),
                              TextSpan(
                                text: title,
                                style: blackTextStyle.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: titleFontSize,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      // Coin
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            coins.toString(),
                            style: orangeTextStyle.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: coinFontSize,
                            ),
                          ),
                          Text(
                            'Coins',
                            style: blackTextStyle.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: coinFontSize - 2,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Description
                  Flexible(
                    child: RichText(
                      overflow: TextOverflow.ellipsis, // Handle text overflow
                      maxLines: 2, // Limit to two lines
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '$description ',
                            style: blackTextStyle.copyWith(
                              fontSize: descFontSize,
                              color: Colors.black, 
                            )
                          ),
                          TextSpan(
                            text: 'SIGAP ',
                            style: orangeTextStyle.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: descFontSize,
                            ),
                          ),
                          TextSpan(
                            text: itemType,
                            style: TextStyle(
                              fontSize: descFontSize,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Redeem button
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      onPressed: () {
                        _showItemDetailBottomSheet(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        elevation: 1,
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth < 360 ? 16 : 24, 
                          vertical: 0
                        ),
                        minimumSize: Size(0, screenWidth < 360 ? 24 : 30), // Adjust button height
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Redeem',
                        style: blackTextStyle.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: buttonFontSize,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  // Show item detail in bottom sheet instead of navigating to a new page
  void _showItemDetailBottomSheet(BuildContext context) {
    // Get screen dimensions for responsive layout
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: screenHeight * 0.85, // Take up 85% of screen height
        decoration: const BoxDecoration(
          color: Color(0xFFDADADA),
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          children: [
            // App Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_horiz, color: Colors.black),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            
            // Product Image
            Container(
              height: screenHeight * 0.3,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Center(
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            
            // Detail Card
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      screenWidth * 0.06,
                      16,
                      screenWidth * 0.06,
                      24
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Drag handle
                        Center(
                          child: Container(
                            width: 48,
                            height: 5,
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(2.5),
                            ),
                          ),
                        ),
                        
                        // Title & Coin
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "SIGAP ",
                              style: TextStyle(
                                color: Color(0xFFFF5722),
                                fontWeight: FontWeight.bold,
                                fontSize: screenWidth * 0.055,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                title,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: screenWidth * 0.055,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  coins.toString(),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: screenWidth * 0.045,
                                  ),
                                ),
                                Text(
                                  "Coins",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: screenWidth * 0.03,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        
                        SizedBox(height: screenHeight * 0.005),
                        
                        // Redeemed info
                        Text(
                          description,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: screenWidth * 0.03,
                          ),
                        ),
                        
                        SizedBox(height: screenHeight * 0.02),
                        
                        // Description
                        Text(
                          "$description SIGAP $itemType. This product is part of our loyalty program and can be redeemed using your accumulated SIGAP points.",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: screenWidth * 0.035,
                            height: 1.5,
                          ),
                        ),
                        
                        SizedBox(height: screenHeight * 0.02),
                        
                        // Note
                        Text(
                          "make sure your sigap points are sufficient to redeem attractive prizes from sigap, if not, let's exercise again!",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: screenWidth * 0.028,
                          ),
                        ),
                        
                        SizedBox(height: screenHeight * 0.04),
                        
                        // Buttons
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey[300],
                                  foregroundColor: Colors.grey,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    vertical: screenHeight * 0.02,
                                  ),
                                ),
                                child: Text(
                                  "Get More Coins!",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: screenWidth * 0.035,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: screenWidth * 0.04),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const SetAddressPage()
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFF5722),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    vertical: screenHeight * 0.02,
                                  ),
                                ),
                                child: Text(
                                  "Redeem Now",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: screenWidth * 0.035,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}