// lib/ui/pages/dashboard/food/scan_food_page.dart
import 'package:flutter/material.dart';
import 'package:frontend/shared/theme.dart';
import 'package:camera/camera.dart';
import 'package:frontend/ui/pages/dashboard/food/result_page.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:async';

class ScanFoodPage extends StatefulWidget {
  final int foodLogId;
  
  const ScanFoodPage({super.key, required this.foodLogId});

  @override
  State<ScanFoodPage> createState() => _ScanFoodPageState();
}

class _ScanFoodPageState extends State<ScanFoodPage> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isProcessing = false;
  
  @override
  void initState() {
    super.initState();
    print('SCAN_PAGE: initState called');
    _initializeCamera();
  }
  
  @override
  void dispose() {
    print('SCAN_PAGE: dispose called');
    _cameraController?.dispose();
    super.dispose();
  }
  
  Future<void> _initializeCamera() async {
    print('SCAN_PAGE: Initializing camera');
    try {
      _cameras = await availableCameras();
      if (_cameras != null && _cameras!.isNotEmpty) {
        _cameraController = CameraController(
          _cameras![0],
          ResolutionPreset.medium,
          enableAudio: false,
        );
        await _cameraController!.initialize();
        if (mounted) {
          setState(() {});
          print('SCAN_PAGE: Camera initialized successfully');
        }
      }
    } catch (e) {
      print('SCAN_PAGE: Error initializing camera: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Camera error: $e'))
        );
      }
    }
  }
  
  Future<void> _takePicture() async {
    if (_isProcessing) {
      print('SCAN_PAGE: Already processing, ignoring');
      return;
    }
    
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      print('SCAN_PAGE: Camera not initialized');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Camera not ready'))
      );
      return;
    }
    
    setState(() {
      _isProcessing = true;
    });
    
    try {
      print('SCAN_PAGE: Taking picture');
      final XFile image = await _cameraController!.takePicture();
      final File imageFile = File(image.path);
      
      if (!await imageFile.exists()) {
        throw Exception('Image file does not exist');
      }
      
      print('SCAN_PAGE: Processing image');
      final Uint8List imageBytes = await imageFile.readAsBytes();
      final String base64Image = base64Encode(imageBytes);
      final String imageData = 'data:image/jpeg;base64,$base64Image';
      
      print('SCAN_PAGE: Navigating to processing page');
      
      // Navigate to processing page and pass raw data
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FoodResultPage(
              foodLogId: widget.foodLogId,
              imageData: imageData,
            ),
          ),
        ).then((_) {
          // Reset processing flag when returning
          setState(() {
            _isProcessing = false;
          });
        });
      }
    } catch (e) {
      print('SCAN_PAGE: Error processing image: $e');
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'))
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print('SCAN_PAGE: build called');
    
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(
          'Scan Food',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: _buildBody(),
    );
  }
  
  Widget _buildBody() {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }
    
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              // Camera preview
              SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: CameraPreview(_cameraController!),
              ),
              
              // Target overlay
              Center(
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.restaurant,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
              ),
              
              // Processing indicator
              if (_isProcessing)
                Container(
                  color: Colors.black.withOpacity(0.7),
                  child: const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                ),
            ],
          ),
        ),
        
        // Scan button
        if (!_isProcessing)
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: orangeColor,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: _takePicture,
              child: Text(
                'SCAN FOOD',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
      ],
    );
  }
}