import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyLineChart extends StatelessWidget {
  final List<FlSpot> spots;
  final List<Color> gradientColors = [
    const Color.fromARGB(255, 74, 3, 3),
    const Color.fromARGB(255, 174, 2, 17),
    const Color.fromARGB(255, 229, 36, 52),
    const Color.fromARGB(255, 146, 1, 13),
    const Color.fromARGB(255, 74, 3, 3)
  ];
  final bool showTitles;
  final double minX;
  final double maxXSum;
  final double maxHeight;
  final double minHeight;

  

  MyLineChart({
    super.key, 
    required this.spots, 
    this.maxHeight = 130, 
    this.showTitles = true, 
    this.minX = 1, 
    this.maxXSum = 0, 
    this.minHeight = 0});

  @override
  Widget build(BuildContext context) => LineChart(
        LineChartData(
            minX: minX,
            maxX: spots.length.toDouble() + maxXSum,
            maxY: maxHeight,
            minY: minHeight,
            borderData: FlBorderData(
                show: false,
                border:
                    Border.all(color: Theme.of(context).colorScheme.secondary)),
            titlesData:  FlTitlesData(
              show: showTitles,
              leftTitles: const AxisTitles(
                  sideTitles: SideTitles(reservedSize: 44, showTitles: true)),
              topTitles: const AxisTitles(
                  sideTitles: SideTitles(reservedSize: 30, showTitles: false)),
              rightTitles: const AxisTitles(
                  sideTitles: SideTitles(reservedSize: 44, showTitles: false)),
              bottomTitles: const AxisTitles(
                  sideTitles: SideTitles(reservedSize: 30, showTitles: true)),
            ),
            gridData: FlGridData(
              show: true,
              getDrawingVerticalLine: (value) {
                return FlLine(
                    color: Theme.of(context).colorScheme.secondary,
                    strokeWidth: 0);
              },
              getDrawingHorizontalLine: (value) {
                return FlLine(
                    color: Theme.of(context).colorScheme.secondary,
                    strokeWidth: 1);
              },
            ),
            lineBarsData: [
              LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  barWidth: 8,
                  belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                          colors: gradientColors
                              .map((color) => color.withOpacity(0.3))
                              .toList())),
                  gradient: LinearGradient(
                      colors:
                          gradientColors) //Theme.of(context).colorScheme.inversePrimary
                  )
            ]),
      );
}
