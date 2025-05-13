import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:jetbucks/providers/User.dart';

class ChartTab extends StatefulWidget {
  const ChartTab({super.key});

  @override
  State<ChartTab> createState() => _ChartTabState();
}

class _ChartTabState extends State<ChartTab> {
  String dropdownValue = 'Last 7 Days';
  late int len;

  final List<String> items = [
    'Last 7 Days',
    'Last 4 Weeks',
    'Last 6 Months',
    'Last 1 Year',
    'All Time',
  ];

  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final fullLength =
          Provider.of<UserProvider>(context).transactionsPerDay.length;
      len = fullLength < 7 ? fullLength : 7;
      _initialized = true;
    }
  }

  TextStyle get labelStyle => GoogleFonts.rubik(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: const Color.fromARGB(255, 59, 44, 90),
  );

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final hasData = userProvider.transactionsPerDay.isNotEmpty;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(Icons.show_chart, color: Colors.deepPurple, size: 32),
                const SizedBox(width: 10),
                Text(
                  'Deposit Chart',
                  style: labelStyle.copyWith(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            // Chart Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child:
                    hasData
                        ? AspectRatio(
                          aspectRatio: 1.5,
                          child: LineChart(
                            LineChartData(
                              gridData: FlGridData(
                                show: true,
                                drawVerticalLine: true,
                                getDrawingHorizontalLine:
                                    (value) => FlLine(
                                      color: Colors.grey.shade200,
                                      strokeWidth: 1,
                                    ),
                                getDrawingVerticalLine:
                                    (value) => FlLine(
                                      color: Colors.grey.shade200,
                                      strokeWidth: 1,
                                    ),
                              ),
                              titlesData: FlTitlesData(
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 40,
                                    getTitlesWidget:
                                        (value, meta) => Padding(
                                          padding: const EdgeInsets.only(
                                            right: 8.0,
                                          ),
                                          child: Text(
                                            value.toInt().toString(),
                                            style: TextStyle(
                                              color: Colors.grey.shade600,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                  ),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    interval: (len / 4).ceilToDouble(),
                                    getTitlesWidget: (value, meta) {
                                      final int idx = value.toInt();
                                      if (idx < 0 ||
                                          idx >=
                                              userProvider
                                                  .transactionsPerDay
                                                  .length) {
                                        return const SizedBox.shrink();
                                      }
                                      final date =
                                          userProvider
                                              .transactionsPerDay[idx]['date'];
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          top: 8.0,
                                        ),
                                        child: Text(
                                          date,
                                          style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontSize: 11,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                rightTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                topTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                              ),
                              borderData: FlBorderData(
                                show: true,
                                border: Border.all(
                                  color: Colors.grey.shade300,
                                  width: 1,
                                ),
                              ),
                              lineBarsData: [
                                LineChartBarData(
                                  spots: List.generate(len, (index) {
                                    final data =
                                        userProvider.transactionsPerDay[index];
                                    return FlSpot(
                                      index.toDouble(),
                                      data['amount'].toDouble(),
                                    );
                                  }),
                                  isCurved: true,
                                  color: const Color.fromARGB(255, 91, 37, 159),
                                  barWidth: 4,
                                  belowBarData: BarAreaData(
                                    show: true,
                                    color: Colors.deepPurple.withOpacity(0.08),
                                  ),
                                  dotData: FlDotData(
                                    show: true,
                                    getDotPainter:
                                        (spot, percent, barData, index) =>
                                            FlDotCirclePainter(
                                              radius: 5,
                                              color: Colors.deepPurple,
                                              strokeColor: Colors.white,
                                              strokeWidth: 2,
                                            ),
                                  ),
                                ),
                              ],
                              lineTouchData: LineTouchData(
                                enabled: true,
                                getTouchedSpotIndicator:
                                    (barData, indexes) =>
                                        indexes
                                            .map(
                                              (_) => TouchedSpotIndicatorData(
                                                FlLine(
                                                  color: Colors.transparent,
                                                  strokeWidth: 0,
                                                ),
                                                FlDotData(show: false),
                                              ),
                                            )
                                            .toList(),
                                touchTooltipData: LineTouchTooltipData(
                                  fitInsideHorizontally: true,
                                  fitInsideVertically: true,
                                  getTooltipItems: (
                                    List<LineBarSpot> touchedSpots,
                                  ) {
                                    return touchedSpots.map((spot) {
                                      final int index = spot.x.toInt();
                                      final String date =
                                          Provider.of<UserProvider>(
                                            context,
                                            listen: false,
                                          ).transactionsPerDay[index]['date'];

                                      return LineTooltipItem(
                                        '$date\nPHP${spot.y.toStringAsFixed(2)}',
                                        const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      );
                                    }).toList();
                                  },
                                ),
                              ),
                            ),
                          ),
                        )
                        : SizedBox(
                          height: 180,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: Colors.grey.shade400,
                                  size: 40,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'No transactions available',
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
              ),
            ),
            const SizedBox(height: 24),
            // Dropdown and info
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('View Chart By', style: labelStyle),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: dropdownValue,
                      icon: const Icon(Icons.arrow_drop_down),
                      items:
                          items
                              .map(
                                (item) => DropdownMenuItem(
                                  value: item,
                                  child: Text(item, style: labelStyle),
                                ),
                              )
                              .toList(),
                      onChanged: (value) {
                        setState(() {
                          dropdownValue = value!;

                          final provider = Provider.of<UserProvider>(
                            context,
                            listen: false,
                          );
                          final fullLength = provider.transactionsPerDay.length;

                          switch (value) {
                            case 'Last 7 Days':
                              len = fullLength < 7 ? fullLength : 7;
                              break;
                            case 'Last 4 Weeks':
                              len = fullLength < 28 ? fullLength : 28;
                              break;
                            case 'Last 6 Months':
                              len = fullLength < 180 ? fullLength : 180;
                              break;
                            case 'Last 1 Year':
                              len = fullLength < 365 ? fullLength : 365;
                              break;
                            case 'All Time':
                            default:
                              len = fullLength;
                              break;
                          }
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'Showing data for the last $len transactions',
              style: labelStyle.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 32),
            // Income & Expense Cards
            Row(
              children: [
                Expanded(
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 18.0,
                        horizontal: 12,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.arrow_downward,
                                color: Colors.green.shade700,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Total Income',
                                style: labelStyle.copyWith(
                                  color: Colors.green.shade700,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'PHP ${userProvider.totalIncome.toStringAsFixed(2)}',
                            style: GoogleFonts.quicksand(
                              color: Colors.green.shade800,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 18.0,
                        horizontal: 12,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.arrow_upward,
                                color: Colors.red.shade700,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Total Expense',
                                style: labelStyle.copyWith(
                                  color: Colors.red.shade700,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            // NOTE: You had totalIncome here, should be totalExpense
                            'PHP ${userProvider.totalExpense.toStringAsFixed(2)}',
                            style: GoogleFonts.quicksand(
                              color: Colors.red.shade800,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
