import 'package:dundermifflinapp/core/configs/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:dundermifflinapp/pages/product/product.dart';
import 'package:dundermifflinapp/pages/home/Home.dart';

class BottomNavigation extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const BottomNavigation({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: _buildIcon(Icons.home, 0),
          label: 'Tela Inicial',
        ),
        BottomNavigationBarItem(
          icon: _buildIcon(Icons.menu_rounded, 1),
          label: 'Produtos',
        ),
        BottomNavigationBarItem(
          icon: _buildIcon(Icons.notifications, 2),
          label: 'Notificações',
        ),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.black,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
      onTap: (index) {
        onItemTapped(index);
        if (index == 0) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
            (route) => false,
          );
        } else if (index == 1) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const ProductPage()),
            (route) => false,
          );
        }
      },
    );
  }

  Widget _buildIcon(IconData iconData, int index) {
    bool isSelected = selectedIndex == index;
    return Container(
      decoration: isSelected
          ? BoxDecoration(
              color: AppColors.primaryBase,
              borderRadius: BorderRadius.circular(20),
            )
          : null,
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      child: Icon(
        iconData,
        color: isSelected ? Colors.white : Colors.black,
        size: isSelected ? 30 : 24,
      ),
    );
  }
}
