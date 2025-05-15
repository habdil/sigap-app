import 'package:flutter/material.dart';
import 'package:frontend/shared/theme.dart';
import 'package:frontend/ui/pages/auth/home_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  
  // Daftar konten onboarding
  final List<Map<String, dynamic>> _contents = [
    {
      'image': 'assets/ic_onboarding_1.png', // App logo
      'title': 'Welcome to SIGAP',
      'description': 'Your personal AI-powered companion for early stroke detection and health monitoring — all from your smartphone.',
    },
    {
      'image': 'assets/ic_onboarding_2.png', // Trophy icon
      'title': 'Track Your Health Progress',
      'description': 'Earn achievements as you stay consistent with your health checkups and reduce your stroke risk over time.',
    },
    {
      'image': 'assets/ic_onboarding_3.png', // Coin icon
      'title': 'Affordable & Smart Prevention',
      'description': 'SIGAP makes stroke prevention accessible and cost-effective, saving you time, money, and worry.',
    },
    {
      'image': 'assets/ic_onboarding_4.png', // Food icon
      'title': 'Smart Lifestyle Guidance',
      'description': 'Get personalized tips on nutrition, activity, and habits to keep your brain healthy and stroke-free.',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  void _navigateToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const HomePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              orangeColor.withOpacity(0.8),
              blueColor.withOpacity(0.8),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Progress indicator at the top
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Row(
                  children: List.generate(
                    _contents.length,
                    (index) => Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2.0),
                        height: 4,
                        decoration: BoxDecoration(
                          color: index <= _currentPage ? whiteColor : whiteColor.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // SIGAP logo
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Image.asset(
                  'assets/ic_logo_white.png',
                  height: 24,
                  ),
                ),
              ),

              // Main content
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  itemCount: _contents.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end, // Ubah ke end untuk menurunkan konten
                        children: [
                          // Icon image
                          Container(
                            width: 80,
                            height: 80,
                            alignment: Alignment.centerLeft,
                            child: Image.asset(
                              _contents[index]['image'],
                              width: 80,
                              height: 80,
                            ),
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Tag line
                          Text(
                            'healthy digital apps SIGAP',
                            style: whiteTextStyle.copyWith(
                              fontSize: 14,
                            ),
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Title
                          Text(
                            _contents[index]['title'],
                            style: whiteTextStyle.copyWith(
                              fontSize: 32,
                              fontWeight: bold,
                              height: 1.2,
                            ),
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Description
                          Text(
                            _contents[index]['description'],
                            style: whiteTextStyle.copyWith(
                              fontSize: 14,
                              height: 1.5,
                            ),
                          ),
                          
                          // Jarak antara konten dan tombol
                          const SizedBox(height: 60),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Buttons
              Padding(
                padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 8.0),
                child: Row(
                  children: [
                    // Continue Button
                    Expanded(
                      flex: 3,
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_currentPage == _contents.length - 1) {
                              _navigateToHome();
                            } else {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: whiteColor,
                            foregroundColor: blackColor,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            _currentPage == _contents.length - 1 ? 'Begin Your Journey' : 'Continue',
                            style: blackTextStyle.copyWith(
                              fontWeight: semiBold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    
                    // Spacer between buttons
                    const SizedBox(width: 12),
                    
                    // Skip Button (except on the last page)
                    _currentPage < _contents.length - 1
                        ? Expanded(
                            flex: 1,
                            child: SizedBox(
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () {
                                  _navigateToHome();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  foregroundColor: whiteColor,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    side: BorderSide(color: whiteColor, width: 1),
                                  ),
                                ),
                                child: Text(
                                  'Skip',
                                  style: whiteTextStyle.copyWith(
                                    fontWeight: semiBold,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
              ),

              // Back button
              Center(
                child: TextButton(
                  onPressed: () {
                    if (_currentPage > 0) {
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  child: Text(
                    'Back',
                    style: whiteTextStyle.copyWith(
                      fontWeight: medium,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}