// lib/ui/widgets/dashboard/profile/logout.dart
import 'package:flutter/material.dart';
import 'package:frontend/services/storage_service.dart';
import 'package:frontend/shared/theme.dart';
import 'package:frontend/services/supabase_auth_service.dart';
import 'package:frontend/ui/pages/auth/home_page.dart';
import 'package:frontend/blocs/user_bloc.dart';
import 'package:frontend/shared/notification.dart';

class LogoutButton extends StatelessWidget {
  final bool showIcon;
  final double? width;
  final double height;
  final double borderRadius;
  final EdgeInsetsGeometry? margin;
  final TextStyle? textStyle;
  
  const LogoutButton({
    Key? key,
    this.showIcon = true,
    this.width,
    this.height = 50,
    this.borderRadius = 10,
    this.margin,
    this.textStyle,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      child: ElevatedButton.icon(
        onPressed: () => _showLogoutConfirmation(context),
        icon: showIcon ? Icon(Icons.logout, color: Colors.white) : SizedBox.shrink(),
        label: Text(
          'Logout',
          style: textStyle ?? whiteTextStyle.copyWith(
            fontSize: 16,
            fontWeight: medium,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
      ),
    );
  }
  
  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout', style: blackTextStyle.copyWith(fontWeight: semiBold)),
          content: Text(
            'Are you sure you want to logout?',
            style: blackTextStyle,
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel', style: greyTextStyle),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Logout', style: TextStyle(color: Colors.red)),
              onPressed: () {
                _handleLogout(context);
              },
            ),
          ],
        );
      },
    );
  }
  
  Future<void> _handleLogout(BuildContext context) async {
    try {
      // Tampilkan loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );
      
      // Gunakan SupabaseAuthService untuk signOut
      // Ini akan menangani semua proses logout termasuk:
      // 1. Logout dari Supabase
      // 2. Menghapus semua data lokal melalui StorageService.clearAll()
      // 3. Membersihkan UserBloc
      final supabaseAuthService = SupabaseAuthService();
      await supabaseAuthService.signOut();
      
      debugPrint('✅ Logout berhasil dilakukan');
      
      // Tutup loading dialog
      Navigator.of(context).pop();
      
      // Tutup konfirmasi dialog
      Navigator.of(context).pop();
      
      // Tampilkan notifikasi sukses
      context.showSuccessNotification(
        title: 'Logout Berhasil',
        message: 'Anda telah berhasil keluar dari aplikasi',
      );
      
      // Arahkan ke halaman login/home dan hapus semua rute sebelumnya
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const HomePage()),
        (Route<dynamic> route) => false,
      );
      
    } catch (e) {
      debugPrint('❌ Error selama proses logout: $e');
      
      // Jika error saat menggunakan SupabaseAuthService, coba fallback ke metode manual
      try {
        // Tutup loading dialog
        Navigator.of(context).pop();
        
        // Coba fallback dengan metode manual
        debugPrint('ℹ️ Mencoba metode manual logout...');
        
        // Hapus semua data lokal
        await StorageService.clearAll();
        
        // Hapus data user dari bloc
        UserBloc().clearUser();
        
        // Tutup konfirmasi dialog
        Navigator.of(context).pop();
        
        // Arahkan ke halaman login/home
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomePage()),
          (Route<dynamic> route) => false,
        );
        
        debugPrint('✅ Fallback logout berhasil');
        
      } catch (fallbackError) {
        debugPrint('❌ Fallback logout juga gagal: $fallbackError');
        
        // Tutup semua dialog
        Navigator.of(context).pop(); // Close loading dialog if still open
        Navigator.of(context).pop(); // Close confirmation dialog
        
        // Tampilkan pesan error
        context.showErrorNotification(
          title: 'Logout Gagal',
          message: 'Terjadi kesalahan saat logout. Silakan coba lagi.',
        );
      }
    }
  }
}