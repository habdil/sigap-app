// Path: lib/ui/widgets/dashboard/chatbot/chat_message_bubble.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/shared/theme.dart';
import 'package:intl/intl.dart'; // For formatting date

class ChatMessageBubble extends StatelessWidget {
  final Map<String, dynamic> message;
  
  const ChatMessageBubble({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final bool isUser = message['isUser'] as bool;
    final String? timestamp = message['timestamp'];
    // Format timestamp if available
    if (timestamp != null) {
      try {
        DateTime.parse(timestamp);
// e.g. 3:30 PM
      } catch (e) {
        // If timestamp is in invalid format, just ignore it
      }
    }
    
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: message.containsKey('imageUrl') || message.containsKey('assetImage') 
            ? EdgeInsets.zero
            : const EdgeInsets.all(12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75, // Maximum width for better layout
        ),
        decoration: BoxDecoration(
          color: isUser 
              ? orangeColor.withOpacity(0.1) // Light orange for user messages
              : whiteColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: _buildMessageContent(context),
      ),
    );
  }
  
  Widget _buildMessageContent(BuildContext context) {
    if (message.containsKey('imageUrl')) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              message['imageUrl'],
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return SizedBox(
                  height: 200,
                  child: Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded / 
                              (loadingProgress.expectedTotalBytes ?? 1)
                          : null,
                      color: orangeColor,
                    ),
                  ),
                );
              },
            ),
            if (message.containsKey('text'))
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  message['text'],
                  style: blackTextStyle.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
      );
    } else if (message.containsKey('assetImage') && !message.containsKey('text')) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          message['assetImage'],
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (message.containsKey('assetImage'))
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                message['assetImage'],
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          if (message.containsKey('text'))
            Padding(
              padding: message.containsKey('assetImage') ? const EdgeInsets.all(12) : EdgeInsets.zero,
              child: Text(
                message['text'],
                style: blackTextStyle.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          if (message.containsKey('timestamp') && message['timestamp'] != null)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                DateFormat.jm().format(DateTime.parse(message['timestamp'])),
                style: greyTextStyle.copyWith(
                  fontSize: 10,
                ),
                textAlign: message['isUser'] ? TextAlign.right : TextAlign.left,
              ),
            ),
          if (!message['isUser'] && message['showActions'] == true) ...[
            const SizedBox(height: 12),
            const Divider(thickness: 1),
            const SizedBox(height: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.copy, color: Colors.grey, size: 20),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: message['text']));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Copied to clipboard')),
                    );
                  },
                ),
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(Icons.thumb_up_off_alt, color: Colors.grey, size: 20),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Glad you liked it!')),
                    );
                  },
                ),
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(Icons.thumb_down_off_alt, color: Colors.grey, size: 20),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Thanks for your feedback!')),
                    );
                  },
                ),
              ],
            ),
          ],
        ],
      );
    }
  }
}