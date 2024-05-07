import 'package:flutter/material.dart';
import 'package:liquid_pull_refresh/liquid_pull_refresh.dart';

class AppLiquidPullRefresh extends StatelessWidget {
  final Widget child;
  final Future<void> Function() onRefresh;
  const AppLiquidPullRefresh({super.key, required this.child, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return LiquidPullRefresh(
            color: Theme.of(context).colorScheme.inversePrimary,
            backgroundColor: Theme.of(context).colorScheme.background,
            height: 300,
            animSpeedFactor: 2,
            showChildOpacityTransition: false,
            onRefresh: onRefresh,
            child: child);
  }
}