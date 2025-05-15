// frontend/lib/ui/widgets/activites/overview_activites/activity_header.dart

import 'package:flutter/material.dart';
import 'package:frontend/shared/theme.dart';
import 'package:frontend/services/storage_service.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/services/coin_service.dart';
import 'package:frontend/models/coin_model.dart';

/// Header component with user profile and points
class ActivityHeader extends StatefulWidget {
  const ActivityHeader({super.key});

  @override
  State<ActivityHeader> createState() => _ActivityHeaderState();
}

class _ActivityHeaderState extends State<ActivityHeader> {
  User? _user;
  String _coinBalance = '0';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = await StorageService.getUser();

      if (user != null) {
        setState(() {
          _user = user;
        });

        final coinResult = await CoinService.getCoins();

        if (coinResult['success'] == true && coinResult['data'] is CoinModel) {
          final coinData = coinResult['data'] as CoinModel;
          setState(() {
            _coinBalance = _formatNumber(coinData.totalCoins);
          });
        } else {
          print('CoinService returned error: ${coinResult['message']}');
        }
      }
    } catch (e) {
      print('Error loading user data: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  String _getNameFromEmail() {
    if (_user != null && _user!.email.isNotEmpty) {
      final name = _user!.email.split('@').first;
      if (name.isNotEmpty) {
        return name[0].toUpperCase() + name.substring(1);
      }
    }
    return 'User';
  }

  String _getAvatarUrl() {
    if (_user != null && _user!.email.isNotEmpty) {
      final email = Uri.encodeComponent(_user!.email);
      return 'https://ui-avatars.com/api/?name=$email&background=random&color=fff&size=150';
    }
    return 'https://ui-avatars.com/api/?name=User&background=random&color=fff&size=150';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: blueColor.withOpacity(0.2),
              child: _isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(orangeColor),
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        _getAvatarUrl(),
                        height: 40,
                        width: 40,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset('assets/icn_user.png', height: 24);
                        },
                      ),
                    ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _isLoading ? 'User' : _getNameFromEmail(),
                  style: blackTextStyle.copyWith(
                    fontWeight: semiBold,
                    fontSize: 16,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      _coinBalance,
                      style: orangeTextStyle.copyWith(
                        fontWeight: semiBold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      ' SIGAP Points',
                      style: blackTextStyle.copyWith(
                        fontWeight: medium,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        IconButton(
          icon: Icon(Icons.menu, color: blackColor),
          onPressed: () {},
        ),
      ],
    );
  }
}
