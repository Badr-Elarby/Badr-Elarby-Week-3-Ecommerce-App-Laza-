import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:laza/core/utils/app_colors.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final String location = GoRouterState.of(context).matchedLocation;
    _selectedIndex = _calculateSelectedIndex(location);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.White,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(4, (index) => _buildNavItem(index)),
      ),
    );
  }

  Widget _buildNavItem(int index) {
    final isSelected = index == _selectedIndex;
    final icon = _getIcon(index, isSelected);
    final label = _getLabel(index);

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.LightPurple.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) =>
                  ScaleTransition(scale: animation, child: child),
              child: Icon(
                icon,
                key: ValueKey(icon),
                color: isSelected
                    ? AppColors.LightPurple
                    : AppColors.AlmostBlack,
                size: 24,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? AppColors.LightPurple
                    : AppColors.AlmostBlack,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIcon(int index, bool isSelected) {
    switch (index) {
      case 0:
        return isSelected ? Icons.home : Icons.home_outlined;
      case 1:
        return isSelected ? Icons.favorite : Icons.favorite_border;
      case 2:
        return isSelected ? Icons.shopping_cart : Icons.shopping_cart_outlined;
      case 3:
        return isSelected ? Icons.shopping_bag : Icons.shopping_bag_outlined;
      default:
        return Icons.home_outlined;
    }
  }

  String _getLabel(int index) {
    switch (index) {
      case 0:
        return 'Home';
      case 1:
        return 'Favorites';
      case 2:
        return 'Cart';
      case 3:
        return 'Orders';
      default:
        return 'Home';
    }
  }

  int _calculateSelectedIndex(String location) {
    if (location == '/home') {
      return 0;
    }
    if (location == '/favorites') {
      return 1;
    }
    if (location == '/cart') {
      return 2;
    }
    if (location == '/orders') {
      return 3;
    }
    return 0;
  }

  void _onItemTapped(int index) {
    if (!mounted) return;
    setState(() {
      _selectedIndex = index;
    });
    // Use context.go for absolute navigation within shell routes
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/favorites');
        break;
      case 2:
        context.go('/cart');
        break;
      case 3:
        context.go('/orders');
        break;
    }
  }
}
