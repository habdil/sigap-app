import 'package:flutter/material.dart';
import 'package:frontend/shared/theme.dart';

class ElegantLoading extends StatelessWidget {
  final String? message;
  
  const ElegantLoading({
    Key? key, 
    this.message,
  }) : super(key: key);

  // Menampilkan loading dalam dialog dengan penanganan error yang lebih baik
  static void show(BuildContext context, {String? message}) {
    try {
      // Verifikasi context masih valid
      if (context is BuildContext && context.mounted) {
        // Gunakan showDialog dengan barrierDismissible: false
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (dialogContext) => ElegantLoading(message: message),
        ).catchError((e) {
          // Ignore errors when showing dialog
          print('Error showing loading dialog: $e');
        });
      }
    } catch (e) {
      print('Error showing loading: $e');
      // Just ignore the error
    }
  }
  
  // Method untuk menutup loading dengan aman
  static void dismiss(BuildContext context) {
    try {
      // Verifikasi context masih valid
      if (context is BuildContext && context.mounted) {
        // Coba maybePop untuk lebih aman
        Navigator.of(context).maybePop().catchError((e) {
          // Ignore errors when dismissing dialog
          print('Error dismissing loading dialog: $e');
        });
      }
    } catch (e) {
      print('Error dismissing loading: $e');
      // Just ignore the error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: blackColor.withOpacity(0.1),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Loading indicator with custom animation
              SizedBox(
                width: 60,
                height: 60,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer circle
                    CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(orangeColor),
                    ),
                    // Inner circle
                    Container(
                      width: 45,
                      height: 45,
                      child: CircularProgressIndicator(
                        strokeWidth: 4,
                        valueColor: AlwaysStoppedAnimation<Color>(blueColor),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Loading message
              if (message != null)
                Text(
                  message!,
                  style: blackTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: medium,
                  ),
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        ),
      ),
    );
  }
}