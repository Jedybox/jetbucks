import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jetbucks/tabs/walletTab.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';

import 'package:jetbucks/providers/User.dart';

class ChartGraph extends StatefulWidget {
  final List<FlSpot> flSpots;
  final List<Map<String, dynamic>> spots;

  const ChartGraph({super.key, required this.flSpots, required this.spots});

  @override
  State<ChartGraph> createState() =>
      _ChartGraphState(flSpots: flSpots, spots: spots);
}

class _ChartGraphState extends State<ChartGraph> {
  final List<FlSpot> flSpots;
  final List<Map<String, dynamic>> spots;

  _ChartGraphState({required this.flSpots, required this.spots});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: flSpots.isNotEmpty ? flSpots : [FlSpot(0, 0)],
            isCurved: true,
            color: const Color.fromARGB(255, 132, 56, 255),
            barWidth: 2,
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 132, 56, 255), // near line
                  Colors.transparent, // far from line
                ],
                stops: [0.0, 1.0], // fade out distance
              ),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          enabled: true,
          handleBuiltInTouches: true,
          getTouchedSpotIndicator: (
            LineChartBarData barData,
            List<int> spotIndexes,
          ) {
            // Return an empty list = no indicator lines
            return spotIndexes.map((index) => null).toList();
          },
          touchTooltipData: LineTouchTooltipData(
            fitInsideHorizontally: true,
            fitInsideVertically: true,
            tooltipRoundedRadius: 8,
            getTooltipItems: (List<LineBarSpot> touchedSpots) {
              return touchedSpots.map((spot) {
                final date =
                    DateTime.parse(
                      spots[spot.x.toInt()]['date'].toString(),
                    ).toLocal();

                return LineTooltipItem(
                  '${spot.y} : ${date.month}/${date.day}/${date.year}',
                  const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }
}
