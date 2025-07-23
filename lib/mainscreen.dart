import 'package:flutter/material.dart';
import 'package:service_p/pages/home_page.dart';
import 'package:service_p/pages/profile_page.dart';


class Mainscreen extends StatefulWidget {
  const Mainscreen({super.key});

  @override
  State<Mainscreen> createState() => _MainscreenState();
}

class _MainscreenState extends State<Mainscreen> {
  int _selectedIndex = 0; // Tracks the currently selected tab index

  // List of widgets to display in the IndexedStack
  // These are the pages that will be shown when a tab is selected
  static const List<Widget> _pages = <Widget>[
    HomePage(), // Your existing Home Page
    ProfilePage(), // Your existing Profile Page
  ];

  // Function to handle tab selection
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The body uses IndexedStack to show only the selected page
      // IndexedStack keeps the state of inactive widgets, which is good for navigation.
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home), // Filled icon for active state
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person), // Filled icon for active state
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex, // The currently selected item
        selectedItemColor: Theme.of(context).colorScheme.primary, // Color for selected icon/label
        unselectedItemColor: Theme.of(context).colorScheme.onSurfaceVariant, // Color for unselected icon/label
        onTap: _onItemTapped, // Callback when an item is tapped
        type: BottomNavigationBarType.fixed, // Ensures all items are visible and have labels
        backgroundColor: Theme.of(context).colorScheme.surface, // Background color of the bar
        elevation: 8, // Adds a subtle shadow to the bar
      ),
    );
  }
}