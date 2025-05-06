import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:jetbucks/providers/User.dart';
import 'package:provider/provider.dart';
import 'package:jetbucks/charter/chart.dart';
import 'package:jetbucks/tabs/walletTab.dart';

class ChartTab extends StatefulWidget {
  const ChartTab({super.key});

  @override
  State<ChartTab> createState() => _ChartTabState();
}

class _ChartTabState extends State<ChartTab> {
  String dropdownValue = 'Last 7 Days';
  late List<Map<String, dynamic>> spots = [];
  late List<FlSpot> flSpots = [];

  final List<String> items = [
    'Last 7 Days',
    'Last 4 Weeks',
    'Last 6 Months',
    'Last 1 Year',
    'All Time',
  ];

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final transactions = userProvider.recent7daysTransactions;
    _changeSpots(transactions);
  }

  void _changeSpots(List<Map<String, dynamic>> tr) {
    setState(() {
      var lastDate;

      for (var i = 0; i < tr.length; i++) {
        var date = DateTime.parse(
          tr[i]['transaction_date'],
        ).toLocal().toString().substring(0, 10);
        var amount = tr[i]['amount'];
        bool income = isIncome(
          formatTitle(
            tr[i]['transaction_type'],
            tr[i],
            int.parse(
              localStorage.getItem('id') != null
                  ? '0'
                  : localStorage.getItem('id')!,
            ),
          ),
        );

        if (lastDate == null || lastDate != date) {
          spots.add({'date': date, 'amount': income ? amount : -amount});
          lastDate = date;
        } else {
          if (income) {
            spots[spots.length - 1]['amount'] += amount;
          } else {
            spots[spots.length - 1]['amount'] -= amount;
          }
        }
      }

      for (var i = 0; i < spots.length; i++) {
        var amount = spots[i]['amount'];
        flSpots.add(FlSpot(i.toDouble(), amount));
      }
    }); // Update the state to reflect the new spots
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Deposit Chart',
            style: GoogleFonts.rubik(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: const Color.fromARGB(255, 59, 44, 90),
            ),
          ),
          const SizedBox(height: 10),
          AspectRatio(
            aspectRatio: 1.5,
            child: ChartGraph(flSpots: flSpots, spots: spots),
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'View Chart By',
                style: GoogleFonts.rubik(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: const Color.fromARGB(255, 59, 44, 90),
                ),
              ),
              DropdownButton(
                value: dropdownValue,
                items:
                    items.map((String item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item,
                          style: GoogleFonts.rubik(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: const Color.fromARGB(255, 59, 44, 90),
                          ),
                        ),
                      );
                    }).toList(),
                onChanged: (value) {
                  setState(() {
                    dropdownValue = value!;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
