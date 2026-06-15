import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';

typedef TappedCallback = dynamic Function(int value);

class CustomNavBar extends StatefulWidget {
  final bool isStudentFlow;
  final List<Widget>? screens;
  final GlobalKey<ScaffoldState>? scaffoldKey;

  const CustomNavBar({
    super.key,
    this.screens,
    this.scaffoldKey,
    this.isStudentFlow = true,
  });

  @override
  State<CustomNavBar> createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar> {
  ValueNotifier<int> currentIndex = ValueNotifier(0);

  Widget getTabWidget(int index) {
    return widget.screens![index];
  }

  @override
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: currentIndex,
      builder: (context, int value, child) {
        return Stack(
          children: [
            // Screen content fills full height
            Positioned.fill(child: getTabWidget(value)),
            // Nav bar floats at the bottom, fully transparent background
            Positioned(
              right: 20,
              left: 20,
              bottom: 20,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                height: 75,
                decoration: BoxDecoration(
                  color: AppColors.fieldBgColor,
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: widget.isStudentFlow
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _navItem(
                            index: 0,
                            icon: Icons.home_rounded,
                            label: "Home",
                            selectedIndex: value,
                          ),
                          _navItem(
                            index: 1,
                            icon: CupertinoIcons.location_fill,
                            label: "Applied",
                            selectedIndex: value,
                          ),
                          _navItem(
                            index: 2,
                            icon: Icons.work,
                            label: "Internships",
                            selectedIndex: value,
                          ),
                          _navItem(
                            index: 3,
                            icon: Icons.person,
                            label: "Profile",
                            selectedIndex: value,
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _navItem(
                            index: 0,
                            icon: Icons.home_rounded,
                            label: "Home",
                            selectedIndex: value,
                          ),
                          _navItem(
                            index: 1,
                            icon: CupertinoIcons.location_fill,
                            label: "My Post",
                            selectedIndex: value,
                          ),
                          _navItem(
                            index: 3,
                            icon: Icons.person,
                            label: "Profile",
                            selectedIndex: value,
                          ),
                        ],
                      ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _navItem({
    required int index,
    required IconData icon,
    required String label,
    required int selectedIndex,
  }) {
    bool isSelected = index == selectedIndex;

    return GestureDetector(
      onTap: () {
        currentIndex.value = index;
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: isSelected ? 140 : 55,
        height: 55,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.contColor2 : AppColors.fieldBgColor,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 45,
              height: 45,
              margin: const EdgeInsets.only(left: 5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? AppColors.primaryColor
                    : AppColors.contColor2,
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primaryColor.withValues(alpha: .45),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ]
                    : [],
              ),
              child: Icon(
                icon,
                color: isSelected ? AppColors.blackColor : AppColors.whiteColor,
                size: 24,
              ),
            ),

            if (isSelected)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    label,
                    overflow: TextOverflow.ellipsis,
                    style: AppStyles.customTextStyle(
                      size: 14,
                      weight: FontWeight.w500,
                      color: AppColors.whiteColor,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // List<BottomNavigationBarItem> _appNavBarsItems() {
  //   return [
  //     const BottomNavigationBarItem(
  //       icon: Icon(Icons.home_outlined, color: AppColors.whiteColor),
  //       label: "Home",
  //       activeIcon: Icon(Icons.home, color: AppColors.secondaryColor),
  //       tooltip: "Home"
  //     ),
  //     const BottomNavigationBarItem(
  //       icon: Icon(CupertinoIcons.location, color: AppColors.whiteColor),
  //       activeIcon: Icon(
  //         CupertinoIcons.location_fill,
  //         color: AppColors.secondaryColor,
  //       ),
  //       label: ("Applied"),
  //       tooltip: "Applied"
  //     ),
  //     const BottomNavigationBarItem(
  //       icon: Icon(Icons.file_copy_outlined, color: AppColors.whiteColor),
  //       activeIcon: Icon(
  //         Icons.file_copy_sharp,
  //         color: AppColors.secondaryColor,
  //       ),
  //       label: ("Internships"),
  //       tooltip: "Internships"
  //     ),
  //     const BottomNavigationBarItem(
  //       icon: Icon(Icons.person_outline_sharp, color: AppColors.whiteColor),
  //       activeIcon: Icon(Icons.person, color: AppColors.secondaryColor),
  //       label: ("Profile"),
  //       tooltip: "Profile"
  //     ),
  //   ];
  // }
}
