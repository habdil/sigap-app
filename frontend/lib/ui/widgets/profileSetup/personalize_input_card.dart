import 'package:flutter/material.dart';
import 'package:frontend/shared/theme.dart';
import 'action_button.dart';

class PersonalizeInputCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final String placeholder;
  final TextEditingController controller;
  final VoidCallback onEnter;
  final bool isActive;
  final TextInputType keyboardType;
  final String? suffix;
  final IconData? icon;

  const PersonalizeInputCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.placeholder,
    required this.controller,
    required this.onEnter,
    this.isActive = true,
    this.keyboardType = TextInputType.text,
    this.suffix,
    this.icon,
  });

  @override
  State<PersonalizeInputCard> createState() => _PersonalizeInputCardState();
}

class _PersonalizeInputCardState extends State<PersonalizeInputCard> with SingleTickerProviderStateMixin {
  bool get hasValue => widget.controller.text.isNotEmpty;
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;
  
  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(
        parent: _animController,
        curve: Curves.easeInOut,
      ),
    );
  }
  
  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: widget.isActive ? 1.0 : 0.6,
      duration: const Duration(milliseconds: 300),
      child: MouseRegion(
        onEnter: (_) => _animController.forward(),
        onExit: (_) => _animController.reverse(),
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(24),
              border: widget.isActive 
                  ? Border.all(color: orangeColor, width: 2) 
                  : Border.all(color: Colors.transparent),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 15,
                  spreadRadius: 1,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with icon and title
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: widget.isActive 
                              ? orangeColor 
                              : Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          widget.icon ?? Icons.edit,
                          color: widget.isActive ? whiteColor : orangeColor,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.title,
                              style: blackTextStyle.copyWith(
                                fontSize: 18,
                                fontWeight: semiBold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              widget.subtitle,
                              style: greyTextStyle.copyWith(
                                fontSize: 13,
                                fontWeight: medium,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  if (widget.isActive) ...[
                    const SizedBox(height: 20),
                    // Input field
                    Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: orangeColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: TextField(
                                controller: widget.controller,
                                enabled: widget.isActive,
                                keyboardType: widget.keyboardType,
                                style: blackTextStyle.copyWith(
                                  fontSize: 18,
                                  fontWeight: semiBold,
                                ),
                                decoration: InputDecoration(
                                  hintText: widget.placeholder,
                                  hintStyle: greyTextStyle.copyWith(
                                    fontSize: 16,
                                    fontWeight: regular,
                                  ),
                                  border: InputBorder.none,
                                  suffix: widget.suffix != null
                                      ? Text(
                                          widget.suffix!,
                                          style: orangeTextStyle.copyWith(
                                            fontSize: 16,
                                            fontWeight: semiBold,
                                          ),
                                        )
                                      : null,
                                ),
                                onChanged: (_) => setState(() {}),
                                onSubmitted: (_) => hasValue ? widget.onEnter() : null,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Continue button
                    ActionButton(
                      text: 'Continue',
                      type: ActionButtonType.primary,
                      onPressed: widget.onEnter,
                      isEnabled: hasValue,
                      icon: Icons.arrow_forward_rounded,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}