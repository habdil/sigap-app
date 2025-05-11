import 'package:flutter/material.dart';

class CustomNotification {
  static void showNotification(
    BuildContext context, {
    required String title,
    required String message,
    required NotificationType type,
    Duration duration = const Duration(seconds: 3),
  }) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 50.0,
        left: 20.0,
        right: 20.0,
        child: Material(
          color: Colors.transparent,
          child: _buildNotificationWidget(title, message, type),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(duration, () {
      overlayEntry.remove();
    });
  }

  static Widget _buildNotificationWidget(
    String title,
    String message,
    NotificationType type,
  ) {
    Color backgroundColor;
    Color iconBackgroundColor;
    IconData iconData;
    Color borderColor;

    switch (type) {
      case NotificationType.success:
        backgroundColor = const Color(0xFFD1F3E9);
        iconBackgroundColor = const Color(0xFFFFFFFF);
        iconData = Icons.check_circle;
        borderColor = const Color(0xFF4CAF50);
        break;
      case NotificationType.error:
        backgroundColor = const Color(0xFFFEDDDD);
        iconBackgroundColor = const Color(0xFFFFFFFF);
        iconData = Icons.error;
        borderColor = const Color(0xFFE53935);
        break;
      case NotificationType.warning:
        backgroundColor = const Color(0xFFFFF3CD);
        iconBackgroundColor = const Color(0xFFFFFFFF);
        iconData = Icons.warning;
        borderColor = const Color(0xFFFFB74D);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: borderColor, width: 1.0),
      ),
      child: Row(
        children: [
          Container(
            width: 40.0,
            height: 40.0,
            decoration: BoxDecoration(
              color: iconBackgroundColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              iconData,
              color: borderColor,
              size: 24.0,
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: Color(0xFF666666),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              // Find the active overlay entry and remove it
              final overlays = Overlay.of(
                      GlobalObjectKey(title + message).currentContext!)
                  .mounted;
              if (overlays) {
                Navigator.of(
                        GlobalObjectKey(title + message).currentContext!)
                    .pop();
              }
            },
            child: const Icon(
              Icons.close,
              size: 20.0,
              color: Color(0xFF666666),
            ),
          ),
        ],
      ),
    );
  }
}

enum NotificationType {
  success,
  error,
  warning,
}

// Extension methods for easier usage
extension NotificationExtension on BuildContext {
  void showSuccessNotification({
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    CustomNotification.showNotification(
      this,
      title: title,
      message: message,
      type: NotificationType.success,
      duration: duration,
    );
  }

  void showErrorNotification({
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    CustomNotification.showNotification(
      this,
      title: title,
      message: message,
      type: NotificationType.error,
      duration: duration,
    );
  }

  void showWarningNotification({
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    CustomNotification.showNotification(
      this,
      title: title,
      message: message,
      type: NotificationType.warning,
      duration: duration,
    );
  }
}