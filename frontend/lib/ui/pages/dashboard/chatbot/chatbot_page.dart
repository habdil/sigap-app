// Path: lib/ui/pages/dashboard/chatbot/chatbot_page.dart
import 'package:flutter/material.dart';
import 'package:frontend/shared/theme.dart';
import 'package:provider/provider.dart';
import 'package:frontend/providers/chatbot_provider.dart';
import 'package:frontend/ui/widgets/dashboard/chatbot/chatbot_header.dart';
import 'package:frontend/ui/widgets/dashboard/chatbot/chatbot_welcome_message.dart';
import 'package:frontend/ui/widgets/dashboard/chatbot/chatbot_options_list.dart';
import 'package:frontend/ui/widgets/dashboard/chatbot/chatbot_message_input.dart';
import 'package:frontend/ui/widgets/dashboard/chatbot/chat_message_bubble.dart';

class ChatBotPage extends StatefulWidget {
  final int? conversationId; // Optional, if we want to load existing conversation

  const ChatBotPage({super.key, this.conversationId});

  @override
  State<ChatBotPage> createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  final TextEditingController _controller = TextEditingController();
  bool _showOptions = true;
  bool _showWelcomeMessage = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    
    // Load conversation if ID is provided
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<ChatbotProvider>(context, listen: false);
      
      if (widget.conversationId != null) {
        provider.loadConversation(widget.conversationId!);
        // Hide welcome message and options if loading existing conversation
        setState(() {
          _showWelcomeMessage = false;
          _showOptions = false;
        });
      } else {
        // For new conversation, we'll start with welcome message
        setState(() {
          _showWelcomeMessage = true;
          _showOptions = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Scroll to bottom after sending messages
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  // Send message to the chatbot
  void _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    _controller.clear();
    
    // Hide welcome message and options after first message
    setState(() {
      _showWelcomeMessage = false;
      _showOptions = false;
    });

    // Get provider and send message
    final provider = Provider.of<ChatbotProvider>(context, listen: false);
    await provider.sendMessage(text);
    
    // Scroll down after message is sent
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  // Handle when a predefined option is selected
  void _handleOptionSelected(String option, String botResponse) async {
    // Hide options after selection
    setState(() {
      _showWelcomeMessage = false;
      _showOptions = false;
    });

    // Send the selected option as a message
    final provider = Provider.of<ChatbotProvider>(context, listen: false);
    await provider.sendMessage(option);
    
    // Scroll down after message is sent
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  // Handle attachment button press
  void _handleAttachment() {
    // This is a placeholder for future feature
    // For now, just show a dialog about uploading images
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Upload Image', style: blackTextStyle.copyWith(
            fontWeight: semiBold,
            fontSize: 18,
          )),
          content: Text(
            'Image upload will be supported in future updates. You can still chat with text!',
            style: blackTextStyle.copyWith(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK', style: orangeTextStyle),
            ),
          ],
        );
      },
    );
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
              
              // Header
              ChatbotHeader(
                onBack: () => Navigator.pop(context),
                onMore: () {
                  // Show options menu
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: Icon(Icons.refresh, color: orangeColor),
                              title: Text('New Conversation', style: blackTextStyle),
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (_) => const ChatBotPage()),
                                );
                              },
                            ),
                            if (Provider.of<ChatbotProvider>(context).currentConversation != null)
                              ListTile(
                                leading: Icon(Icons.delete, color: Colors.red),
                                title: Text('Delete Conversation', style: blackTextStyle),
                                onTap: () async {
                                  final provider = Provider.of<ChatbotProvider>(context, listen: false);
                                  final conversationId = provider.currentConversation!.id;
                                  
                                  Navigator.pop(context); // Close bottom sheet
                                  
                                  final result = await provider.deleteConversation(conversationId);
                                  
                                  if (result) {
                                    Navigator.pop(context); // Go back to previous screen
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Failed to delete conversation')),
                                    );
                                  }
                                },
                              ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
              
              const SizedBox(height: 28),
              
              // Welcome Message
              if (_showWelcomeMessage)
                const ChatbotWelcomeMessage(),
              
              const SizedBox(height: 16),

              // Chat Messages
              Expanded(
                child: Consumer<ChatbotProvider>(
                  builder: (context, chatbotProvider, child) {
                    // Show loading indicator
                    if (chatbotProvider.isLoading && chatbotProvider.messages.isEmpty) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: orangeColor,
                        ),
                      );
                    }

                    // Show messages
                    final messages = chatbotProvider.messagesUiFormat;
                    
                    return ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: messages.length + (chatbotProvider.isLoading ? 1 : 0),
                      itemBuilder: (context, index) {
                        // Loading indicator at the end
                        if (chatbotProvider.isLoading && index == messages.length) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: whiteColor,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: orangeColor,
                                    strokeWidth: 2,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                        
                        return ChatMessageBubble(message: messages[index]);
                      },
                    );
                  },
                ),
              ),
              
              // Quick Options
              if (_showOptions)
                ChatbotOptionsList(
                  onOptionSelected: _handleOptionSelected,
                ),
              
              // Error Message
              Consumer<ChatbotProvider>(
                builder: (context, chatbotProvider, child) {
                  if (chatbotProvider.error != null) {
                    // Auto-dismiss error after some time
                    Future.delayed(const Duration(seconds: 3), () {
                      if (mounted) {
                        chatbotProvider.clearError();
                      }
                    });
                    
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline, color: Colors.red, size: 16),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              chatbotProvider.error!,
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => chatbotProvider.clearError(),
                            child: Icon(Icons.close, color: Colors.red, size: 16),
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              
              const SizedBox(height: 8),
              
              // Input Field
              ChatbotMessageInput(
                controller: _controller,
                onSend: _sendMessage,
                onAttachment: _handleAttachment,
              ),
            ],
          ),
        ),
      ),
    );
  }
}