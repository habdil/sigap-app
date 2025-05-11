import 'package:flutter/material.dart';
import 'package:frontend/shared/theme.dart';

class HeaderSection extends StatelessWidget {
  final TextEditingController thoughtsController;
  final VoidCallback onSubmitThoughts;

  const HeaderSection({
    Key? key,
    required this.thoughtsController,
    required this.onSubmitThoughts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 410,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            blueColor.withOpacity(0.8),
            orangeColor.withOpacity(0.8),
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundImage: NetworkImage(
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRd55orZbXr-LibtYUPwBgV6AzfalQoSGTfHg&s',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Daily Mindfulness Check-in',
              style: whiteTextStyle.copyWith(
                  fontWeight: light, fontSize: 14),
            ),
            const SizedBox(height: 10),
            Text(
              'Hello, User 👋',
              style: whiteTextStyle.copyWith(
                  fontWeight: semiBold, fontSize: 24),
            ),
            const SizedBox(height: 10),
            Text(
              "Let's Track Your Progress,\nHow Are You Feeling \nToday?",
              style: whiteTextStyle.copyWith(
                  fontWeight: light, fontSize: 24),
            ),
            const SizedBox(height: 20),
            Container(
              height: 60,
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(35)),
              child: TextField(
                controller: thoughtsController,
                decoration: InputDecoration(
                  hintText: 'Your Thoughts...',
                  hintStyle: greyTextStyle.copyWith(
                      fontSize: 17, fontWeight: light, height: 1.0),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 35,
                      vertical: 20,
                  ),
                  suffixIcon: GestureDetector(
                    onTap: onSubmitThoughts,
                    child: Container(
                      width: 55,
                      height: 50,
                      margin: const EdgeInsets.only(right: 5),
                      decoration: BoxDecoration(
                          color: const Color(0xFFFFA726),
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(26)),
                      child: Transform.rotate(
                        angle: -0.785398,
                        child: const Icon(Icons.arrow_forward,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}