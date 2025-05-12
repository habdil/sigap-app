import 'package:flutter/material.dart';
import 'package:frontend/shared/theme.dart';
// import 'package:frontend/ui/pages/chatbot_page.dart';

class FoodPage extends StatelessWidget {
  const FoodPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header section with gradient background
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    blueColor.withOpacity(0.8),
                    orangeColor.withOpacity(0.8),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // App bar with menu and profile
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.menu, color: Colors.white, size: 28),
                        CircleAvatar(
                          radius: 24,
                          backgroundImage: NetworkImage(
                            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRd55orZbXr-LibtYUPwBgV6AzfalQoSGTfHg&s',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Healthy Food title
                    Text(
                      'Healthy',
                      style: whiteTextStyle.copyWith(
                        fontWeight: semiBold,
                        fontSize: 32,
                      ),
                    ),
                    Text(
                      'Food For',
                      style: whiteTextStyle.copyWith(
                        fontWeight: semiBold,
                        fontSize: 32,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          'Healthy Life ',
                          style: whiteTextStyle.copyWith(
                            fontWeight: semiBold,
                            fontSize: 32,
                          ),
                        ),
                        Text(
                          '🌱',
                          style: TextStyle(fontSize: 28),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // "What you're going to eat" subtitle
                    Text(
                      "what you're going to eat",
                      style: whiteTextStyle.copyWith(
                        fontWeight: light,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "today??",
                      style: whiteTextStyle.copyWith(
                        fontWeight: light,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Search food health bar
                    Container(
                    height: 58,
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(35)),
                    child: TextField(
                        onTap: () {
                          
                        },
                      decoration: InputDecoration(
                        hintText: 'Your Thoughts...',
                        hintStyle: greyTextStyle.copyWith(
                            fontSize: 17, fontWeight: light, height: 1.0),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 35,
                            vertical:
                                19 // Sesuaikan nilai vertical untuk menempatkan hint text di tengah
                            ),
                        suffixIcon: Container(
                          width: 55,
                          height: 50,
                          margin: const EdgeInsets.only(right: 5),
                          decoration: BoxDecoration(
                              color: Color(0xFFFFA726),
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(26)),
                          child: Transform.rotate(
                            angle:
                                -0.785398, // Rotasi 45 derajat dalam radian (mengarah ke kanan atas)
                            child: const Icon(Icons.arrow_forward,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
            // Want To Avoid section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Want To Avoid',
                    style: blackTextStyle.copyWith(
                      fontWeight: semiBold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Food to avoid categories
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        _buildAvoidCategory('assets/ic_junkfood.png', 'Junk Food'),
                        const SizedBox(width: 16),
                        _buildAvoidCategory('assets/ic_peanut.png', 'Peanut'),
                        const SizedBox(width: 16),
                        _buildAvoidCategory('assets/ic_meat.png', 'High Calories'),
                        const SizedBox(width: 16),
                        _buildAvoidCategory('assets/ic_spicy.png', 'Spicy Food'),
                        const SizedBox(width: 16),
                        _buildAvoidCategory('assets/ic_spicy.png', 'Spicy Food'),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            // Food Recommendation section
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Healthy food for you',
                        style: blackTextStyle.copyWith(fontWeight: semiBold, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Stack(
                        children: [
                          // Background Image
                          Positioned.fill(
                            child: Image.asset(
                              'assets/img_salad.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                          // Orange icon on the right
                          Positioned(
                            top: 75, // Diubah dari 20 ke 75 agar berada di tengah secara vertikal
                            right: 8,
                            child: Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                color: orangeColor,
                                shape: BoxShape.circle,
                                boxShadow: [
                                   BoxShadow(
                                    color: Colors.grey.withOpacity(0.5), // Warna bayangan
                                    spreadRadius: 2, // Seberapa jauh bayangan menyebar
                                    blurRadius: 7, // Seberapa blur bayangan
                                    offset: Offset(0, 3), // Posisi bayangan (x, y)
                                  ),
                                ]
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.restaurant_menu,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                          // Semi-transparent Text Background
                          Positioned.fill(
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    color: Colors.white.withOpacity(0.1),
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Your\nHealth\nStarts on\nYour Plate',
                                          style: blackTextStyle.copyWith(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            height: 1.3,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'healthy food\nrecommendations here',
                                          style: orangeTextStyle.copyWith(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(flex: 3, child: SizedBox()),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
            // Calculation of food components section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Calculation of food components',
                    style: blackTextStyle.copyWith(
                      fontWeight: semiBold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Nutrient cards in a grid
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.43,
                          child: _buildNutrientCard('Protein', '44g', Colors.orange.shade100, Icons.circle_outlined, Colors.orange),
                        ),
                        const SizedBox(width: 16),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.43,
                          child: _buildNutrientCard('Carbs', '1400g', Colors.red.shade50, Icons.local_fire_department_outlined, Colors.orange),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.43,
                          child: _buildNutrientCard('Fat', '44g', Colors.blue.shade50, Icons.water_drop_outlined, Colors.orange),
                        ),
                        const SizedBox(width: 16),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.43,
                          child: _buildNutrientCard('Fibers', '44g', Colors.green.shade50, Icons.grass_outlined, Colors.orange),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            // Food History section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Food History',
                    style: blackTextStyle.copyWith(
                      fontWeight: semiBold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Food history items
                  _buildFoodHistoryItem(context),
                  const SizedBox(height: 12),
                  _buildFoodHistoryItem(context),
                  const SizedBox(height: 12),
                  _buildFoodHistoryItem(context),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget for food categories to avoid
  Widget _buildAvoidCategory(String iconPath, String label) {
    return Container(
      width: 90,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black12, 
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            child: Image.asset(
              iconPath,
              width: 36,
              height: 36,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: orangeTextStyle.copyWith(
              fontSize: 12, 
              fontWeight: medium,
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  // Widget for nutrient information cards
  Widget _buildNutrientCard(String nutrientName, String amount, Color bgColor, IconData iconData, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nutrient name
          Padding(padding: EdgeInsets.only(left: 58),
          child: 
            Text(
              nutrientName,
              style: blackTextStyle.copyWith(
                fontSize: 12,
                fontWeight: semiBold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          
          const SizedBox(height: 8),
          // Icon and amount row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Icon
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: bgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  iconData,
                  color: iconColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 8),
              // Amount
              Flexible(
                child: Text(
                  amount,
                  style: blackTextStyle.copyWith(
                    fontSize: 18,
                    fontWeight: semiBold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Total/7day
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Total/7day',
                      style: greyTextStyle.copyWith(
                        fontSize: 8,
                        fontWeight: medium,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'a day',
                      style: greyTextStyle.copyWith(
                        fontSize: 10,
                        fontWeight: light,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Bottom info
          Padding(padding: EdgeInsets.only(left: 58),
          child: Text(
            '${nutrientName == 'Protein' || nutrientName == 'Fat' || nutrientName == 'Fibers' ? '0.8g/kg' : '200g/kg'}',
            style: greyTextStyle.copyWith(
              fontSize: 12,
              fontWeight: light,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          )
        ],
      ),
    );
  }

  // Widget for food history items
  Widget _buildFoodHistoryItem(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate dynamic sizing based on screen width
        final cardWidth = constraints.maxWidth;
        final imageWidth = cardWidth * 0.3;
        
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          constraints: BoxConstraints(
            minHeight: 120,
            maxHeight: 150, // Prevent excessive height
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Food image with full height
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
                child: Container(
                  width: imageWidth,
                  child: Image.asset(
                    'assets/img_boiledegg.png',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              ),
              // Food details
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Food name with overflow handling
                      Text(
                        'Boiled egg in curry sauce',
                        style: blackTextStyle.copyWith(
                          fontSize: 14,
                          fontWeight: semiBold,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 4),
                      
                      // Time row
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 12,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              '10 min',
                              style: greyTextStyle.copyWith(
                                fontSize: 10,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 8),
                      
                      // Nutrient info with responsive wrapping
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          _buildNutrientInfo('43 fat'),
                          _buildNutrientInfo('500 kal'),
                          _buildNutrientInfo('13g Protein'),
                        ],
                      ),
                      
                      const SizedBox(height: 8),
                      
                      // See recipe button with responsive sizing
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: orangeColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'see recipe',
                            style: whiteTextStyle.copyWith(
                              fontSize: 12,
                              fontWeight: medium,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  
  // Helper widget for nutrient info
  Widget _buildNutrientInfo(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: blackTextStyle.copyWith(
          fontSize: 12,
          fontWeight: medium,
        ),
      ),
    );
  }
}