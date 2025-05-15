import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:frontend/shared/theme.dart';
import 'package:frontend/models/activity_model.dart';
import 'package:frontend/blocs/activity_bloc.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

/// Today's activity section with chart and step count
class TodayActivitySection extends StatefulWidget {
  const TodayActivitySection({Key? key}) : super(key: key);

  @override
  State<TodayActivitySection> createState() => _TodayActivitySectionState();
}

class _TodayActivitySectionState extends State<TodayActivitySection> {
  @override
  void initState() {
    super.initState();
    // Muat data aktivitas saat widget diinisialisasi
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final activityBloc = Provider.of<ActivityBloc>(context, listen: false);
      activityBloc.getActivities();
    });
  }
  
  // Filter untuk aktivitas hari ini - Dimodifikasi untuk mencakup semua aktivitas (untuk debugging)
  List<ActivityModel> _getTodayActivities(List<ActivityModel> allActivities) {
    // Untuk debugging, tampilkan semua aktivitas terlebih dahulu
    print('Debug: Total aktivitas: ${allActivities.length}');
    
    if (allActivities.isEmpty) {
      print('Debug: Tidak ada aktivitas ditemukan');
      return [];
    }
    
    // Cetak detail semua aktivitas untuk debugging
    for (var activity in allActivities) {
      print('Debug: Aktivitas ID=${activity.id}, Type=${activity.activityType}, Date=${activity.activityDate}, Distance=${activity.distanceKm}, Calories=${activity.caloriesBurned}, Coins=${activity.coinsEarned}');
    }
    
    // Jika tanggal tidak penting untuk saat ini, kembalikan semua aktivitas
    return allActivities;
    
    // Kode filter asli jika dibutuhkan nanti:
    /*
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    return allActivities.where((activity) {
      if (activity.activityDate == null) return false;
      final activityDay = DateTime(
        activity.activityDate!.year,
        activity.activityDate!.month,
        activity.activityDate!.day
      );
      return activityDay.isAtSameMomentAs(today);
    }).toList();
    */
  }
  
  // Hitung total jarak aktivitas (semua jenis aktivitas)
  double _calculateTotalDistance(List<ActivityModel> activities) {
    if (activities.isEmpty) return 0;
    
    double total = activities.fold(
      0.0, 
      (sum, activity) => sum + (activity.distanceKm ?? 0)
    );
    
    print('Debug: Total jarak: $total km');
    return total;
  }
  
  // Hitung total kalori yang dibakar
  int _calculateTotalCalories(List<ActivityModel> activities) {
    if (activities.isEmpty) return 0;
    
    int total = activities.fold(
      0, 
      (sum, activity) => sum + (activity.caloriesBurned ?? 0)
    );
    
    print('Debug: Total kalori: $total kcal');
    return total;
  }
  
  // Hitung total koin yang diperoleh
  int _calculateTotalCoins(List<ActivityModel> activities) {
    if (activities.isEmpty) return 0;
    
    int total = activities.fold(
      0, 
      (sum, activity) => sum + (activity.coinsEarned ?? 0)
    );
    
    print('Debug: Total koin: $total');
    return total;
  }
  
  // Mendapatkan data untuk chart berdasarkan aktivitas
  List<FlSpot> _getChartData(List<ActivityModel> activities) {
    if (activities.isEmpty) {
      // Data default jika tidak ada aktivitas
      return [
        const FlSpot(0, 2),
        const FlSpot(1, 5),
        const FlSpot(2, 1),
        const FlSpot(3, 3),
        const FlSpot(4, 1),
        const FlSpot(5, 4),
        const FlSpot(6, 5),
      ];
    }
    
    // Urutkan aktivitas berdasarkan ID (jika tanggal tidak tersedia)
    final sortedActivities = List<ActivityModel>.from(activities);
    sortedActivities.sort((a, b) => 
      (a.id ?? 0).compareTo(b.id ?? 0));
    
    // Buat data chart berdasarkan aktivitas yang ada (maksimal 7 titik)
    final spots = <FlSpot>[];
    final maxPoints = sortedActivities.length > 7 ? 7 : sortedActivities.length;
    
    for (int i = 0; i < maxPoints; i++) {
      final activity = sortedActivities[i];
      double value = 3.0; // Default value
      
      if (activity.distanceKm != null) {
        // Normalisasi jarak ke rentang nilai untuk chart (1-5)
        value = 1 + (activity.distanceKm! / 100).clamp(0, 4);
      }
      
      spots.add(FlSpot(i.toDouble(), value));
    }
    
    // Jika kurang dari 7 titik, tambahkan titik tambahan
    while (spots.length < 7) {
      spots.add(FlSpot(spots.length.toDouble(), 3.0));
    }
    
    return spots;
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsiveness
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    
    // Format tanggal hari ini
    final today = DateTime.now();
    final dateFormat = DateFormat('d MMM yyyy');
    final timeFormat = DateFormat('HH:mm');
    
    final formattedDate = dateFormat.format(today);
    final formattedTime = timeFormat.format(today);
    
    return Consumer<ActivityBloc>(
      builder: (context, activityBloc, child) {
        final isLoading = activityBloc.state == ActivityBlocState.loading;
        final hasError = activityBloc.state == ActivityBlocState.error;
        
        // Log status blok untuk debugging
        print('Debug: ActivityBloc state: ${activityBloc.state}');
        if (hasError) {
          print('Debug: ActivityBloc error: ${activityBloc.errorMessage}');
        }
        
        print('Debug: ActivityBloc jumlah aktivitas: ${activityBloc.activities.length}');
        
        // Dapatkan semua aktivitas (untuk debugging)
        final activities = activityBloc.activities;
        
        // Hitung statistik
        final totalDistance = _calculateTotalDistance(activities);
        final totalCalories = _calculateTotalCalories(activities);
        final totalCoins = _calculateTotalCoins(activities);
        
        // Format jarak dengan 1 desimal
        final distanceFormatted = totalDistance.toStringAsFixed(1);
        
        // Gunakan nilai default jika data kosong
        final displayDistance = totalDistance > 0 ? distanceFormatted : "0.0";
        final displayCalories = totalCalories > 0 ? totalCalories : 0;
        final displayCoins = totalCoins > 0 ? totalCoins : 0;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "TODAY'S ACTIVITY",
              style: blackTextStyle.copyWith(fontWeight: semiBold, fontSize: 14),
            ),
            const SizedBox(height: 12),
            Container(
              height: isSmallScreen ? 220 : 240,
              padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: AssetImage('assets/bg_chart.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: isLoading 
                ? Column(
                    children: [
                      // Header dengan skeleton loading
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 100,
                            height: 16,
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          Container(
                            width: 60,
                            height: 16,
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                      // Espacio para el gráfico
                      const SizedBox(height: 12),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Stack(
                            children: [
                              // Efectos de línea de puntos para simular el gráfico
                              Positioned(
                                top: 30,
                                left: 20,
                                right: 20,
                                child: CustomPaint(
                                  size: Size(double.infinity, 60),
                                  painter: DottedLinePainter(color: Colors.grey.withOpacity(0.5)),
                                ),
                              ),
                              Center(
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.8),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.hourglass_empty,
                                        color: orangeColor.withOpacity(0.7),
                                        size: 18,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Loading activity data...',
                                        style: blackTextStyle.copyWith(
                                          fontSize: 14,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Footer con skeleton loading para los datos
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 90,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                width: 60,
                                height: 14,
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                width: 70,
                                height: 14,
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                width: 80,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: orangeColor.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  )
                : hasError
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Error loading data',
                            style: blackTextStyle.copyWith(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () {
                              activityBloc.getActivities();
                            },
                            child: Text('Retry'),
                          ),
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(formattedDate, style: blackTextStyle.copyWith(fontWeight: medium)),
                            Text(formattedTime, style: blackTextStyle.copyWith(fontWeight: medium)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Expanded(
                          child: LineChart(
                            LineChartData(
                              gridData: FlGridData(show: false),
                              titlesData: FlTitlesData(show: false),
                              borderData: FlBorderData(show: false),
                              lineBarsData: [
                                LineChartBarData(
                                  spots: _getChartData(activities),
                                  isCurved: true,
                                  color: orangeColor,
                                  barWidth: 3,
                                  dotData: FlDotData(
                                    show: true,
                                    getDotPainter: (spot, percent, barData, index) {
                                      return FlDotCirclePainter(
                                        radius: 6,
                                        color: Colors.white,
                                        strokeWidth: 2,
                                        strokeColor: orangeColor,
                                      );
                                    },
                                    checkToShowDot: (spot, barData) {
                                      // Only show dot on the last point
                                      return spot.x == 6;
                                    },
                                  ),
                                  belowBarData: BarAreaData(show: true, color: Colors.transparent),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    Text(
                                      displayDistance,
                                      style: blackTextStyle.copyWith(
                                        fontSize: isSmallScreen ? 28 : 32,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'km',
                                      style: blackTextStyle.copyWith(
                                        fontSize: isSmallScreen ? 16 : 18,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '$displayCalories Kcal',
                                  style: blackTextStyle.copyWith(fontSize: 12, fontWeight: medium),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                if (activities.isNotEmpty && activities.first.avgPace != null)
                                  Text(
                                    'Pace: ${activities.first.avgPace!.toStringAsFixed(2)}',
                                    style: blackTextStyle.copyWith(fontSize: 12, fontWeight: medium),
                                  )
                                else
                                  const SizedBox(height: 16),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(Icons.monetization_on, color: Colors.amber, size: 16),
                                    const SizedBox(width: 4),
                                    Text(
                                      '+$displayCoins Coin',
                                      style: orangeTextStyle.copyWith(
                                        fontWeight: semiBold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
            ),
          ],
        );
      },
    );
  }
}

// Custom painter untuk menggambar garis putus-putus pada loading state
class DottedLinePainter extends CustomPainter {
  final Color color;
  
  DottedLinePainter({required this.color});
  
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    
    final Path path = Path();
    const double dashWidth = 5;
    const double dashSpace = 5;
    double distance = 0;
    
    // Garis bergelombang untuk menyerupai grafik
    path.moveTo(0, size.height * 0.6);
    
    double startY = size.height * 0.6;
    
    // Tiga gelombang
    for (int i = 0; i < 3; i++) {
      double peakHeight = (i == 1) ? size.height * 0.3 : size.height * 0.7;
      double segmentWidth = size.width / 3;
      
      // Menggambar gelombang naik turun
      path.quadraticBezierTo(
        segmentWidth * (i + 0.5), // kontrolpoin x
        peakHeight, // kontrolpoin y
        segmentWidth * (i + 1), // akhir x
        (i == 2) ? size.height * 0.4 : startY, // akhir y
      );
    }
    
    // Menggambar garis putus-putus
    final Path dashPath = Path();
    
    distance = 0;
    while (distance < size.width) {
      dashPath.moveTo(distance, 0);
      dashPath.lineTo(distance + dashWidth, 0);
      distance += dashWidth + dashSpace;
    }
    
    final Paint dashPaint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    
    canvas.drawPath(path, paint);
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}