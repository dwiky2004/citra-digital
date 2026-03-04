import 'package:flutter/material.dart';
import 'dart:io';
import '../theme/app_theme.dart';
import 'results_screen.dart';
import '../utils/image_utils.dart';
import 'dart:typed_data';

class ConfigScreen extends StatefulWidget {
  final String imagePath;
  const ConfigScreen({super.key, required this.imagePath});

  @override
  State<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  double _quality = 75;
  String _selectedAlgorithm = 'JPEG Compression';
  bool _isProcessing = false;

  void _startCompression() async {
    setState(() {
      _isProcessing = true;
    });

    try {
      final file = File(widget.imagePath);
      final Uint8List bytes = await file.readAsBytes();

      // Ensure quality is at least 1, up to 100
      int compressionQuality = _quality.toInt();
      if (compressionQuality < 1) compressionQuality = 1;
      if (compressionQuality > 100) compressionQuality = 100;

      final result = await ImageUtils.processImage(
        originalBytes: bytes,
        quality: compressionQuality,
      );

      if (mounted) {
        setState(() {
          _isProcessing = false;
        });

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultsScreen(
              metrics: result,
              originalImagePath: widget.imagePath,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    File imageFile = File(widget.imagePath);
    int sizeBytes = 0;
    try {
      sizeBytes = imageFile.lengthSync();
    } catch (e) {
      sizeBytes = 0;
    }
    String fileSize = (sizeBytes / 1024).toStringAsFixed(2);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Konfigurasi'),
      ),
      body: _isProcessing
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 250,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          image: DecorationImage(
                            image: FileImage(imageFile),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 16,
                        left: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.raw_on, color: Colors.white, size: 16),
                              const SizedBox(width: 8),
                              Text(
                                'RAW • $fileSize KB',
                                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  
                  // Algorithm Selection
                  Text('Metode Algoritma', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: _selectedAlgorithm,
                          items: ['JPEG Compression', 'PNG Optimization', 'WebP Convert']
                              .map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            if (newValue != null) {
                              setState(() {
                                _selectedAlgorithm = newValue;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Quality Slider
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Kualitas Target', style: Theme.of(context).textTheme.titleMedium),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppTheme.primary.withOpacity(0.2)),
                        ),
                        child: Text(
                          '${_quality.toInt()}%',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Slider(
                    value: _quality,
                    min: 1,
                    max: 100,
                    divisions: 99,
                    activeColor: AppTheme.primary,
                    inactiveColor: AppTheme.surface,
                    onChanged: (value) {
                      setState(() {
                        _quality = value;
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Ukuran Kecil', style: Theme.of(context).textTheme.bodySmall),
                      Text('Kualitas Tinggi', style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                  const SizedBox(height: 48),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _startCompression,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.bolt, color: Colors.white),
                          SizedBox(width: 8),
                          Text('Mulai Kompresi', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
