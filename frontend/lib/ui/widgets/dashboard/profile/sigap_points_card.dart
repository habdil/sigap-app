// frontend/lib/ui/widgets/dashboard/profile/sigap_coins_card.dart
import 'package:flutter/material.dart';
import 'package:frontend/shared/theme.dart';
import 'package:frontend/services/coin_service.dart';
import 'package:frontend/models/coin_model.dart';

class SigapCoinsCard extends StatefulWidget {
  const SigapCoinsCard({super.key});

  @override
  State<SigapCoinsCard> createState() => _SigapCoinsCardState();
}

class _SigapCoinsCardState extends State<SigapCoinsCard> {
  bool _isLoading = true;
  String _errorMessage = '';
  CoinModel? _coinData;

  @override
  void initState() {
    super.initState();
    _fetchUserCoins();
  }

  Future<void> _fetchUserCoins() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      final result = await CoinService.getCoins();
      
      if (result['success']) {
        setState(() {
          _coinData = result['data'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = result['message'] ?? 'Failed to load coins';
          _isLoading = false;
        });
        print('Error fetching coins: ${result['message']}');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An unexpected error occurred';
        _isLoading = false;
      });
      print('Exception in _fetchUserCoins: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
          // SIGAP Coins Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'SIGAP Coins',
                style: blackTextStyle.copyWith(
                  fontSize: 20,
                  fontWeight: semiBold,
                ),
              ),
              _isLoading
                ? SizedBox(
                    width: 80,
                    height: 24,
                    child: Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF7A45)),
                        ),
                      ),
                    ),
                  )
                : Row(
                    children: [
                      Image.asset(
                        'assets/icn_clap.png',
                        width: 24,
                        height: 24,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _coinData?.totalCoins.toString() ?? '10,206',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: bold,
                          color: Color(0xFFFF7A45),
                        ),
                      ),
                    ],
                  ),
            ],
          ),
          const SizedBox(height: 16),
          // Progress Bar - Blue to Orange Gradient
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              height: 10,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    color: Colors.grey.shade200,
                  ),
                  FractionallySizedBox(
                    widthFactor: 0.6,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.blue,
                            Color(0xFFFF7A45),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSmallButton('your points', Colors.grey.shade200),
              _buildSmallButton('GET : Sigap Shoes', Color(0xFFFF7A45), textColor: Colors.white, fontSize: 12),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSmallButton(String text, Color bgColor, {Color? textColor, double? fontSize}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: blackTextStyle.copyWith(
          fontSize: fontSize ?? 12,
          fontWeight: medium,
          color: textColor,
        ),
      ),
    );
  }
}