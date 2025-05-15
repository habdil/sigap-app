import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/blocs/food_bloc.dart';
import 'package:frontend/shared/theme.dart';
import 'package:frontend/shared/loading.dart';
import 'package:frontend/ui/widgets/food/food_history_item.dart';
import 'package:frontend/ui/pages/dashboard/food/all_history_page.dart';

class FoodHistorySection extends StatelessWidget {
  const FoodHistorySection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Mendapatkan ukuran layar device
    final screenSize = MediaQuery.of(context).size;
    final isPad = screenSize.width > 600;
    
    // Trigger loading food logs when this widget is first built
    context.read<FoodBloc>().add(LoadFoodLogs());
    
    return Padding(
      // Gunakan padding horizontal yang responsif berdasarkan ukuran layar
      padding: EdgeInsets.symmetric(horizontal: isPad ? 24 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Food History',
                style: blackTextStyle.copyWith(
                  fontWeight: semiBold,
                  // Ukuran font responsif berdasarkan layar
                  fontSize: isPad ? 18 : 14,
                ),
              ),
              GestureDetector(
                onTap: () {
                  _showAddFoodDialog(context);
                },
                child: Container(
                  // Padding responsif untuk tombol add
                  padding: EdgeInsets.symmetric(
                    horizontal: isPad ? 16 : 12, 
                    vertical: isPad ? 8 : 6
                  ),
                  decoration: BoxDecoration(
                    color: orangeColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.add,
                        color: Colors.white,
                        // Ukuran icon responsif
                        size: isPad ? 20 : 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Add Food',
                        style: whiteTextStyle.copyWith(
                          // Font size responsif
                          fontSize: isPad ? 14 : 12,
                          fontWeight: medium,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: isPad ? 24 : 16),
          
          // Food history items from bloc
          BlocBuilder<FoodBloc, FoodState>(
            builder: (context, state) {
              if (state is FoodLoading) {
                return const Center(
                  child: ElegantLoading(message: 'Loading food history...'),
                );
              } else if (state is FoodLoaded) {
                final foodLogs = state.foodLogs;
                
                if (foodLogs.isEmpty) {
                  return _buildEmptyState(context, isPad);
                }
                
                // Gunakan layout grid untuk device yang lebih besar
                if (isPad) {
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: screenSize.width > 900 ? 3 : 2, // 3 kolom untuk layar sangat lebar
                      childAspectRatio: 2.5,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16
                    ),
                    itemCount: foodLogs.length > 6 ? 6 : foodLogs.length, // Limit untuk grid
                    itemBuilder: (context, index) {
                      return FoodHistoryItem(foodLog: foodLogs[index]);
                    },
                  );
                } else {
                  // Tampilan list untuk mobile
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: foodLogs.length > 3 ? 3 : foodLogs.length, // Limit to 3 items
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: FoodHistoryItem(foodLog: foodLogs[index]),
                      );
                    },
                  );
                }
              } else if (state is FoodError) {
                // Check for the specific error type
                if (state.message.contains("type 'Null' is not a subtype of type 'List<dynamic>'")) {
                  return _buildWelcomeMessage(context, isPad);
                }
                return _buildErrorState(context, state.message, isPad);
              }
              
              // Initial or any other state
              return const SizedBox.shrink();
            },
          ),
          
          // Tambahkan tombol "See All" jika ada data
          BlocBuilder<FoodBloc, FoodState>(
            builder: (context, state) {
              if (state is FoodLoaded && state.foodLogs.isNotEmpty) {
                return Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 8),
                  child: Center(
                    child: TextButton(
                      onPressed: () {
                        // Navigasi ke halaman food history lengkap
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AllFoodHistoryPage(),
                          ),
                        );
                      },
                      child: Text(
                        'See All Food History',
                        style: orangeTextStyle.copyWith(
                          fontSize: isPad ? 16 : 14,
                          fontWeight: medium,
                        ),
                      ),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
  
  // New method for the specific error case
  Widget _buildWelcomeMessage(BuildContext context, bool isPad) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: isPad ? 48 : 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Friendly icon
          Icon(
            Icons.restaurant_menu,
            size: isPad ? 80 : 64,
            color: orangeColor.withOpacity(0.7),
          ),
          SizedBox(height: isPad ? 24 : 16),
          Text(
            'Welcome!',
            style: blackTextStyle.copyWith(
              fontSize: isPad ? 20 : 18,
              fontWeight: semiBold,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isPad ? 40 : 24),
            child: Text(
              'Sorry, your food history is not available yet. Please scan your food to start tracking your nutrition. Stay healthy!',
              style: greyTextStyle.copyWith(
                fontSize: isPad ? 14 : 13,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: isPad ? 28 : 24),
          // Button to add first food
          ElevatedButton.icon(
            onPressed: () {
              _showAddFoodDialog(context);
            },
            icon: Icon(
              Icons.add_circle_outline,
              color: whiteColor,
              size: isPad ? 22 : 18,
            ),
            label: Text(
              'Scan Your First Food',
              style: whiteTextStyle.copyWith(
                fontSize: isPad ? 16 : 14,
                fontWeight: medium,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: orangeColor,
              foregroundColor: whiteColor,
              padding: EdgeInsets.symmetric(
                horizontal: isPad ? 24 : 20,
                vertical: isPad ? 12 : 10,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
            ),
          ),
        ],
      ),
    );
  }
  
  // Widget untuk menampilkan state kosong yang lebih user friendly
  Widget _buildEmptyState(BuildContext context, bool isPad) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: isPad ? 48 : 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Gambar yang lebih menarik
          Image.asset(
            'assets/img_empty_food.png', // Gunakan gambar makanan kosong jika ada
            width: isPad ? 150 : 120,
            height: isPad ? 150 : 120,
            // Fallback jika gambar tidak tersedia
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                Icons.restaurant,
                size: isPad ? 80 : 64,
                color: orangeColor.withOpacity(0.7),
              );
            },
          ),
          SizedBox(height: isPad ? 24 : 16),
          Text(
            'Belum ada catatan makanan',
            style: blackTextStyle.copyWith(
              fontSize: isPad ? 18 : 16,
              fontWeight: semiBold,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isPad ? 40 : 24),
            child: Text(
              'Yuk, mulai catat makanan kamu untuk mendapatkan analisis nutrisi dan pantau pola makan sehari-hari.',
              style: greyTextStyle.copyWith(
                fontSize: isPad ? 14 : 13,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: isPad ? 28 : 24),
          // Tombol untuk menambah makanan langsung
          ElevatedButton.icon(
            onPressed: () {
              _showAddFoodDialog(context);
            },
            icon: Icon(
              Icons.add_circle_outline,
              color: whiteColor,
              size: isPad ? 22 : 18,
            ),
            label: Text(
              'Tambah Makanan Pertama',
              style: whiteTextStyle.copyWith(
                fontSize: isPad ? 16 : 14,
                fontWeight: medium,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: orangeColor,
              foregroundColor: whiteColor,
              padding: EdgeInsets.symmetric(
                horizontal: isPad ? 24 : 20,
                vertical: isPad ? 12 : 10,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
            ),
          ),
        ],
      ),
    );
  }
  
  // Widget untuk menampilkan state error yang lebih user friendly
  Widget _buildErrorState(BuildContext context, String message, bool isPad) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: isPad ? 48 : 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon yang lebih informatif dan menarik
          Container(
            padding: EdgeInsets.all(isPad ? 20 : 16),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.sentiment_dissatisfied,
              size: isPad ? 64 : 48,
              color: Colors.red.shade400,
            ),
          ),
          SizedBox(height: isPad ? 24 : 16),
          Text(
            'Oops, Ada Kendala',
            style: blackTextStyle.copyWith(
              fontWeight: semiBold,
              fontSize: isPad ? 18 : 16,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isPad ? 40 : 24),
            child: Text(
              'Maaf, kami tidak dapat memuat riwayat makanan kamu. Coba beberapa saat lagi ya.',
              style: greyTextStyle.copyWith(
                fontSize: isPad ? 14 : 13,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // Detail error tersembunyi yang bisa dilihat jika diklik
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              tilePadding: EdgeInsets.symmetric(horizontal: isPad ? 16 : 12),
              title: Text(
                'Detail Masalah',
                style: greyTextStyle.copyWith(
                  fontSize: isPad ? 14 : 12,
                  fontWeight: medium,
                ),
                textAlign: TextAlign.center,
              ),
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isPad ? 24 : 16,
                    vertical: 8,
                  ),
                  child: Text(
                    message,
                    style: greyTextStyle.copyWith(
                      fontSize: isPad ? 12 : 11,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: isPad ? 20 : 16),
          // Tombol untuk mencoba lagi
          ElevatedButton.icon(
            onPressed: () {
              // Reload food logs
              context.read<FoodBloc>().add(LoadFoodLogs());
            },
            icon: Icon(
              Icons.refresh,
              color: whiteColor,
              size: isPad ? 22 : 18,
            ),
            label: Text(
              'Coba Lagi',
              style: whiteTextStyle.copyWith(
                fontSize: isPad ? 16 : 14,
                fontWeight: medium,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: blueColor,
              foregroundColor: whiteColor,
              padding: EdgeInsets.symmetric(
                horizontal: isPad ? 24 : 20,
                vertical: isPad ? 12 : 10,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
            ),
          ),
        ],
      ),
    );
  }
  
  void _showAddFoodDialog(BuildContext context) {
    final foodNameController = TextEditingController();
    final notesController = TextEditingController();
    
    // Detect screen size for responsive dialog
    final screenSize = MediaQuery.of(context).size;
    final isPad = screenSize.width > 600;
    final dialogWidth = isPad ? screenSize.width * 0.7 : screenSize.width * 0.9;

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          // Set maksimum width dialog
          insetPadding: EdgeInsets.symmetric(
            horizontal: (screenSize.width - dialogWidth) / 2
          ),
          child: Container(
            width: dialogWidth,
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add Food Log',
                  style: blackTextStyle.copyWith(
                    fontSize: isPad ? 22 : 18,
                    fontWeight: semiBold,
                  ),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: foodNameController,
                  decoration: InputDecoration(
                    labelText: 'Food Name',
                    labelStyle: greyTextStyle,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: notesController,
                  decoration: InputDecoration(
                    labelText: 'Notes (optional)',
                    labelStyle: greyTextStyle,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Cancel',
                        style: greyTextStyle.copyWith(
                          fontWeight: medium,
                          fontSize: isPad ? 16 : 14,
                        ),
                      ),
                    ),
                    SizedBox(width: isPad ? 16 : 8),
                    ElevatedButton(
                      onPressed: () {
                        if (foodNameController.text.isNotEmpty) {
                          context.read<FoodBloc>().add(
                            AddFoodLog(
                              foodName: foodNameController.text,
                              notes: notesController.text.isNotEmpty 
                                ? notesController.text 
                                : null,
                            ),
                          );
                          Navigator.of(context).pop();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: orangeColor,
                        foregroundColor: whiteColor,
                        padding: EdgeInsets.symmetric(
                          horizontal: isPad ? 24 : 16, 
                          vertical: isPad ? 12 : 8
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Add',
                        style: TextStyle(fontSize: isPad ? 16 : 14),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}