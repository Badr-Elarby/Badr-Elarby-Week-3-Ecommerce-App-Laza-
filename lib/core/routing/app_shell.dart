import 'package:flutter/material.dart';
import 'package:laza/core/widgets/bottom_nav_bar.dart';

class AppShell extends StatelessWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // Wrap bottom nav bar in SafeArea to prevent overlap with system navigation buttons
    return Scaffold(
      body: child,
      bottomNavigationBar: const SafeArea(
        top: false,
        bottom: true, // Ensure bottom nav respects system gesture bars
        child: BottomNavBar(),
      ),
    );
  }
}
