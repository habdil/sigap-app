import 'package:flutter/material.dart';
import 'package:frontend/shared/theme.dart';

/// Redeem points section header
class RedeemPointsHeader extends StatelessWidget {
  final VoidCallback? onSeeMoreTap;
  
  const RedeemPointsHeader({Key? key, this.onSeeMoreTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Redeem ',
                  style: blackTextStyle.copyWith(
                    fontWeight: medium, 
                    fontSize: 16
                  ),
                ),
                TextSpan(
                  text: 'Points',
                  style: blackTextStyle.copyWith(
                    fontWeight: bold,
                    fontSize: 16
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onSeeMoreTap,
            child: Text(
              'see more',
              style: orangeTextStyle.copyWith(
                fontWeight: medium,
                fontSize: 16
              ),
            ),
          ),
        ],
      ),
    );
  }
}