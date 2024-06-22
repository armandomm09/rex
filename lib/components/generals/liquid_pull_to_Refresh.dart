import 'package:flutter/material.dart';
import 'package:liquid_pull_refresh/liquid_pull_refresh.dart';

class AppLiquidPullRefresh extends StatelessWidget {
  final Widget child;
  final Color? color;
  final Color? backgroundColor;
  final Future<void> Function() onRefresh;
  const AppLiquidPullRefresh({
    super.key,
    required this.child,
    required this.onRefresh,
    this.color = const Color.fromARGB(255, 238, 39, 55),
    this.backgroundColor = const Color.fromARGB(255, 17, 17, 17),
  });

  @override
  Widget build(BuildContext context) {
    return LiquidPullRefresh(
        color: color,
        backgroundColor: backgroundColor,
        height: 300,
        animSpeedFactor: 2,
        showChildOpacityTransition: false,
        onRefresh: onRefresh,
        child: child);
  }
}
