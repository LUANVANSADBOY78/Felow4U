import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../core/app_localizations.dart';
import 'explore.dart';
import 'my_trips.dart';
import 'chat.dart';
import 'profile.dart';
import 'notification.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with LanguageAware<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    ExploreScreen(),
    MyTripsScreen(),
    ChatScreen(),
    NotificationScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    // Nav labels are resolved at build time so they switch with language
    final navItems = [
      BottomNavigationBarItem(icon: const Icon(Icons.explore_outlined), activeIcon: const Icon(Icons.explore), label: languageNotifier.t('explore')),
      BottomNavigationBarItem(icon: const Icon(Icons.location_on_outlined), activeIcon: const Icon(Icons.location_on), label: languageNotifier.t('my_trips')),
      BottomNavigationBarItem(icon: const Icon(Icons.chat_bubble_outline), activeIcon: const Icon(Icons.chat_bubble), label: 'Chat'),
      BottomNavigationBarItem(icon: const Icon(Icons.notifications_none), activeIcon: const Icon(Icons.notifications), label: languageNotifier.t('notifications_title')),
      BottomNavigationBarItem(icon: const Icon(Icons.person_outline), activeIcon: const Icon(Icons.person), label: languageNotifier.t('profile')),
    ];

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedFontSize: 11,
        unselectedFontSize: 10,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: navItems,
      ),
    );
  }
}
