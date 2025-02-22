import 'dart:math';

import 'package:cryptoinsight/service.dart/json_and_others.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../service.dart/api.dart';


class CryptocurrencyChartTab extends StatefulWidget {
  final Cryptocurrency cryptocurrency;

  const CryptocurrencyChartTab({Key? key, required this.cryptocurrency}) : super(key: key);

  @override
  _CryptocurrencyChartTabState createState() => _CryptocurrencyChartTabState();
}

class _CryptocurrencyChartTabState extends State<CryptocurrencyChartTab> {
  bool isChartLoading = true;
  List<FlSpot> priceData = [];
  int selectedChartDays = 7;

  @override
  void initState() {
    super.initState();
    fetchMarketChart();
  }

  Future<void> fetchMarketChart() async {
    setState(() => isChartLoading = true);
    try {
      final chartData = await ApiService.getMarketChart(widget.cryptocurrency.id, selectedChartDays);
      setState(() {
        priceData = chartData.map((point) => FlSpot(point[0].toDouble(), point[1].toDouble())).toList();
        isChartLoading = false;
      });
    } catch (e) {
      setState(() => isChartLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch market chart data')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildChartButton('7D', 7),
              _buildChartButton('30D', 30),
              _buildChartButton('90D', 90),
              _buildChartButton('1Y', 365),
            ],
          ),
        ),
        Expanded(
          child: isChartLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(show: false),
                      titlesData: FlTitlesData(show: false),
                      borderData: FlBorderData(show: false),
                      minX: priceData.isNotEmpty ? priceData.first.x : 0,
                      maxX: priceData.isNotEmpty ? priceData.last.x : 0,
                      minY: priceData.isNotEmpty ? priceData.map((spot) => spot.y).reduce(min) : 0,
                      maxY: priceData.isNotEmpty ? priceData.map((spot) => spot.y).reduce(max) : 0,
                      lineBarsData: [
                        LineChartBarData(
                          spots: priceData,
                          isCurved: true,
                          color: Theme.of(context).primaryColor,
                          barWidth: 3,
                          isStrokeCapRound: true,
                          dotData: FlDotData(show: false),
                          belowBarData: BarAreaData(
                            show: true,
                            color: Theme.of(context).primaryColor.withOpacity(0.1),
                          ),
                        ),
                      ],
                      lineTouchData: LineTouchData(
                        touchTooltipData: LineTouchTooltipData(
                          tooltipRoundedRadius: 8,
                          getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                            return touchedBarSpots.map((barSpot) {
                              final flSpot = barSpot;
                              if (flSpot.x == 0 || flSpot.x.isNaN || flSpot.y == 0 || flSpot.y.isNaN) {
                                return null;
                              }
                              final DateTime date = DateTime.fromMillisecondsSinceEpoch(flSpot.x.toInt());
                              return LineTooltipItem(
                                '${DateFormat('MMM d, yyyy').format(date)}\n\$${flSpot.y.toStringAsFixed(2)}',
                                const TextStyle(color: Colors.white),
                              );
                            }).toList();
                          },
                        ),
                        handleBuiltInTouches: true,
                        getTouchedSpotIndicator: (LineChartBarData barData, List<int> spotIndexes) {
                          return spotIndexes.map((spotIndex) {
                            return TouchedSpotIndicatorData(
                              FlLine(color: Colors.blue, strokeWidth: 2),
                              FlDotData(
                                getDotPainter: (spot, percent, barData, index) {
                                  return FlDotCirclePainter(
                                    radius: 6,
                                    color: Colors.white,
                                    strokeWidth: 3,
                                    strokeColor: Colors.blue,
                                  );
                                },
                              ),
                            );
                          }).toList();
                        },
                      ),
                    ),
                  ),
                ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Price: \$${NumberFormat("#,##0.00").format(widget.cryptocurrency.price)}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildChartButton(String label, int days) {
    return ElevatedButton(
      onPressed: () {
        setState(() => selectedChartDays = days);
        fetchMarketChart();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: selectedChartDays == days ? Theme.of(context).primaryColor : Colors.grey.shade200,
        foregroundColor: selectedChartDays == days ? Colors.white : Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Text(label),
    );
  }
}
extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
