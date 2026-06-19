import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocer_ph/features/profiles/screens/account_screen.dart';
import 'package:grocer_ph/features/products/screens/favorites_screen.dart';
import 'package:grocer_ph/home_screen.dart';
import 'package:grocer_ph/features/stores/screens/all_stores_screen.dart';
import 'package:grocer_ph/utils/constants/colors.dart';
import 'package:grocer_ph/utils/helpers/helper_functions.dart';
import 'package:iconsax/iconsax.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    final darkMode = HelperFunctions.isDarkMode(context);

    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 80,
          elevation: 0,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) =>
              controller.selectedIndex.value = index,
          backgroundColor: darkMode ? AppColors.black : Colors.white,
          indicatorColor: darkMode ? Colors.white.withValues(alpha: 0.1) : AppColors.black.withValues(alpha: 0.1),

          destinations: [
            const NavigationDestination(
              icon: Icon(Iconsax.home),
              label: 'Home',
            ),
            const NavigationDestination(
              icon: Icon(Iconsax.shop),
              label: 'Stores',
            ),
            const NavigationDestination(
              icon: Icon(Iconsax.heart),
              label: 'Favorites',
            ),
            const NavigationDestination(
              icon: Icon(Iconsax.user),
              label: 'Account',
            ),
          ],
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = [
    const HomeScreen(),
    const AllStoresScreen(),
    const FavoritesScreen(),
    const AccountScreen(),
  ];
}
