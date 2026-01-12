import 'package:flutter/material.dart';import 'package:internsharks/core/const_file/app_colors.dart';
import 'package:internsharks/core/const_file/app_text_style.dart';
import 'package:internsharks/core/routes/app_pages.dart';import '../../../controllers/login_controller.dart';
import '../../../core/const_file/app_button.dart';
import '../../../core/const_file/app_colors.dart';
import '../../../core/const_file/app_text_style.dart';
import '../../../core/routes/app_pages.dart';
import '../pages/others/117.dart';
import '../pages/others/account_settings_page.dart';
import '../pages/others/applies_page.dart';
import 'goto_intern_homepage.dart';
import 'home_Screen.dart';

class Bottom_screen extends StatefulWidget {
  const Bottom_screen({super.key});

  @override
  State<Bottom_screen> createState() => _Bottom_screenState();
}

class _Bottom_screenState extends State<Bottom_screen> {
  int _selectedIndex = 0;

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    // Add HomeScreen with callback to go to InternshipHomePage
    _pages = [
     InternshipHomePage(),

      AppliesPage(),
      AccountSettingsPage(),
      ProfilePage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool exit = await showDialog(
          context: context,
          builder: (context) => AlertDialog(backgroundColor: Colors.white,
            title: Text("Exit App?"),
            content: Text("Do you want to close the app?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text("No",style: TextStyle(color: Colors.black),),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text("Yes"),
              ),
            ],
          ),
        );

        return exit; // true = exit, false = stay
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: _pages[_selectedIndex],
        bottomNavigationBar: _buildBottomNavBar(),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border(top: BorderSide(color: Colors.grey[800]!, width: 1)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(Icons.home, "Home", 0),
              _navItem(Icons.send, "Applies", 1),
              _navItem(Icons.menu_book, "Course", 2),
              _navItem(Icons.person, "Profile", 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int index) {
    final isSelected = _selectedIndex == index;

    return InkWell(
      onTap: () {
        setState(() => _selectedIndex = index);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isSelected ? AppColors.appYellow : Colors.grey, size: 28),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? AppColors.appYellow : Colors.grey,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
