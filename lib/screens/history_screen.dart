import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  
  final List<Map<String, dynamic>> _mockHistory = [
    {
      'name': 'citra_medis_paru_01.jpg',
      'date': '12 Okt 2023, 14:20',
      'status': 'Excellent',
      'ratio': '75.4%',
      'psnr': '42.15 dB',
      'image': 'assets/mock1.png', // Placeholder
    },
    {
      'name': 'arsitektur_minimalis.png',
      'date': '11 Okt 2023, 09:45',
      'status': 'Good',
      'ratio': '62.1%',
      'psnr': '38.80 dB',
      'image': 'assets/mock2.png',
    },
    {
      'name': 'dataset_satelit_aceh.jpg',
      'date': '10 Okt 2023, 18:30',
      'status': 'Fair',
      'ratio': '88.9%',
      'psnr': '31.45 dB',
      'image': 'assets/mock3.png',
    },
    {
      'name': 'dokumen_pribadi_scan.jpg',
      'date': '09 Okt 2023, 11:12',
      'status': 'Excellent',
      'ratio': '45.0%',
      'psnr': '45.22 dB',
      'image': 'assets/mock4.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Kompresi', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari nama file...',
                prefixIcon: const Icon(Icons.search, color: AppTheme.textSecondary),
                filled: true,
                fillColor: AppTheme.contentCard,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppTheme.surface, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppTheme.surface, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppTheme.primary, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                _buildFilterChip('Semua', true),
                const SizedBox(width: 8),
                _buildFilterChip('Terbaru', false),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: AppTheme.textMain),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.primary.withOpacity(0.1)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatColumn('TOTAL TUGAS', '24'),
                  _buildDivider(),
                  _buildStatColumn('RATA PSNR', '39.4 dB', isPrimary: true),
                  _buildDivider(),
                  _buildStatColumn('EFISIENSI', '68%'),
                ],
              ),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Daftar Aktivitas', style: Theme.of(context).textTheme.titleMedium),
                Text('URUT: TERBARU', style: Theme.of(context).textTheme.labelSmall),
              ],
            ),
          ),
          
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: _mockHistory.length,
              itemBuilder: (context, index) {
                final item = _mockHistory[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: AppTheme.surface, width: 1.5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: AppTheme.surface,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.image, color: AppTheme.textSecondary),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        item['name'],
                                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    _buildStatusBadge(item['status']),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.calendar_today, size: 12, color: AppTheme.textSecondary),
                                    const SizedBox(width: 4),
                                    Text(
                                      item['date'],
                                      style: Theme.of(context).textTheme.labelSmall,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(Icons.bar_chart, size: 14, color: AppTheme.textMain),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Ratio: ${item['ratio']}',
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.textMain),
                                    ),
                                    const SizedBox(width: 16),
                                    Icon(Icons.show_chart, size: 14, color: AppTheme.brandSecond),
                                    const SizedBox(width: 4),
                                    Text(
                                      'PSNR: ${item['psnr']}',
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: AppTheme.brandSecond,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right, color: AppTheme.textSecondary),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Tips Card
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFE0F7FA), // Light cyan surface
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline, color: Color(0xFF00BCD4)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tips Analisis',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'PSNR di atas 30 dB umumnya dianggap memiliki kualitas yang baik dan tidak terlihat perbedaannya oleh mata manusia.',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppTheme.primary.withOpacity(0.2) : AppTheme.contentCard,
        border: Border.all(
          color: isSelected ? AppTheme.primary.withOpacity(0.5) : AppTheme.surface,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, String value, {bool isPrimary = false}) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: AppTheme.textSecondary,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isPrimary ? const Color(0xFF00BCD4) : AppTheme.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 30,
      width: 1,
      color: AppTheme.textSecondary.withOpacity(0.2),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bgColor;
    Color textColor;
    
    switch (status.toLowerCase()) {
      case 'excellent':
        bgColor = AppTheme.success.withOpacity(0.1);
        textColor = AppTheme.success;
        break;
      case 'good':
        bgColor = AppTheme.primary.withOpacity(0.1);
        textColor = AppTheme.primary;
        break;
      case 'fair':
      default:
        bgColor = AppTheme.destructive.withOpacity(0.1);
        textColor = AppTheme.destructive;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: textColor.withOpacity(0.3)),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
