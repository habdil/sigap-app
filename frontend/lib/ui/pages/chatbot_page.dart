import 'package:flutter/material.dart';
import 'package:frontend/shared/theme.dart';
import 'package:flutter/services.dart';

class ChatBotPage extends StatefulWidget {
  const ChatBotPage({super.key});

  @override
  State<ChatBotPage> createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  final List<Map<String, dynamic>> _messages = [];
  final TextEditingController _controller = TextEditingController();
  bool _showOptions = true;
  bool _showWelcomeMessage = true;

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({'text': text, 'isUser': true});
      _messages.add({'text': 'This is a dummy response from bot', 'isUser': false});
      _showOptions = false;
      _showWelcomeMessage = false;
    });

    _controller.clear();
  }

  void _handleOptionSelected(String option, String botResponse) {
    setState(() {
      _messages.add({'text': option, 'isUser': true});
      _messages.add({'text': botResponse, 'isUser': false});
      _showOptions = false;
      _showWelcomeMessage = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topLeft,
            radius: 2.5,
            colors: [
              whiteColor,
              blueColor.withOpacity(0.4),
              orangeColor.withOpacity(0.7),
              whiteColor,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: CircleAvatar(
                        backgroundColor: whiteColor,
                        child: Icon(Icons.arrow_back, color: blackColor),
                      ),
                    ),
                    Text(
                      "ChatBot",
                      style: blackTextStyle.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: whiteColor,
                      child: Icon(Icons.more_horiz, color: blackColor),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              
              if (_showWelcomeMessage)
                Column(
                  children: [
                    Text(
                      "Hello, User",
                      style: blackTextStyle.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: blackColor.withOpacity(0.6),
                      ),
                    ),
                    Text(
                      "How can I help you\ntoday?",
                      textAlign: TextAlign.center,
                      style: blackTextStyle.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: blackColor.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Theme(
                      data: Theme.of(context).copyWith(
                        chipTheme: ChipThemeData(
                          backgroundColor: whiteColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                      ),
                      child: Chip(
                        label: Text(
                          "Powered By Gemini",
                          style: blackTextStyle.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: blackColor.withOpacity(0.8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 16),

              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final message = _messages[index];
                    final isUser = message['isUser'] as bool;
                    return Align(
                      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: message.containsKey('imageUrl') || message.containsKey('assetImage') 
                            ? EdgeInsets.zero
                            : const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: message.containsKey('imageUrl')
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                message['imageUrl'],
                                width: 150,
                                height: 150,
                                fit: BoxFit.cover,
                              ),
                            )
                          : message.containsKey('assetImage')
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.asset(
                                  message['assetImage'],
                                  width: 150,
                                  height: 150,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (message.containsKey('assetImage'))
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.asset(
                                        message['assetImage'],
                                        width: 150,
                                        height: 150,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  if (message.containsKey('text'))
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Text(
                                        message['text'],
                                        style: blackTextStyle.copyWith(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    if (!isUser && message['showActions'] == true) ...[
                                      const SizedBox(height: 12),
                                      const Divider(thickness: 1),
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.copy, color: Colors.grey, size: 20),
                                            onPressed: () {
                                              Clipboard.setData(ClipboardData(text: message['text']));
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(content: Text('Copied to clipboard')),
                                              );
                                            },
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.thumb_up_off_alt, color: Colors.grey, size: 20),
                                            onPressed: () {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(content: Text('Glad you liked it!')),
                                              );
                                            },
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.thumb_down_off_alt, color: Colors.grey, size: 20),
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
                              ),
                      ),
                    );
                  },
                ),
              ),
              
              if (_showOptions)
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.start,
                  children: [
                    BotOptionButton(
                      label: "Breakfast Recomendation",
                      onTap: () {
                        _handleOptionSelected(
                          "Breakfast Recomendation", 
                          'For breakfast, I recommend oatmeal with fruits and nuts or yogurt with granola. Both are nutritious options!'
                        );
                      },
                    ),
                    BotOptionButton(
                      label: "Lunch Recomendation",
                      onTap: () {
                        _handleOptionSelected(
                          "Lunch Recomendation", 
                          'For lunch, try a balanced meal with protein, vegetables, and whole grains. A grilled chicken salad with quinoa is a great option!'
                        );
                      },
                    ),
                    BotOptionButton(
                      label: "Morning Excercises",
                      onTap: () {
                        _handleOptionSelected(
                          "Morning Excercises", 
                          'Start your day with simple stretches, followed by a 10-minute cardio and 5-minute core workout. Great for boosting energy!'
                        );
                      },
                    ),
                    BotOptionButton(
                      label: "Sleep Schedule",
                      onTap: () {
                        _handleOptionSelected(
                          "Sleep Schedule", 
                          'For better sleep, maintain a consistent schedule. Try to sleep and wake up at the same time daily, even on weekends.'
                        );
                      },
                    ),
                  ],
                ),
              const SizedBox(height: 26),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: whiteColor,
                      child: IconButton(
                        icon: Icon(Icons.add, color: blackColor),
                        onPressed: () {
                          setState(() {
                            _messages.add({
                              'assetImage': 'assets/img_chatbot.png',
                              'text': 'is this food healthy for my breakfast today?',
                              'isUser': true,
                            });
                            _messages.add({
                              'text': 'Eggs are an excellent choice for breakfast because they are rich in high-quality protein, which helps keep you full longer and provides steady energy throughout the morning. They also contain essential nutrients like vitamin B12, vitamin D, choline, and selenium, which support brain function, metabolism, and overall health.',
                              'isUser': false,
                              'showActions': true,
                            });
                            _showOptions = false;
                            _showWelcomeMessage = false;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(left: 15),
                        decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: TextField(
                          controller: _controller,
                          onSubmitted: (_) => _sendMessage(),
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            hintText: "Type a message...",
                            border: InputBorder.none,
                            suffixIcon: Padding(
                              padding: const EdgeInsets.all(0),
                              child: IconButton(
                                icon: Icon(Icons.send, color: blackColor),
                                onPressed: _sendMessage,
                              ),
                            ),
                            suffixIconConstraints: const BoxConstraints(
                              minHeight: 24,
                              minWidth: 24,
                            ),
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
      ),
    );
  }
}

class BotOptionButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const BotOptionButton({
    super.key, 
    required this.label, 
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: whiteColor,
      elevation: 2,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}