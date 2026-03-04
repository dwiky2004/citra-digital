import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../theme/app_theme.dart';
import '../utils/image_utils.dart';

class ResultsScreen extends StatelessWidget {
  final ImageMetricsResult metrics;
  final String originalImagePath;

  const ResultsScreen({super.key, required this.metrics, required this.originalImagePath});

  @override
  Widget build(BuildContext context) {
    double oriKB = metrics.originalSize / 1024;
    double compKB = metrics.compressedSize / 1024;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasil Analisis', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.analytics_outlined, color: AppTheme.primary),
                const SizedBox(width: 8),
                Text('Metrik Kualitas Citra', style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    context,
                    'PSNR',
                    '${metrics.psnr.toStringAsFixed(2)} dB',
                    metrics.psnr > 30 ? Icons.check_circle_outline : Icons.warning_amber_rounded,
                    metrics.psnr > 30 ? AppTheme.success : AppTheme.destructive,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildMetricCard(
                    context,
                    'MSE',
                    metrics.mse.toStringAsFixed(2),
                    Icons.show_chart,
                    AppTheme.primary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildMetricCard(
                    context,
                    'Efisiensi',
                    '${metrics.compressionRatio.toStringAsFixed(1)}%',
                    Icons.compress,
                    AppTheme.brandSecond,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Bar Chart
            Row(
              children: [
                const Icon(Icons.bar_chart_outlined, color: AppTheme.primary),
                const SizedBox(width: 8),
                Text('Perbandingan Ukuran File', style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 200,
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: oriKB * 1.2,
                          barTouchData: BarTouchData(enabled: false),
                          titlesData: FlTitlesData(
                            show: true,
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (double value, TitleMeta meta) {
                                  final text = value == 0 ? 'Sebelum' : 'Sesudah';
                                  return SideTitleWidget(
                                    axisSide: meta.axisSide,
                                    child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                  );
                                },
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                                getTitlesWidget: (value, meta) {
                                  if (value == 0) return const SizedBox.shrink();
                                  return Text('${value.toInt()} KB', style: const TextStyle(fontSize: 10));
                                },
                              ),
                            ),
                            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          ),
                          gridData: const FlGridData(show: true, drawVerticalLine: false),
                          borderData: FlBorderData(show: false),
                          barGroups: [
                            BarChartGroupData(
                              x: 0,
                              barRods: [
                                BarChartRodData(
                                  toY: oriKB,
                                  color: AppTheme.textSecondary.withOpacity(0.5),
                                  width: 40,
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                                )
                              ],
                            ),
                            BarChartGroupData(
                              x: 1,
                              barRods: [
                                BarChartRodData(
                                  toY: compKB,
                                  color: AppTheme.primary,
                                  width: 40,
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildLegend(AppTheme.textSecondary.withOpacity(0.5), 'Original: ${oriKB.toStringAsFixed(1)} KB'),
                        const SizedBox(width: 24),
                        _buildLegend(AppTheme.primary, 'Compressed: ${compKB.toStringAsFixed(1)} KB'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Line Chart
            Row(
              children: [
                const Icon(Icons.ssid_chart, color: AppTheme.primary),
                const SizedBox(width: 8),
                Text('Analisis Tren Kualitas', style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  height: 200,
                  child: LineChart(
                    LineChartData(
                      gridData: const FlGridData(show: true, drawVerticalLine: false),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              return Text('${value.toInt()}%', style: const TextStyle(fontSize: 10));
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 30,
                            getTitlesWidget: (value, meta) {
                              return Text('${value.toInt()}', style: const TextStyle(fontSize: 10));
                            },
                          ),
                        ),
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                      borderData: FlBorderData(show: false),
                      minX: 10,
                      maxX: 100,
                      minY: 10,
                      maxY: 50,
                      lineBarsData: [
                        LineChartBarData(
                          spots: const [
                            FlSpot(10, 15),
                            FlSpot(25, 22),
                            FlSpot(50, 31),
                            FlSpot(75, 42),
                            FlSpot(100, 48),
                          ],
                          isCurved: true,
                          color: AppTheme.primary,
                          barWidth: 3,
                          isStrokeCapRound: true,
                          dotData: FlDotData(show: true),
                          belowBarData: BarAreaData(
                            show: true,
                            color: AppTheme.primary.withOpacity(0.1),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batalkan'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // Save logic would go here
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: const Text('Simpan Hasil'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(BuildContext context, String title, String value, IconData icon, Color color) {
    return Card(
      color: AppTheme.contentCard,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.textMain)),
      ],
    );
  }
}
