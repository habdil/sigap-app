import 'package:flutter/material.dart';

/// History activity item card
class HistoryActivityItem extends StatelessWidget {
  final String day;
  final String activity;
  final double distance;
  final int duration;
  final String title;
  final int steps;
  final Color bgColor;

  const HistoryActivityItem({
    Key? key,
    required this.day,
    required this.activity,
    required this.distance,
    required this.duration,
    required this.title,
    required this.steps,
    required this.bgColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsive sizing
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = screenWidth < 360 ? 0.9 : 1.0; // Scale factor for font sizes
    
    return Container(
      padding: EdgeInsets.only(
        left: 12 * fontSize, 
        right: 12 * fontSize, 
        bottom: 12 * fontSize, 
        top: 16 * fontSize
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: bgColor == Colors.white ? Border.all(color: Colors.grey.shade300) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                day, 
                style: TextStyle(
                  fontSize: 10 * fontSize, 
                  fontWeight: FontWeight.bold, 
                  color: bgColor == Colors.white ? Colors.black : Colors.white
                )
              ),
              if (activity != 'YOGA') 
                Text(
                  '$distance km', 
                  style: TextStyle(
                    fontSize: 10 * fontSize, 
                    color: bgColor == Colors.white ? Colors.black : Colors.white
                  )
                ),
            ],
          ),
          SizedBox(height: 4 * fontSize),
          Container(
            height: 4, 
            decoration: BoxDecoration(
              color: bgColor == Colors.white ? Colors.orange : Colors.white, 
              borderRadius: BorderRadius.circular(2)
            )
          ),
          SizedBox(height: 4 * fontSize),
          Text(
            activity, 
            style: TextStyle(
              fontSize: 10 * fontSize, 
              color: bgColor == Colors.white ? Colors.black : Colors.white
            )
          ),
          const Spacer(),
          Text(
            '$duration min', 
            style: TextStyle(
              fontSize: 24 * fontSize, 
              fontWeight: FontWeight.bold, 
              color: bgColor == Colors.white ? Colors.black : Colors.white
            )
          ),
          Text(
            title, 
            style: TextStyle(
              fontSize: 14 * fontSize, 
              color: bgColor == Colors.white ? Colors.black : Colors.white
            )
          ),
          const Spacer(),
          SizedBox(height: 8 * fontSize),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$steps', 
                style: TextStyle(
                  fontSize: 12 * fontSize, 
                  fontWeight: FontWeight.bold, 
                  color: bgColor == Colors.white ? Colors.black : Colors.white
                )
              ),
              Row(
                children: [
                  Icon(
                    Icons.monetization_on, 
                    size: 12 * fontSize, 
                    color: bgColor == Colors.white ? Colors.amber : Colors.white
                  ), 
                  SizedBox(width: 2 * fontSize), 
                  Text(
                    '+$steps', 
                    style: TextStyle(
                      fontSize: 10 * fontSize, 
                      color: bgColor == Colors.white ? Colors.orange : Colors.white
                    )
                  )
                ]
              ),
            ],
          ),
          Text(
            'steps', 
            style: TextStyle(
              fontSize: 10 * fontSize, 
              color: bgColor == Colors.white ? Colors.black : Colors.white
            )
          ),
        ],
      ),
    );
  }
}