import 'package:flutter/material.dart';
import 'package:frontend/shared/theme.dart';
import 'package:frontend/ui/pages/chatbot_page.dart';
import 'package:frontend/ui/widgets/activity.dart';
import 'package:frontend/ui/widgets/daily_health_article.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 410,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundImage: NetworkImage(
                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRd55orZbXr-LibtYUPwBgV6AzfalQoSGTfHg&s',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Daily Mindfulness Check-in',
                    style: whiteTextStyle.copyWith(
                        fontWeight: light, fontSize: 14),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Hello, User 👋',
                    style: whiteTextStyle.copyWith(
                        fontWeight: semiBold, fontSize: 24),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Let’s Track Your Progress,\nHow Are You Feeling \nToday?',
                    style: whiteTextStyle.copyWith(
                        fontWeight: light, fontSize: 24),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 58,
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(35)),
                    child: TextField(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ChatBotPage()),
                          );
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
          // Activities recommendations carousel
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Activities recommendations',
                style:
                    blackTextStyle.copyWith(fontWeight: semiBold, fontSize: 14),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 98,
            child: ListView.separated(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, idx) {
                  final act = activities[idx];
                  return Activity(assetPath: act.assetPath, label: act.label);
                },
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemCount: activities.length),
          ),

          // Horizontal Scroll for Activity Cards
          Padding(
            padding: const EdgeInsets.only(
              left: 16,
              top: 16,
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 5),
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ActivityCard(
                    title: 'Morning Jogging',
                    description:
                        'Get up early and get moving, it will make your day feel refreshing and cheerful',
                    badgeText: '+1 Point/Step',
                  ),
                  SizedBox(width: 16),
                  ActivityCard(
                    title: 'Evening Yoga',
                    description:
                        'Relax your body and mind after a long day of activities. Don’t miss this easy way to stay healthy.',
                    badgeText: '+1 Point/Session',
                  ),
                  SizedBox(width: 16),
                  ActivityCard(
                    title: 'Weekend Running',
                    description:
                        'Spend your weekend actively by running. Fresh air and exercise are the best combo!',
                    badgeText: '+2 Point/Event',
                  ),
                  SizedBox(width: 16),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),
          // Section title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Healthy food for you',
                style:
                    blackTextStyle.copyWith(fontWeight: semiBold, fontSize: 14),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Healthy Food Card
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
                    // Semi-transparent Text Background
                    Positioned.fill(
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Container(
                              color: Colors.white
                                  .withOpacity(0.1), // <- transparan putih
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
                          Expanded(
                              flex: 3,
                              child: SizedBox()), // kosong untuk sisi kanan
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),
          // Section title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Community Posts',
                style:
                    blackTextStyle.copyWith(fontWeight: semiBold, fontSize: 14),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Community post card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header user info
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        // Profile Picture
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: AssetImage(
                              'assets/profile.png'), // Ganti sesuai file kamu
                        ),
                        const SizedBox(width: 12),
                        // Username + Time
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'SIGAP Official',
                              style: blackTextStyle.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '30 mnt',
                              style: greyTextStyle.copyWith(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        Icon(Icons.more_horiz),
                      ],
                    ),
                  ),
                  // Post Image
                  ClipRRect(
                      borderRadius: BorderRadius.vertical(
                          top: Radius.circular(10),
                          bottom: Radius.circular(10)),
                      child: Padding(
                          padding: const EdgeInsets.only(left: 15, right: 15),
                          child: ClipRRect(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(12),
                                bottom: Radius.circular(12)),
                            child: Image.asset(
                              'assets/img_running_post.png', // Ganti sesuai file kamu
                              width: double.infinity,
                              height: 300,
                              fit: BoxFit.cover,
                            ),
                          ))),
                  const SizedBox(height: 12),
                  // Post Description
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Running For 4Hours Today',
                      style: blackTextStyle.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Reaction Row
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        // Like
                        Row(
                          children: [
                            Image.asset(
                              'assets/icn_clap.png',
                              width: 20, // Sesuaikan ukuran gambar
                              height: 20,
                            ),
                            const SizedBox(width: 4),
                            Text('1,100',
                                style: blackTextStyle.copyWith(fontSize: 12)),
                          ],
                        ),
                        const SizedBox(width: 16),
                        // Comment
                        Row(
                          children: [
                            Image.asset(
                              'assets/ic_comments.png',
                              width: 20, // Sesuaikan ukuran gambar
                              height: 20,
                            ),
                            const SizedBox(width: 4),
                            Text('58',
                                style: blackTextStyle.copyWith(fontSize: 12)),
                          ],
                        ),
                        const SizedBox(width: 16),
                        // Views
                        Row(
                          children: [
                            Icon(Icons.remove_red_eye_outlined,
                                color: Colors.black54),
                            const SizedBox(width: 4),
                            Text('1,300',
                                style: blackTextStyle.copyWith(fontSize: 12)),
                          ],
                        ),
                        Spacer(),
                        // Button
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '👏 Give a clap!',
                            style: blackTextStyle.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),

          // Button: See More In Community
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: GestureDetector(
              onTap: () {
                // TODO: Arahkan ke halaman community
                print('See More In Community tapped');
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E0E0), // Warna abu-abu muda
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: Text(
                    'See More In Community',
                    style: blackTextStyle.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Daily Health Article Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Daily health article',
                      style: blackTextStyle.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'see all',
                      style: orangeTextStyle.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // List of Articles
                Column(
                  children: List.generate(3, (index) => Article()),
                ),
              ],
            ),
          )
        ],
      ),
    ));
  }
}
