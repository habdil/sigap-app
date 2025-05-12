import 'package:flutter/material.dart';
import 'package:frontend/blocs/user_bloc.dart';
import 'package:frontend/services/storage_service.dart';
import 'package:frontend/services/supabase_auth_service.dart';
import 'package:frontend/shared/navbar.dart';
import 'package:frontend/shared/theme.dart';
import 'package:frontend/ui/pages/auth/home_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              padding: const EdgeInsets.only(top: 60, bottom: 30),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    blueColor.withOpacity(0.8),
                    orangeColor.withOpacity(0.8),
                  ],
                ),
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRd55orZbXr-LibtYUPwBgV6AzfalQoSGTfHg&s',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Nama Pengguna',
                    style: whiteTextStyle.copyWith(
                      fontSize: 20,
                      fontWeight: semiBold,
                    ),
                  ),
                  Text(
                    'user@email.com',
                    style: whiteTextStyle.copyWith(
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 80),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                      child: Text(
                        'Edit Profil',
                        style: whiteTextStyle.copyWith(
                          fontWeight: semiBold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Profile Info
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selamat Datang di Halaman Profil',
                    style: blackTextStyle.copyWith(
                      fontSize: 18,
                      fontWeight: semiBold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Profile Details
                  Container(
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
                    child: Column(
                      children: [
                        _buildProfileItem('Umur', '30 tahun', Icons.cake),
                        const Divider(),
                        _buildProfileItem('Tinggi', '175.5 cm', Icons.height),
                        const Divider(),
                        _buildProfileItem('Berat', '70.2 kg', Icons.monitor_weight),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  Text(
                    'Ringkasan Kesehatan',
                    style: blackTextStyle.copyWith(
                      fontSize: 16,
                      fontWeight: semiBold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Health Summary
                  Container(
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
                    child: Column(
                      children: [
                        _buildHealthItem('Risiko Stroke', '68%', Colors.orange),
                        const SizedBox(height: 16),
                        Text(
                          'Faktor Risiko:',
                          style: blackTextStyle.copyWith(
                            fontWeight: semiBold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildRiskFactorItem('Pola Makan Buruk'),
                        _buildRiskFactorItem('Kurang Istirahat'),
                        _buildRiskFactorItem('Gaya Hidup Sedentari'),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        _handleLogout(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Keluar',
                        style: whiteTextStyle.copyWith(
                          fontWeight: semiBold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomNavBar(initialIndex: 3),
    );
  }

  Widget _buildProfileItem(String title, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            color: orangeColor,
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: blackTextStyle,
            ),
          ),
          Text(
            value,
            style: blackTextStyle.copyWith(
              fontWeight: semiBold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthItem(String title, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: blackTextStyle,
        ),
        Text(
          value,
          style: blackTextStyle.copyWith(
            fontWeight: bold,
            color: valueColor,
            fontSize: 18,
          ),
        ),
      ],
    );
  }

  Widget _buildRiskFactorItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: orangeColor,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: blackTextStyle,
          ),
        ],
      ),
    );
  }
}

void _handleLogout(BuildContext context) async {
  // Tampilkan dialog konfirmasi
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        'Konfirmasi',
        style: blackTextStyle.copyWith(
          fontWeight: semiBold,
        ),
      ),
      content: Text(
        'Apakah Anda yakin ingin keluar?',
        style: blackTextStyle,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Tutup dialog
          },
          child: Text(
            'Batal',
            style: greyTextStyle,
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            // Tutup dialog konfirmasi terlebih dahulu
            Navigator.pop(context);
            
            try {
              // Lakukan proses logout tanpa loading dialog untuk menghindari masalah
              
              // 1. Logout dari Supabase (jika menggunakan Supabase)
              final authService = SupabaseAuthService();
              await authService.signOut();
              
              // 2. Clear data di storage
              await StorageService.clearAll();
              
              // 3. Clear user state di bloc
              UserBloc().clearUser();
              
              // 4. Navigasi ke home page (dengan menghapus semua halaman sebelumnya)
              if (context.mounted) {
                // Navigasi ke HomePage dengan menghapus semua rute sebelumnya
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const HomePage(),
                  ),
                  (route) => false, // Hapus semua route sebelumnya
                );
              }
            } catch (e) {
              // Tangani error jika terjadi
              print('Error during logout: $e');
              
              if (context.mounted) {
                // Tampilkan pesan error
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Terjadi kesalahan saat logout: ${e.toString()}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
          ),
          child: Text(
            'Keluar',
            style: whiteTextStyle,
          ),
        ),
      ],
    ),
  );
}