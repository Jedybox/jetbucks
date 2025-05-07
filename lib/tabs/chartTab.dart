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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 50.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Deposit Chart', style: labelStyle.copyWith(fontSize: 24)),
          const SizedBox(height: 10),
          if (hasData)
            AspectRatio(
              aspectRatio: 1.5,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: List.generate(len, (index) {
                        final data = userProvider.transactionsPerDay[index];
                        return FlSpot(
                          index.toDouble(),
                          data['amount'].toDouble(),
                        );
                      }),
                      isCurved: true,
                      color: const Color.fromARGB(255, 91, 37, 159),
                      belowBarData: BarAreaData(show: false),
                      dotData: FlDotData(
                        show: true,
                        getDotPainter:
                            (spot, percent, barData, index) =>
                                FlDotCirclePainter(
                                  radius: 4,
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
                      getTooltipItems: (List<LineBarSpot> touchedSpots) {
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
          else
            const Center(
              child: Padding(
                padding: EdgeInsets.only(top: 80.0),
                child: Text(
                  'No transactions available',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('View Chart By', style: labelStyle),
              DropdownButton<String>(
                value: dropdownValue,
                icon: const Icon(Icons.arrow_drop_down),
                underline: Container(height: 1, color: Colors.grey.shade300),
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
            ],
          ),
          SizedBox(height: 10),
          Text(
            'Showing data for the last $len transactions',
            style: labelStyle.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Income: ',
                style: labelStyle.copyWith(
                  color: const Color.fromARGB(255, 91, 37, 159),
                  fontFamily: GoogleFonts.quicksand().fontFamily,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'PHP ${userProvider.totalIncome.toStringAsFixed(2)}',
                style: labelStyle.copyWith(
                  color: Colors.green,
                  fontFamily: GoogleFonts.quicksand().fontFamily,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Expense: ',
                style: labelStyle.copyWith(
                  color: const Color.fromARGB(255, 91, 37, 159),
                  fontFamily: GoogleFonts.quicksand().fontFamily,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'PHP ${userProvider.totalIncome.toStringAsFixed(2)}',
                style: labelStyle.copyWith(
                  color: Colors.red,
                  fontFamily: GoogleFonts.quicksand().fontFamily,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
