import 'package:flutter/material.dart';
import 'package:frontend/shared/navbar.dart';
import 'package:frontend/shared/theme.dart';

class SportPage extends StatelessWidget {
  const SportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Aktivitas Olahraga',
          style: blackTextStyle.copyWith(
            fontWeight: semiBold,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      blueColor.withOpacity(0.8),
                      orangeColor.withOpacity(0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selamat Datang di Halaman Olahraga',
                      style: whiteTextStyle.copyWith(
                        fontSize: 20,
                        fontWeight: semiBold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Temukan berbagai aktivitas olahraga yang sesuai untuk membantu menjaga kesehatan Anda',
                      style: whiteTextStyle.copyWith(
                        fontSize: 14,
                        fontWeight: light,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Rekomendasi Olahraga Hari Ini',
                style: blackTextStyle.copyWith(
                  fontSize: 16,
                  fontWeight: semiBold,
                ),
              ),
              const SizedBox(height: 16),
              _buildSportItem(
                'Jogging',
                '30 menit',
                'Lari dengan kecepatan sedang untuk meningkatkan kesehatan jantung',
                Icons.directions_run,
              ),
              const SizedBox(height: 12),
              _buildSportItem(
                'Yoga',
                '20 menit',
                'Strecth dan relaksasi untuk meredakan stress dan meningkatkan fleksibilitas',
                Icons.self_improvement,
              ),
              const SizedBox(height: 12),
              _buildSportItem(
                'Bersepeda',
                '45 menit',
                'Bersepeda untuk melatih otot kaki dan meningkatkan kebugaran',
                Icons.pedal_bike,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomNavBar(initialIndex: 1),
    );
  }

  Widget _buildSportItem(String title, String duration, String description, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: orangeColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: orangeColor,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: blackTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: semiBold,
                  ),
                ),
                Text(
                  duration,
                  style: orangeTextStyle.copyWith(
                    fontSize: 14,
                    fontWeight: medium,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: greyTextStyle.copyWith(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}