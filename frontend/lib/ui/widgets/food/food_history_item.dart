// lib/ui/widgets/food/food_history_item.dart
import 'package:flutter/material.dart';
import 'package:frontend/shared/theme.dart';
import 'package:frontend/models/food_model.dart';
import 'package:frontend/ui/pages/dashboard/food/scan_food_page.dart';
import 'package:frontend/ui/widgets/food/view_details.dart';

class FoodHistoryItem extends StatelessWidget {
  final FoodLog foodLog;

  const FoodHistoryItem({super.key, required this.foodLog});

  @override
  Widget build(BuildContext context) {
    // Menggunakan MediaQuery untuk mendapatkan ukuran layar
    final screenWidth = MediaQuery.of(context).size.width;
    final isPad = screenWidth > 600;
    
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate dynamic sizing based on layout constraints
        final cardWidth = constraints.maxWidth;
        
        // Ukuran image yang responsif berdasarkan ukuran kartu
        // Untuk tablet - image lebih kecil (25% dari lebar), untuk mobile lebih besar (30%)
        final imageWidthPercentage = isPad ? 0.25 : 0.3;
        final imageWidth = cardWidth * imageWidthPercentage;
        
        // Minimum dan maximum height yang responsif
        // Menambahkan sedikit margin bottom untuk mencegah overflow
        final minHeight = isPad ? 140.0 : 120.0;
        final maxHeight = isPad ? 180.0 : 150.0;
        
        return Container(
          // Tambahkan padding bottom untuk memberikan ruang ekstra dan menghindari overflow
          margin: EdgeInsets.only(bottom: isPad ? 16 : 12),
          constraints: BoxConstraints(
            minHeight: minHeight,
            // Kita kurangi sedikit max height untuk mencegah overflow
            maxHeight: maxHeight, 
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Food image with full height
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
                child: SizedBox(
                  width: imageWidth,
                  child: Image.asset(
                    'assets/img_salad.png', // Using placeholder image
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              ),
              // Food details - expanding untuk mengisi sisa ruang
              Expanded(
                child: Padding(
                  // Padding responsif berdasarkan ukuran layar
                  // Kurangi padding bottom sedikit untuk memberikan ruang ekstra
                  padding: EdgeInsets.fromLTRB(
                    isPad ? 16.0 : 12.0,
                    isPad ? 16.0 : 12.0,
                    isPad ? 16.0 : 12.0,
                    isPad ? 14.0 : 10.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // Gunakan spaceEvenly untuk distribusi ruang yang lebih baik
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    // Kurangi ukuran mainAxisSize menjadi min
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Food name with overflow handling - ukuran font responsif
                      Text(
                        foodLog.foodName,
                        style: blackTextStyle.copyWith(
                          fontSize: isPad ? 16 : 14,
                          fontWeight: semiBold,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      // Kurangi spacing vertikal untuk menghemat ruang
                      SizedBox(height: isPad ? 5 : 3),
                      
                      // Time row with actual log date - ukuran font responsif
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: isPad ? 14 : 12,
                            color: Colors.grey,
                          ),
                          SizedBox(width: isPad ? 6 : 4),
                          Expanded(
                            child: Text(
                              foodLog.logDate != null 
                                ? '${foodLog.logDate!.day}/${foodLog.logDate!.month}/${foodLog.logDate!.year}'
                                : 'Today',
                              style: greyTextStyle.copyWith(
                                fontSize: isPad ? 12 : 10,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      
                      // Notes if available - hanya tampilkan jika benar-benar perlu
                      if (foodLog.notes != null && foodLog.notes!.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(top: isPad ? 5 : 3),
                          child: Text(
                            foodLog.notes!,
                            style: greyTextStyle.copyWith(
                              fontSize: isPad ? 12 : 10,
                            ),
                            overflow: TextOverflow.ellipsis,
                            // Hanya tampilkan 1 baris untuk menghemat ruang
                            maxLines: 1,
                          ),
                        ),
                      
                      // Kurangi spacing vertikal untuk menghemat ruang
                      SizedBox(height: isPad ? 8 : 5),
                      
                      // Nutrient info dengan Wrap yang efisien
                      if (foodLog.analysis != null)
                        Wrap(
                          // Kurangi spacing untuk menghemat ruang
                          spacing: isPad ? 10 : 6,
                          runSpacing: isPad ? 4 : 2,
                          children: [
                            _buildNutrientInfo('${foodLog.analysis!.proteinGrams}g protein', isPad),
                            _buildNutrientInfo('${foodLog.analysis!.calories} kal', isPad),
                            _buildNutrientInfo('${foodLog.analysis!.fatGrams}g fat', isPad),
                          ],
                        )
                      else
                        Text(
                          'No analysis available',
                          style: greyTextStyle.copyWith(
                            fontSize: isPad ? 12 : 10,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      
                      // Kurangi spacing vertikal untuk menghemat ruang
                      SizedBox(height: isPad ? 8 : 5),
                      
                      // Button dalam container dengan alignment
                      Align(
                        alignment: Alignment.centerRight,
                        child: foodLog.analysis == null
                            ? _buildAnalyzeButton(context, isPad)
                            : _buildViewDetailsButton(context, isPad),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  
  // Helper widget for nutrient info - dengan ukuran yang lebih compact
  Widget _buildNutrientInfo(String text, bool isPad) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isPad ? 8 : 6, 
        vertical: isPad ? 4 : 3
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: blackTextStyle.copyWith(
          fontSize: isPad ? 13 : 11,
          fontWeight: medium,
        ),
      ),
    );
  }
  
  // Button to analyze food - dengan ukuran yang lebih compact
  Widget _buildAnalyzeButton(BuildContext context, bool isPad) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ScanFoodPage(foodLogId: foodLog.id!),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isPad ? 16 : 12,
          vertical: isPad ? 8 : 6,
        ),
        decoration: BoxDecoration(
          color: orangeColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.camera_alt,
              color: Colors.white,
              size: isPad ? 16 : 14,
            ),
            SizedBox(width: isPad ? 5 : 3),
            Text(
              'analyze food',
              style: whiteTextStyle.copyWith(
                fontSize: isPad ? 14 : 12,
                fontWeight: medium,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // Button to view details - dengan ukuran yang lebih compact
  Widget _buildViewDetailsButton(BuildContext context, bool isPad) {
    return GestureDetector(
      onTap: () {
        // Show food details dialog
        FoodDetailsView.show(context, foodLog);
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isPad ? 16 : 12,
          vertical: isPad ? 8 : 6,
        ),
        decoration: BoxDecoration(
          color: blueColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.visibility,
              color: Colors.white,
              size: isPad ? 16 : 14,
            ),
            SizedBox(width: isPad ? 5 : 3),
            Text(
              'view details',
              style: whiteTextStyle.copyWith(
                fontSize: isPad ? 14 : 12,
                fontWeight: medium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}