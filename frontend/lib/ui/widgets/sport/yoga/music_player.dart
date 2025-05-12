import 'package:flutter/material.dart';
import 'package:frontend/shared/theme.dart';

class MusicPlayer extends StatelessWidget {
 final String currentSong;
 final bool isPlaying;
 final double progress;
 final VoidCallback onPlayToggle;
 final VoidCallback onPrevious;
 final VoidCallback onNext;

 const MusicPlayer({
   Key? key,
   required this.currentSong,
   required this.isPlaying,
   required this.progress,
   required this.onPlayToggle,
   required this.onPrevious,
   required this.onNext,
 }) : super(key: key);

 @override
 Widget build(BuildContext context) {
   return Container(
     width: double.infinity,
     margin: const EdgeInsets.symmetric(horizontal: 16.0),
     decoration: BoxDecoration(
       gradient: LinearGradient(
         colors: [Colors.blue.shade100, Colors.orange.shade100],
         begin: Alignment.centerLeft,
         end: Alignment.centerRight,
       ),
       borderRadius: BorderRadius.circular(16),
     ),
     child: Column(
       children: [
         // Progress bar
         ClipRRect(
           borderRadius: const BorderRadius.only(
             topLeft: Radius.circular(16),
             topRight: Radius.circular(16),
           ),
           child: LinearProgressIndicator(
             value: progress,
             backgroundColor: Colors.transparent,
             valueColor: AlwaysStoppedAnimation<Color>(Colors.orange.shade300),
             minHeight: 4,
           ),
         ),
         
         // Music controls
         Padding(
           padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
           child: Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               // Previous button
               GestureDetector(
                 onTap: onPrevious,
                 child: Container(
                   width: 40,
                   height: 40,
                   decoration: BoxDecoration(
                     color: Colors.white,
                     shape: BoxShape.circle,
                   ),
                   child: const Icon(
                     Icons.skip_previous,
                     size: 24,
                   ),
                 ),
               ),
               
               // Play/Pause button
               GestureDetector(
                 onTap: onPlayToggle,
                 child: Container(
                   width: 40,
                   height: 40,
                   decoration: BoxDecoration(
                     color: Colors.white,
                     shape: BoxShape.circle,
                   ),
                   child: Icon(
                     isPlaying ? Icons.pause : Icons.play_arrow,
                     size: 24,
                   ),
                 ),
               ),
               
               // Next button
               GestureDetector(
                 onTap: onNext,
                 child: Container(
                   width: 40,
                   height: 40,
                   decoration: BoxDecoration(
                     color: Colors.white,
                     shape: BoxShape.circle,
                   ),
                   child: const Icon(
                     Icons.skip_next,
                     size: 24,
                   ),
                 ),
               ),
             ],
           ),
         ),
         
         // Song info
         Padding(
           padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
           child: Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               Expanded(
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Text(
                       currentSong,
                       style: blackTextStyle.copyWith(
                         fontWeight: semiBold,
                         fontSize: 14,
                       ),
                       maxLines: 1,
                       overflow: TextOverflow.ellipsis,
                     ),
                     Text(
                       'Playing now...',
                       style: greyTextStyle.copyWith(
                         fontSize: 12,
                       ),
                     ),
                   ],
                 ),
               ),
               
               // Duration display
               Text(
                 '00:00',
                 style: blackTextStyle.copyWith(
                   fontWeight: medium,
                   fontSize: 12,
                 ),
               ),
             ],
           ),
         ),
       ],
     ),
   );
 }
}