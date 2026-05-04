import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';

typedef TappedCallback = dynamic Function(int value);

class CustomNavBar extends StatefulWidget {
  final List<Widget>? screens;

  const CustomNavBar({super.key, this.screens});

  @override
  State<CustomNavBar> createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar> {
  ValueNotifier<int> currentIndex = ValueNotifier(0);

  Widget getTabWidget(int index) {
    return widget.screens![index];
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: currentIndex,
      builder: (context, int value, child) {
        return Column(
          children: [
            Expanded(child: getTabWidget(value)),
            Container(
              decoration: const BoxDecoration(
                color: AppColors.navBarColor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(43),
                  topLeft: Radius.circular(43),
                ),
                // boxShadow: [
                //   BoxShadow(
                //       color: Colors.black38,
                //       spreadRadius: 0,
                //       blurRadius: 10)
                // ]
              ),
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: BottomNavigationBar(
                elevation: 0,
                currentIndex: value,
                type: BottomNavigationBarType.fixed,
                backgroundColor: AppColors.transparentColor,
                showSelectedLabels: true,
                showUnselectedLabels: true,
                selectedItemColor: AppColors.secondaryColor,
                unselectedItemColor: Colors.white,
                useLegacyColorScheme: false,
                iconSize: 25,
                selectedLabelStyle: AppStyles.customTextStyle(
                  size: 12,
                  weight: FontWeight.w500,
                  color: AppColors.secondaryColor,
                ),
                unselectedLabelStyle: AppStyles.customTextStyle(
                  size: 12,
                  weight: FontWeight.w500,
                  color: AppColors.whiteColor,
                ),
                items: _trainerNavBarsItems(),
                onTap: (index) {
                  setState(() {
                    currentIndex.value = index;
                  });
                },
              ),
            ),
          ],
        );
      },
    );
  }

  List<BottomNavigationBarItem> _trainerNavBarsItems() {
    return [
      const BottomNavigationBarItem(
        icon: Icon(Icons.home_outlined, color: AppColors.whiteColor),
        label: "Home",
        activeIcon: Icon(Icons.home, color: AppColors.secondaryColor),
      ),
      const BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.location, color: AppColors.whiteColor),
        activeIcon: Icon(
          CupertinoIcons.location_fill,
          color: AppColors.secondaryColor,
        ),
        label: ("Applies"),
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.file_copy_outlined, color: AppColors.whiteColor),
        activeIcon: Icon(
          Icons.file_copy_sharp,
          color: AppColors.secondaryColor,
        ),
        label: ("Internships"),
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.person_outline_sharp, color: AppColors.whiteColor),
        activeIcon: Icon(Icons.person, color: AppColors.secondaryColor),
        label: ("Profile"),
      ),
    ];
  }
}
