// frontend/lib/ui/widgets/dashboard/profile/sigap_coins_card.dart
import 'package:flutter/material.dart';
import 'package:frontend/shared/theme.dart';
import 'package:frontend/services/coin_service.dart';
import 'package:frontend/models/coin_model.dart';
import 'package:frontend/models/coin_transaction_model.dart';
import 'package:intl/intl.dart'; // Untuk memformat angka dengan koma

class SigapCoinsCard extends StatefulWidget {
  final int targetCoins; // Target coins untuk progress bar
  
  const SigapCoinsCard({
    super.key, 
    this.targetCoins = 20000, // Default target adalah 20.000 coins
  });

  @override
  State<SigapCoinsCard> createState() => _SigapCoinsCardState();
}

class _SigapCoinsCardState extends State<SigapCoinsCard> {
  bool _isLoading = true;
  String _errorMessage = '';
  CoinModel? _coinData;
  List<CoinTransactionModel> _recentTransactions = [];
  bool _isLoadingTransactions = false;

  // Format angka dengan koma sebagai pemisah ribuan
  final NumberFormat _formatter = NumberFormat('#,###');

  @override
  void initState() {
    super.initState();
    _fetchUserCoins();
  }

  // Mendapatkan data koin pengguna
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

        // Setelah mendapatkan coin, ambil juga riwayat transaksi
        _fetchTransactions();
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

  // Mendapatkan riwayat transaksi koin
  Future<void> _fetchTransactions() async {
    try {
      setState(() {
        _isLoadingTransactions = true;
      });

      final result = await CoinService.getTransactions();
      
      if (result['success']) {
        setState(() {
          _recentTransactions = result['data'];
          _isLoadingTransactions = false;
        });
      } else {
        print('Error fetching transactions: ${result['message']}');
        setState(() {
          _isLoadingTransactions = false;
        });
      }
    } catch (e) {
      print('Exception in _fetchTransactions: $e');
      setState(() {
        _isLoadingTransactions = false;
      });
    }
  }

  // Menghitung persentase progress koin terhadap target
  double _calculateProgress() {
    if (_coinData == null || _coinData!.totalCoins <= 0) {
      return 0.0;
    }
    
    double progress = _coinData!.totalCoins / widget.targetCoins;
    
    // Pastikan tidak melebihi 1.0 (100%)
    if (progress > 1.0) {
      return 1.0;
    }
    
    return progress;
  }

  // Mencari item hadiah terdekat berdasarkan koin yang dimiliki
  Map<String, dynamic> _getNextReward() {
    // Daftar hadiah yang tersedia dengan jumlah koin yang diperlukan
    final rewards = [
      {'name': 'Sigap T-Shirt', 'coins': 5000},
      {'name': 'Sigap Water Bottle', 'coins': 10000},
      {'name': 'Sigap Shoes', 'coins': 15000},
      {'name': 'Sigap Smart Watch', 'coins': 20000},
      {'name': 'Sigap Pro Membership', 'coins': 30000},
    ];
    
    // Jika tidak ada data koin, kembalikan hadiah pertama
    if (_coinData == null) {
      return rewards.first;
    }
    
    // Cari hadiah terdekat yang belum dicapai
    for (var reward in rewards) {
      if ((reward['coins'] != null && _coinData!.totalCoins != null) && (reward['coins'] as int > _coinData!.totalCoins)) {
        return reward;
      }
    }
    
    // Jika semua hadiah sudah tercapai, kembalikan yang terakhir
    return rewards.last;
  }

  // Format angka koin dengan pemisah ribuan
  String _formatCoins(int coins) {
    return _formatter.format(coins);
  }

  @override
  Widget build(BuildContext context) {
    // Dapatkan hadiah berikutnya
    final nextReward = _getNextReward();
    
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
                        _formatCoins(_coinData?.totalCoins ?? 0),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF7A45),
                        ),
                      ),
                    ],
                  ),
            ],
          ),
          const SizedBox(height: 8),
          
          // Progress target text
          if (!_isLoading && _coinData != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Target: ${_formatCoins(widget.targetCoins)} coins',
                    style: greyTextStyle.copyWith(
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    '${(_calculateProgress() * 100).toInt()}%',
                    style: blackTextStyle.copyWith(
                      fontSize: 12,
                      fontWeight: medium,
                    ),
                  ),
                ],
              ),
            ),
          
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
                    widthFactor: _calculateProgress(),
                    child: Container(
                      decoration: const BoxDecoration(
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
              _buildSmallButton(
                'Your Points', 
                Colors.grey.shade200,
                onTap: () {
                  // Tambahkan navigasi ke halaman riwayat koin jika diperlukan
                }
              ),
              _buildSmallButton(
                'GET: ${nextReward['name']}', 
                const Color(0xFFFF7A45),
                textColor: Colors.white, 
                fontSize: 12,
                onTap: () {
                  // Tampilkan dialog informasi hadiah
                  _showRewardInfoDialog(nextReward);
                }
              ),
            ],
          ),
          
          // Tampilkan transaksi terakhir jika ada
          if (_recentTransactions.isNotEmpty && !_isLoadingTransactions)
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recent Activity',
                    style: blackTextStyle.copyWith(
                      fontSize: 14,
                      fontWeight: semiBold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildLatestTransaction(),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // Widget untuk menampilkan transaksi terakhir
  Widget _buildLatestTransaction() {
    if (_recentTransactions.isEmpty) {
      return const SizedBox.shrink();
    }

    // Ambil transaksi paling baru
    final latestTransaction = _recentTransactions.first;
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                latestTransaction.transactionType,
                style: blackTextStyle.copyWith(
                  fontSize: 13,
                  fontWeight: medium,
                ),
              ),
              if (latestTransaction.createdAt != null)
                Text(
                  _formatDateTime(latestTransaction.createdAt!),
                  style: greyTextStyle.copyWith(
                    fontSize: 11,
                  ),
                ),
            ],
          ),
          Row(
            children: [
              Icon(
                latestTransaction.amount > 0 ? Icons.arrow_upward : Icons.arrow_downward,
                size: 14,
                color: latestTransaction.amount > 0 ? Colors.green : Colors.red,
              ),
              const SizedBox(width: 4),
              Text(
                '${latestTransaction.amount > 0 ? '+' : ''}${latestTransaction.amount}',
                style: blackTextStyle.copyWith(
                  fontSize: 14,
                  fontWeight: semiBold,
                  color: latestTransaction.amount > 0 ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Format tanggal dan waktu
  String _formatDateTime(DateTime dateTime) {
    // Format: 22 May, 10:30 AM
    return '${dateTime.day} ${_getMonthName(dateTime.month)}, ${_formatTimeOfDay(dateTime)}';
  }

  // Mendapatkan nama bulan
  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

  // Format waktu
  String _formatTimeOfDay(DateTime dateTime) {
    final hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
  }

  // Widget button kecil
  Widget _buildSmallButton(String text, Color bgColor, {
    Color? textColor, 
    double? fontSize,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
      ),
    );
  }

  // Dialog informasi hadiah
  void _showRewardInfoDialog(Map<String, dynamic> reward) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          reward['name'],
          style: blackTextStyle.copyWith(
            fontSize: 18,
            fontWeight: semiBold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Required coins: ${_formatCoins(reward['coins'])}',
              style: blackTextStyle.copyWith(
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            if (_coinData != null) ...[
              _coinData!.totalCoins >= reward['coins']
                ? Text(
                    'You have enough coins to redeem this reward!',
                    style: blackTextStyle.copyWith(
                      fontSize: 14,
                      color: Colors.green,
                    ),
                  )
                : Text(
                    'You need ${_formatCoins(reward['coins'] - _coinData!.totalCoins)} more coins to redeem this reward.',
                    style: blackTextStyle.copyWith(
                      fontSize: 14,
                      color: Colors.orange,
                    ),
                  ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: greyTextStyle,
            ),
          ),
          if (_coinData != null && _coinData!.totalCoins >= reward['coins'])
            ElevatedButton(
              onPressed: () {
                // Implementasi untuk menukarkan hadiah
                Navigator.pop(context);
                // Tambahkan logika untuk menukarkan hadiah
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF7A45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Redeem Now',
                style: whiteTextStyle.copyWith(
                  fontWeight: medium,
                ),
              ),
            ),
        ],
      ),
    );
  }
}