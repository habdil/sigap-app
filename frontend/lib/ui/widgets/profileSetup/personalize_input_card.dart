import 'package:flutter/material.dart';
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

  const PersonalizeInputCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.placeholder,
    required this.controller,
    required this.onEnter,
    this.isActive = true,
    this.keyboardType = TextInputType.text,
    this.suffix,
  }) : super(key: key);

  @override
  State<PersonalizeInputCard> createState() => _PersonalizeInputCardState();
}

class _PersonalizeInputCardState extends State<PersonalizeInputCard> {
  bool get hasValue => widget.controller.text.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: widget.isActive ? 1.0 : 0.5,
      duration: const Duration(milliseconds: 300),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.subtitle,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Container(
              height: 55,
              decoration: BoxDecoration(
                color: const Color(0xFFFE8A3B),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        controller: widget.controller,
                        enabled: widget.isActive,
                        keyboardType: widget.keyboardType,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          hintText: widget.placeholder,
                          hintStyle: const TextStyle(
                            color: Colors.white70,
                          ),
                          border: InputBorder.none,
                          suffix: widget.suffix != null
                              ? Text(
                                  widget.suffix!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                              : null,
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                  ),
                  if (widget.isActive)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ActionButton(
                        text: 'Enter',
                        type: ActionButtonType.enter,
                        onPressed: widget.onEnter,
                        isEnabled: hasValue,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}